defmodule TimeManagerApiWeb.WorkingTimeController do
  use TimeManagerApiWeb, :controller
  require Logger
  alias TimeManagerApi.Timesheet
  alias TimeManagerApi.Timesheet.WorkingTime
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Attendance
  alias TimeManagerApi.WorkingTimeService



  action_fallback TimeManagerApiWeb.FallbackController

  # GET /api/workingtimes
  def index(conn, _params) do
    working_times = Repo.all(WorkingTime)
    render(conn, "index.json", workingtimes: working_times)
  end


  # GET (ALL): /api/workingtime/:userID?start=XXX&end=YYY
  def index(conn, %{"userID" => user_id, "start" => start, "end" => end_time}) do
    workingtimes = Timesheet.list_workingtimes_for_user_in_range(user_id, start, end_time)
    render(conn, :index, workingtimes: workingtimes)
  end

  # GET (ONE): /api/workingtime/:userID/:id
  def show(conn, %{"userID" => user_id, "id" => id}) do
    working_time = Timesheet.get_working_time_for_user!(user_id, id)
    render(conn, :show, working_time: working_time)
  end

  # GET (ALL2): /api/workingtimes/:userID
  def index(conn, %{"userID" => user_id}) do
    # Récupérer tous les working_times avec les informations utilisateur
    working_times_with_user_info = Timesheet.list_workingtimes_for_user(user_id)
    # Rendre la réponse JSON avec les informations de chaque working_time et utilisateur
    render(conn, "get_all.json", workingtimes: working_times_with_user_info)
  end

  # POST: /api/workingtime/:userID
  # Exemple de body de requête POST
  #   {
  #     "start": "2024-10-11T12:00:00Z",
  #     "end": "2024-10-11T15:00:00Z"
  #   }
  def create(conn, %{"userID" => user_id} = params) do
    start_time = params["start"]
    end_time = params["end"]

    # Vérifier si les paramètres start et end sont présents
    if is_nil(start_time) or is_nil(end_time) do
      conn
      |> put_status(:bad_request)
      |> json(%{message: "Les paramètres start et end sont requis"})
      |> halt()
    end

    # Vérifier si le paramètre start est au bon format
    case NaiveDateTime.from_iso8601(start_time) do
      {:ok, _} -> :ok  # Continue si c'est au bon format
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "The start parameter must be in ISO8601 format"})
        |> halt()
    end

    # Vérifier si le paramètre end est au bon format
    case NaiveDateTime.from_iso8601(end_time) do
      {:ok, _} -> :ok  # Continue si c'est au bon format
      {:error, _} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "The end parameter must be in ISO8601 format"})
        |> halt()
    end

    # Calculer la différence en minutes
    total_time = NaiveDateTime.diff(NaiveDateTime.from_iso8601!(end_time), NaiveDateTime.from_iso8601!(start_time), :minute)

    # Créer un nouveau working_time
    user_id_int = String.to_integer(user_id)
    case WorkingTimeService.create_working_time(%{"start" => start_time, "end" => end_time, "user_id" => user_id_int, "total_time" => total_time}) do
      {:ok, _} -> :ok
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(changeset)
    end

    # Réponse finale réussie
    conn
    |> put_status(:ok)
    |> json(%{message: "The working time has been created successfully", working_time: %{start: start_time, end: end_time, user_id: user_id, total_time: total_time}})
  end



  # PUT: /api/workingtime/:id
    # {
    #   "start": "2024-10-11T12:00:00Z",
    #   "end": "2024-10-11T15:00:00Z"
    # }
    def update(conn, %{"id" => id} = params) do
      start_time = params["start"]
      end_time = params["end"]

      # Vérifier si les paramètres start et end sont présents
      if is_nil(start_time) or is_nil(end_time) do
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Les paramètres start et end sont requis"})
        |> halt()
      end

      # Vérifier si le paramètre start est au bon format
      case NaiveDateTime.from_iso8601(start_time) do
        {:ok, _} -> :ok  # Continue si c'est au bon format
        {:error, _} ->
          conn
          |> put_status(:bad_request)
          |> json(%{message: "The start parameter must be in ISO8601 format"})
          |> halt()
      end

      # Vérifier si le paramètre end est au bon format
      case NaiveDateTime.from_iso8601(end_time) do
        {:ok, _} -> :ok  # Continue si c'est au bon format
        {:error, _} ->
          conn
          |> put_status(:bad_request)
          |> json(%{message: "The end parameter must be in ISO8601 format"})
          |> halt()
      end

      # Calculer la différence en minutes
      total_time = NaiveDateTime.diff(NaiveDateTime.from_iso8601!(end_time), NaiveDateTime.from_iso8601!(start_time), :minute)

      # Récupérer le working_time par son id
      working_time = WorkingTimeService.get_working_time_by_id(id)

      # Vérifier si le working_time existe
      if is_nil(working_time) do
        conn
        |> put_status(:not_found)
        |> json(%{message: "The working time with ID #{id} does not exist"})
        |> halt()
      end

      # Mettre à jour le working_time
      case WorkingTimeService.update_working_time(working_time, %{"start" => start_time, "end" => end_time, "total_time" => total_time}) do
        {:ok, _} -> :ok
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(changeset)
      end

      # Réponse finale réussie
      conn
      |> put_status(:ok)
      |> json(%{message: "The working time has been updated successfully", working_time: %{start: start_time, end: end_time, total_time: total_time}})
    end

  # DELETE: /api/workingtime/:id
  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimeService.get_working_time_by_id(id)

    IO.inspect(working_time, label: "Working Time")

    # Vérifier si le working_time existe
    if is_nil(working_time) do
      conn
      |> put_status(:not_found)
      |> json(%{message: "The working time with ID #{id} does not exist", result: false})
      |> halt()
    end

    # Supprimer le working_time
    WorkingTimeService.delete_working_time(working_time)

    # Réponse finale réussie
    conn
    |> put_status(:ok)
    |> json(%{message: "The working time has been deleted successfully", result: true})
  end
end

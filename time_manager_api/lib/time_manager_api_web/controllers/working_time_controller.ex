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
  def indexA(conn, %{"userID" => user_id}) do
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

         # Ajouter les secondes si elles sont absentes
    start_time = if String.length(start_time) == 16 do
      start_time <> ":00Z"
    else
      start_time
    end

    end_time = if String.length(end_time) == 16 do
      end_time <> ":00Z"
    else
      end_time
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

      # Ajouter les secondes si elles sont absentes
    start_time = if String.length(start_time) == 16 do
      start_time <> ":00Z"
    else
      start_time
    end

    end_time = if String.length(end_time) == 16 do
      end_time <> ":00Z"
    else
      end_time
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

    # Récupérer les working times quotidiens des 7 derniers jours
def get_workingtimes_daily(conn, %{"userID" => user_id}) do
  user_id = String.to_integer(user_id)
  working_times = WorkingTimeService.get_workingtimes_for_last_days(user_id, 7)

  conn
  |> put_status(:ok)
  |> json(working_times)
end

# Récupérer les working times hebdomadaires des 4 dernières semaines
def get_workingtimes_weekly(conn, %{"userID" => user_id}) do
  user_id = String.to_integer(user_id)
  working_times = WorkingTimeService.get_workingtimes_for_last_weeks(user_id, 4)

  conn
  |> put_status(:ok)
  |> json(working_times)
end

# Récupérer les working times mensuels des 6 derniers mois
def get_workingtimes_monthly(conn, %{"userID" => user_id}) do
  user_id = String.to_integer(user_id)
  working_times = WorkingTimeService.get_workingtimes_for_last_months(user_id, 6)

  conn
  |> put_status(:ok)
  |> json(working_times)
end


    # GET /api/workingtime/today/:userID
  def get_working_times_today(conn, %{"userID" => user_id}) do
    IO.inspect(user_id, label: "User ID")
    today = Date.utc_today()
    # convert user id to int
    user_id = String.to_integer(user_id)

    working_times = WorkingTimeService.get_workingtimes_for_today(user_id)

    conn
    |> put_status(:ok)
    |> json(working_times)

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

  def count(conn, _params) do
    current_time = DateTime.utc_now()
    current_month = current_time.month
    current_year = current_time.year

    # Récupérer le nombre total de working_times et d'utilisateurs distincts
    working_times_count = WorkingTimeService.count(current_month, current_year)
    users_count = WorkingTimeService.count_users(current_month, current_year)

    # Renvoyer les deux valeurs dans la réponse JSON
    conn
    |> put_status(:ok)
    |> json(%{
      working_times_count: working_times_count,
      users_count: users_count
    })
  end


  # GET : /api/workingtimes/by_organisation/:organisation_id
  def by_organisation(conn, %{"organisation_id" => organisation_id}) do
    import Ecto.Query
    working_times =
      from(wt in TimeManagerApi.WorkingTime,
        join: u in TimeManagerApi.User, on: wt.user_id == u.id,
        join: uro in TimeManagerApi.UserRoleOrganisation, on: u.id == uro.user_id,
        where: uro.organisation_id == ^organisation_id,
        select: %{working_time: wt, user_name: u.username, user_email: u.email}
      )
      |> TimeManagerApi.Repo.all()

    json(conn, working_times)
  end

  # GET : /api/workingtimes/count_by_organisation/:organisation_id
def count_by_organisation(conn, %{"organisation_id" => organisation_id}) do
  import Ecto.Query

  # Compter le nombre total de working_times pour l'organisation spécifiée
  working_times_count =
    from(wt in TimeManagerApi.WorkingTime,
      join: u in TimeManagerApi.User, on: wt.user_id == u.id,
      join: uro in TimeManagerApi.UserRoleOrganisation, on: u.id == uro.user_id,
      where: uro.organisation_id == ^organisation_id,
      select: count(wt.id)
    )
    |> TimeManagerApi.Repo.one() || 0  # Récupère le total ou 0 si aucun résultat

  conn
  |> put_status(:ok)
  |> json(%{working_times_count: working_times_count})
end


end

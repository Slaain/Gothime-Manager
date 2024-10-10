defmodule TimeManagerApiWeb.WorkingTimeController do
  use TimeManagerApiWeb, :controller
  require Logger
  alias TimeManagerApi.Timesheet
  alias TimeManagerApi.Timesheet.WorkingTime
  alias TimeManagerApi.Repo


  action_fallback TimeManagerApiWeb.FallbackController

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

  # POST: /api/workingtime/:userID
  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    # Si "start" et "end" sont fournis, on calcule la différence en minutes
    total_time = case {working_time_params["start"], working_time_params["end"]} do
      {start_str, end_str} when not is_nil(start_str) and not is_nil(end_str) ->
        # Log des valeurs reçues
        Logger.debug("Start time: #{start_str}")
        Logger.debug("End time: #{end_str}")

        # Conversion en NaiveDateTime
        start = NaiveDateTime.from_iso8601!(start_str)
        end_time = NaiveDateTime.from_iso8601!(end_str)

        # Log des objets NaiveDateTime créés
        Logger.debug("Parsed start time: #{inspect(start)}")
        Logger.debug("Parsed end time: #{inspect(end_time)}")

        # Calcul de la différence en minutes
        time_diff = NaiveDateTime.diff(end_time, start, :minute)

        # Log de la différence de temps calculée
        Logger.debug("Time difference in minutes: #{time_diff}")

        time_diff

      _ ->
        # Log si l'un des champs est manquant
        Logger.error("Missing start or end time in the parameters")
        nil
    end

    # Ajouter ou mettre à jour le champ total_time dans les paramètres
    Logger.debug("total_time: #{inspect(total_time)}")

    working_time_params = Map.put(working_time_params, "total_time", total_time)
    Logger.debug("working_time_params: #{inspect(working_time_params)}")



    # Créer un changeset avec les paramètres modifiés
    changeset = WorkingTime.changeset(%WorkingTime{}, Map.put(working_time_params, "user_id", user_id))

    Logger.debug("Changeset: #{inspect(changeset)}")

    case Repo.insert(changeset) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{working_time.id}")
        |> json(%{
          id: working_time.id,
          start: working_time.start,
          end: working_time.end,
          total_time: working_time.total_time
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end





  # PUT: /api/workingtime/:id
  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Timesheet.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Timesheet.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  # DELETE: /api/workingtime/:id
  def delete(conn, %{"id" => id}) do
    working_time = Timesheet.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Timesheet.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
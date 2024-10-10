defmodule TimeManagerApiWeb.WorkingTimeController do
  use TimeManagerApiWeb, :controller

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

  # GET (ALL2): /api/workingtimes/:userID
  def index(conn, %{"userID" => user_id}) do
    # Récupérer tous les working_times avec les informations utilisateur
    working_times_with_user_info = Timesheet.list_workingtimes_for_user(user_id)
    # Rendre la réponse JSON avec les informations de chaque working_time et utilisateur
    render(conn, "get_all.json", workingtimes: working_times_with_user_info)
  end


  # POST: /api/workingtime/:userID
  def create(conn, %{"userID" => user_id, "working_time" => working_time_params}) do
    working_time_params = Map.put_new(working_time_params, "end", nil)  # Si end n'est pas fourni, il reste nil
    changeset = WorkingTime.changeset(%WorkingTime{}, Map.put(working_time_params, "user_id", user_id))

    case Repo.insert(changeset) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/workingtime/#{user_id}/#{working_time.id}")
        |> render("show.json", working_time: working_time)

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

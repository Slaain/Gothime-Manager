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

  # GET (ALL2): /api/workingtimes/:userID
  def index(conn, %{"userID" => user_id}) do
    # Récupérer tous les working_times avec les informations utilisateur
    working_times_with_user_info = Timesheet.list_workingtimes_for_user(user_id)
    # Rendre la réponse JSON avec les informations de chaque working_time et utilisateur
    render(conn, "get_all.json", workingtimes: working_times_with_user_info)
  end


  # POST: /api/workingtime/:userID
  # def create(conn, %{"user_id" => user_id, "clocks" => clocks_params}) do
  #   # Vérifier si une clock existe pour cet utilisateur
  #   case TimeManager.get_last_clock_for_user(user_id) do
  #     nil ->
  #       # Si aucune clock n'existe, en créer une nouvelle
  #       new_clock_params = Map.put(clocks_params, "user_id", user_id)

  #       with {:ok, %Clocks{} = clocks} <- TimeManager.create_clocks(new_clock_params) do
  #         conn
  #         |> put_status(:created)
  #         |> put_resp_header("location", ~p"/api/clocks/#{clocks.id}")
  #         |> render(:show, clocks: clocks)
  #       else
  #         {:error, changeset} ->
  #           conn
  #           |> put_status(:unprocessable_entity)
  #           |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
  #       end

  #     %Clocks{} = existing_clock ->
  #       # Si une clock existe, la renvoyer ou mettre à jour si nécessaire
  #       conn
  #       |> put_status(:ok)
  #       |> render(:show, clocks: existing_clock)
  #   end
  # end


  # PUT: /api/workingtime/:id
def update(conn, %{"id" => id, "working_time" => working_time_params}) do
  working_time = Timesheet.get_working_time!(id)

  # Appliquer la même logique de formatage que dans create
  total_time = case {working_time_params["start"], working_time_params["end"]} do
    {start_str, end_str} when not is_nil(start_str) and not is_nil(end_str) ->
      # Ajouter ":00" si la longueur du string est 16 (YYYY-MM-DDTHH:MM)
      start_str = if String.length(start_str) == 16, do: start_str <> ":00", else: start_str
      end_str = if String.length(end_str) == 16, do: end_str <> ":00", else: end_str

      # Conversion en NaiveDateTime
      start = NaiveDateTime.from_iso8601!(start_str)
      end_time = NaiveDateTime.from_iso8601!(end_str)

      # Calcul de la différence en minutes
      NaiveDateTime.diff(end_time, start, :minute)

    _ -> nil
  end

  # Ajouter ou mettre à jour le champ total_time dans les paramètres
  working_time_params = Map.put(working_time_params, "total_time", total_time)

  # Mise à jour de la working_time avec les nouveaux paramètres
  with {:ok, %WorkingTime{} = working_time} <- Timesheet.update_working_time(working_time, working_time_params) do
    render(conn, :showWithoutData, working_time: working_time)
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

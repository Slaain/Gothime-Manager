defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Clock

  def create(conn, %{"user_id" => user_id}) do
    # Récupère l'heure actuelle
    time = NaiveDateTime.utc_now()

    # Appel à la fonction pour modifier la dernière clock avec l'heure actuelle
    case Attendance.modify_clock(user_id, time) do
      {:ok, clock} ->
        conn
        |> put_status(:ok)
        |> json(%{
          id: clock.id,
          status: clock.status,
          time: clock.time,
          user_id: clock.user_id
        })

      {:error, message} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: message})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end


  def index(conn, %{"user_id" => user_id}) do
    clocks = Attendance.get_clocks_by_user(user_id)

        conn
        |> put_status(:ok)
        |> json(clocks)
  end
end

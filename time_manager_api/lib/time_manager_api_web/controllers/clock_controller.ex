defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Attendance  # Corrige ici l'alias vers le bon module

  def create(conn, %{"clock" => clock_params}) do
    case Attendance.create_clock(clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: clock.id,
          status: clock.status,
          time: clock.time,
          user_id: clock.user_id
        })

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

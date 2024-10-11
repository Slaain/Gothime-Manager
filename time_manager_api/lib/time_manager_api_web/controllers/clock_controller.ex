defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Clock

  def create(conn, %{"user_id" => user_id}) do
    # Get the current time
    time = NaiveDateTime.utc_now()

    # Try to modify the last clock or create a new one if it doesn't exist
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

      {:error, "No clock found for this user"} ->
        # If no clock exists, create a new one
        create_new_clock(conn, user_id, time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  # Helper function to create a new clock if none exists
  defp create_new_clock(conn, user_id, time) do
    clock_params = %{
      "user_id" => user_id,
      "time" => time,
      "status" => true  # Assuming a new clock starts as 'true'
    }

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
end

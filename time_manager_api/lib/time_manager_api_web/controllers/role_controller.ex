defmodule TimeManagerApiWeb.RoleController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService
  alias TimeManagerApi.WorkingTimeService
  alias TimeManagerApi.RoleService


  def show(conn, _params) do
    user_id = conn.assigns[:current_user]

    IO.inspect(user_id)

    user_role = RoleService.get_user_role(user_id)

    conn
    |> put_status(:ok)
    |> json(%{role: user_role})
  end

end

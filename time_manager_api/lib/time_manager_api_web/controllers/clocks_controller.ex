# defmodule TimeManagerApiWeb.ClocksController do
#   use TimeManagerApiWeb, :controller

#   alias TimeManagerApi.TimeManager
#   alias TimeManagerApi.TimeManager.Clocks

#   action_fallback TimeManagerApiWeb.FallbackController

#   def index(conn, _params) do
#     clocks = TimeManager.list_clocks()
#     render(conn, :index, clocks: clocks)
#   end

#   def create(conn, %{"clocks" => clocks_params}) do
#     with {:ok, %Clocks{} = clocks} <- TimeManager.create_clocks(clocks_params) do
#       conn
#       |> put_status(:created)
#       |> put_resp_header("location", ~p"/api/clocks/#{clocks}")
#       |> render(:show, clocks: clocks)
#     end
#   end

#   def show(conn, %{"id" => id}) do
#     clocks = TimeManager.get_clocks!(id)
#     render(conn, :show, clocks: clocks)
#   end

#   def update(conn, %{"id" => id, "clocks" => clocks_params}) do
#     clocks = TimeManager.get_clocks!(id)

#     with {:ok, %Clocks{} = clocks} <- TimeManager.update_clocks(clocks, clocks_params) do
#       render(conn, :show, clocks: clocks)
#     end
#   end

#   def delete(conn, %{"id" => id}) do
#     clocks = TimeManager.get_clocks!(id)

#     with {:ok, %Clocks{}} <- TimeManager.delete_clocks(clocks) do
#       send_resp(conn, :no_content, "")
#     end
#   end
# end

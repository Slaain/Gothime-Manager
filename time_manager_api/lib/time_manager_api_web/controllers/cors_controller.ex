defmodule TimeManagerApiWeb.CORSController do
  use TimeManagerApiWeb, :controller

  def options(conn, _params) do
    conn
    |> put_resp_header("access-control-allow-origin", "http://localhost:5173")
    |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS, PUT, DELETE")
    |> put_resp_header("access-control-allow-headers", "Content-Type, Authorization")
    |> put_resp_header("access-control-max-age", "86400")  # Optionnel : pour permettre aux navigateurs de ne pas refaire les requêtes pré-vol
    |> send_resp(:no_content, "")
  end
end

defmodule TimeManagerApiWeb.Plugs.CORS do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> put_resp_header("access-control-allow-origin", "*")
    |> put_resp_header("access-control-allow-methods", "GET, POST, OPTIONS, PUT, DELETE")
    |> put_resp_header("access-control-allow-headers", "Content-Type, Authorization")
    |> handle_preflight()
  end

  defp handle_preflight(%{method: "OPTIONS"} = conn) do
    conn
    |> send_resp(:no_content, "")
    |> halt()
  end

  defp handle_preflight(conn), do: conn
end

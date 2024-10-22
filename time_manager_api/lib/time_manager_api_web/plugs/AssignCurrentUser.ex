defmodule TimeManagerApiWeb.Plugs.AssignCurrentUser do
  import Plug.Conn
  alias TimeManagerApi.Guardian

  def init(default), do: default

  def call(conn, _opts) do
    token =
      case get_req_header(conn, "authorization") do
        ["Bearer " <> token] -> token
        _ -> nil
      end

    case token && Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        assign(conn, :current_user, claims["sub"])

      _ ->
        # Pas d'erreur si le token est absent ou invalide
        conn
    end
  end
end

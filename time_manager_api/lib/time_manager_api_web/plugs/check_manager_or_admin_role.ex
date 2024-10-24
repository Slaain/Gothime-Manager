defmodule TimeManagerApiWeb.Plugs.CheckManagerOrAdminRole do
  import Plug.Conn
  import Phoenix.Controller
  alias TimeManagerApi.{Guardian, RoleService}

  def init(default), do: default

  def call(conn, _opts) do
    # Récupérer le token depuis le header Authorization
    token =
      case get_req_header(conn, "authorization") do
        ["Bearer " <> token] -> token
        _ -> nil
      end

    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        user_id = claims["sub"]

        # Récupérer le rôle de l'utilisateur
        case RoleService.get_user_role(user_id) do
          role when role in ["manager", "admin"] ->
            assign(conn, :current_user, user_id)  # Continuer si rôle = admin ou manager
          _ ->
            conn
            |> put_status(:forbidden)
            |> json(%{error: "Unauthorized: You must be an admin or manager"})
            |> halt()
        end

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Unauthorized"})
        |> halt()
    end
  end
end

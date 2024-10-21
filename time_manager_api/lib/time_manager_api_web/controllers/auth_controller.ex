defmodule TimeManagerApiWeb.AuthController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.User
  alias TimeManagerApi.Repo
  alias Bcrypt
  alias TimeManagerApi.Guardian  # Import Guardian ici
  alias TimeManagerApi.UserService

  # Inscription d'un utilisateur
  def register(conn, %{"email" => email, "username" => username, "password" => password}) do
    case UserService.create_user(%{"email" => email, "username" => username, "password" => password}) do
      {:ok, user} ->
        json(conn, %{message: "User created successfully", user: user})

      {:error, changeset} ->
        errors = changeset.errors
                  |> Enum.map(fn {field, {message, _}} -> {field, message} end)

        conn
        |> put_status(:bad_request)
        |> json(%{error: "User creation failed", reasons: errors})
    end
  end



    # Connexion d'un utilisateur
    def login(conn, %{"email" => email, "password" => password}) do
      user = Repo.get_by(User, email: email)

      case check_password(user, password) do
        {:ok, user} ->
          # Génération du token JWT avec Guardian
          {:ok, token, _claims} = Guardian.encode_and_sign(user, %{})

          # Renvoyer la réponse avec le token
          conn
          |> json(%{message: "Login successful", user: user, token: token})

        {:error, :invalid_password} ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Invalid credentials"})

        {:error, :invalid_user} ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "User not found"})
      end
    end

    defp check_password(nil, _password), do: {:error, :invalid_user}
    defp check_password(user, password) do
      case Bcrypt.check_pass(user, password) do
        {:ok, user} -> {:ok, user}
        _ -> {:error, :invalid_password}
      end
    end
end

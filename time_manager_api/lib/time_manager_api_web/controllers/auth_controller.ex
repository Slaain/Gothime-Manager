defmodule TimeManagerApiWeb.AuthController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.Accounts.User
  alias TimeManagerApi.Repo
  alias Bcrypt  # Assurez-vous que c'est bien le module bcrypt_elixir
  alias TimeManagerApi.UserService

  # Inscription d'un utilisateur
  def register(conn, %{"email" => email, "username" => username, "password" => password}) do
    # Création d'un utilisateur
    case UserService.create_user(%{"email" => email, "username" => username, "password" => password}) do
      {:ok, user} ->
        json(conn, %{message: "User created successfully", user: user})

      {:error, changeset} ->
        # Récupération des erreurs et des messages de validation
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
    IO.inspect(user, label: "User retrieved")

    case check_password(user, password) do
      {:ok, user} ->
        conn
        |> json(%{message: "Login successful", user: user})

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



  defp check_password(nil, _password), do: Bcrypt.no_user_verify() && false
  defp check_password(user, password), do: Bcrypt.check_pass(user, password)
end

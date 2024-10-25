
defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Accounts
  alias TimeManagerApi.User
  alias TimeManagerApi.UserService

  action_fallback TimeManagerApiWeb.FallbackController

  # Action pour lister les utilisateurs en fonction des paramètres fournis
  def index(conn, %{"email" => email, "username" => username}) do
    users = Accounts.get_users_by_email_and_username(email, username)
    render(conn, :index, users: users)
  end

  def index(conn, %{"email" => email}) do
    users = Accounts.get_users_by_email(email)
    render(conn, :index, users: users)
  end

  def index(conn, %{"username" => username}) do
    users = Accounts.get_users_by_username(username)
    render(conn, :index, users: users)
  end

  # Si aucun paramètre n'est fourni, liste tous les utilisateurs
  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  # Action pour créer un nouvel utilisateur
  def create(conn, %{"user" => user_params}) do

    # Vérifier si les paramètres requis sont présents et ne sont pas vide
    required_params = ["email", "username", "password", "role_id", "organisation_id"]
    Enum.each(required_params, fn param ->
      if Map.get(user_params, param) == nil do
        conn
        |> put_status(:bad_request) # Indique que la requête est incorrecte
        |> json(%{message: "Missing required parameter: #{param}", result: false}) # Renvoyer un message d'erreur
        |> halt() # Arrêter le traitement
      end
    end)


    # Verifier si le nom d'utilisateur a entre 2 et 30 caractères
    if String.length(user_params["username"]) < 2 or String.length(user_params["username"]) > 30 do
      conn
      |> put_status(:bad_request) # Indique que la requête est incorrecte
      |> json(%{message: "Username must be between 2 and 30 characters", result: false}) # Renvoyer un message d'erreur
      |> halt() # Arrêter le traitement
    end

    # Vérifier si l'email est valide
    if String.match?(user_params["email"], ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/) == false do
      conn
      |> put_status(:bad_request) # Indique que la requête est incorrecte
      |> json(%{message: "Invalid email address", result: false}) # Renvoyer un message d'erreur
      |> halt() # Arrêter le traitement
    end

    # Verifier si l'utilisateur existe déjà
    user = UserService.get_user_by_email(user_params["email"])
    if user do
      conn
      |> put_status(:conflict) # Indique que la ressource existe déjà
      |> json(%{message: "The user already exists", result: false}) # Renvoyer un message d'erreur
      |> halt() # Arrêter le traitement
    end

    # Créer un utilisateur avec les paramètres fournis
    user = UserService.create_user(user_params)
    conn
    |> put_status(:created) # Indique que la ressource a été créée
    |> json(%{message: "User created", result: true}) # Renvoyer un message de succès



  end

  # Action pour afficher un utilisateur par son ID
  def show(conn, %{"id" => id}) do

    # Récupérer l'utilisateur par son ID
    user = UserService.get_user(id)

    # Vérifier si l'utilisateur existe
    if user do
      conn
      |> put_status(:ok) # Indique que la requête a réussi
      |> json(%{message: "User found", result: true, user: user}) # Renvoyer l'utilisateur trouvé
    else
      conn
      |> put_status(:not_found) # Indique que la ressource n'a pas été trouvée
      |> json(%{message: "Invalid credentials", result: false}) # Renvoyer un message d'erreur
    end


  end

  # Action pour mettre à jour un utilisateur
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserService.get_user(id)

    IO.inspect(user_params, label: "user_params")

    if user do
      case UserService.update_user(user, user_params) do
        {:ok, updated_user} ->
          conn
          |> put_status(:ok)
          |> json(%{message: "User updated", result: true, user: updated_user})

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              message: "Update failed",
              result: false,
              errors: Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
            })
      end
    else
      conn
      |> put_status(:not_found)
      |> json(%{message: "User not found", result: false})
    end
  end

  # Action pour supprimer un utilisateur
  def delete(conn, %{"id" => id}) do
    # Récupérer l'utilisateur par son ID

    user = UserService.get_user(id)

    # Vérifier si l'utilisateur existe
    if user do
      # Supprimer l'utilisateur
      UserService.delete_user(user)
      conn
      |> put_status(:ok) # Indique que la requête a réussi
      |> json(%{message: "User deleted", result: true}) # Renvoyer un message de succès
    else
      conn
      |> put_status(:not_found) # Indique que la ressource n'a pas été trouvée
      |> json(%{message: "Invalid credentials", result: false}) # Renvoyer un message d'erreur
    end
  end

  # Action pour obtenir une liste paginée d'utilisateurs
  def paginated_users(conn, %{"limit" => limit, "offset" => offset}) do
    limit = String.to_integer(limit)
    offset = String.to_integer(offset)

    users = UserService.get_paginated_employees(limit, offset)
    total_users = UserService.count_users()
    total_pages = Float.ceil(total_users / limit)

    conn
    |> put_status(:ok) # Indique que la requête a réussi
    |> json(%{message: "Paginated users", result: true, users: users,     total_pages: total_pages,
    current_page: offset / limit + 1,
    total_users: total_users}) # Renvoyer la liste paginée d'utilisateurs
  end

  # Action sans offset/limit par défaut (valeurs par défaut)
  def paginated_users(conn, _params) do
    users = Accounts.get_paginated_users(10, 0) # Par défaut, 10 utilisateurs, offset 0
    render(conn, :index, users: users)
  end
end

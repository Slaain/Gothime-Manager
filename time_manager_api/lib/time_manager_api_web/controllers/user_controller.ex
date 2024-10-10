defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Accounts
  alias TimeManagerApi.Accounts.User

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
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created) # Indique que la ressource a été créée
      |> put_resp_header("location", ~p"/api/users/#{user.id}") # Lien vers la nouvelle ressource
      |> render(:show, user: user) # Rendre la vue avec l'utilisateur créé
    end
  end

  # Action pour afficher un utilisateur par son ID
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  # Action pour mettre à jour un utilisateur
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user) # Rendre la vue avec l'utilisateur mis à jour
    end
  end

  # Action pour supprimer un utilisateur
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "") # Répondre avec un statut 204 No Content
    end
  end



    # Action pour obtenir une liste paginée d'employés
    def paginated_employees(conn, %{"limit" => limit, "offset" => offset}) do
      limit = String.to_integer(limit)
      offset = String.to_integer(offset)

      employees = Accounts.get_paginated_employees(limit, offset)
      render(conn, :index, users: employees)
    end

    # Action sans offset/limit par défaut (valeurs par défaut)
    def paginated_employees(conn, _params) do
      employees = Accounts.get_paginated_employees(10, 0) # Par défaut, 10 employés, offset 0
      render(conn, :index, users: employees)
    end



end

defmodule TimeManagerApiWeb.UserController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.Accounts
  alias TimeManagerApi.Accounts.User

  action_fallback TimeManagerApiWeb.FallbackController

  @doc """
  Handles GET requests for users, with optional filters for email and username.
  """
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

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  @doc """
  Handles POST requests to create a new user.
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc """
  Handles GET requests to fetch a specific user by ID.
  """
  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  @doc """
  Handles PUT requests to update an existing user.
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc """
  Handles DELETE requests to delete a specific user.
  """
  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

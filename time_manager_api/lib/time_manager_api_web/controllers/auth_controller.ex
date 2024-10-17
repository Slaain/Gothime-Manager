defmodule TimeManagerApiWeb.AuthController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.User
  alias TimeManagerApi.Guardian

  def register(conn, %{"username" => username, "email" => email, "password" => password}) do
    case User.register_user(%{"username" => username, "email" => email, "password" => password}) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> json(%{data: user})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case User.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> json(%{token: Guardian.encode_and_sign(user)})

      :error ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end
end

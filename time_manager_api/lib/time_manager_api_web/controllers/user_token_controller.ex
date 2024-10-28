defmodule TimeManagerApiWeb.UserTokenController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.{Repo, UserToken}

  def generate_token(conn, %{"user_id" => user_id}) do
    token = :crypto.strong_rand_bytes(32) |> Base.encode64()  # Génère un token unique

    %UserToken{}
    |> UserToken.changeset(%{user_id: user_id, token: token})
    |> Repo.insert()
    |> case do
      {:ok, _user_token} ->
        json(conn, %{message: "Token generated successfully", token: token})
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Token generation failed"})
    end
  end

  def get_token(conn, %{"user_id" => user_id}) do
    token = Repo.get_by(UserToken, user_id: user_id)

    if token do
      conn
      |> put_status(:ok)
      |> json(%{token: token.token})
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "Token not found for this user"})
    end
  end
end

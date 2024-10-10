defmodule TimeManagerApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Accounts.User

  @doc """
  Returns the list of users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets users by email and username.
  """
  def get_users_by_email_and_username(email, username) do
    Repo.all(from u in User, where: u.email == ^email and u.username == ^username)
  end

  @doc """
  Gets users by email.
  """
  def get_users_by_email(email) do
    Repo.all(from u in User, where: u.email == ^email)
  end

  @doc """
  Gets users by username.
  """
  def get_users_by_username(username) do
    Repo.all(from u in User, where: u.username == ^username)
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end



  # Fonction pour récupérer les employés avec pagination
  def get_paginated_employees(limit, offset) do
    User
    |> order_by([u], asc: u.username)
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
  end
end

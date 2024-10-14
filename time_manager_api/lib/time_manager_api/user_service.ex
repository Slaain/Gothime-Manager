defmodule TimeManagerApi.UserService do
  @moduledoc """
  The ClockService context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias TimeManagerApi.Repo
  alias TimeManagerApi.User

  # Créer un utilisateur
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  # Récupérer un utilisateur par son email
  def get_user_by_email(email) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
  end

  # Récupérer un utilisateur par son ID
  def get_user(id) do
    User
    |> where([u], u.id == ^id)
    |> Repo.one()
  end

  def get_users(id, limit, offset) do
    query = from(u in User,
                 where: u.id == ^id,
                 limit: ^limit,
                 offset: ^offset)

    Repo.all(query)
  end

  def get_paginated_employees(limit, offset) do
    from(u in User,
      order_by: [asc: u.id],  # Option de tri
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end


  # Mettre à jour un utilisateur
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  # Supprimer un utilisateur
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end




end

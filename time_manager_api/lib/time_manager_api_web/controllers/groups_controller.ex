defmodule TimeManagerApiWeb.GroupController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.{Repo, Group, User, GroupUser}

  # Liste des groupes
  def index(conn, _params) do
    groups = Repo.all(Group) |> Repo.preload(:users) # charge les utilisateurs associés
    render(conn, "index.json", groups: groups)
  end
  # Créer un groupe
  # Créer un groupe
  def create(conn, %{"group" => group_params}) do
    changeset = Group.changeset(%Group{}, group_params)

    case Repo.insert(changeset) do
      {:ok, group} ->
        conn
        |> put_status(:created)
        |> json(%{group: %{id: group.id, name: group.name, start_date: group.start_date, end_date: group.end_date}})

      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  # Afficher un groupe spécifique
  def show(conn, %{"id" => id}) do
    group = Repo.get!(Group, id) |> Repo.preload(:users)
    render(conn, "show.json", group: group)
  end

  # Ajouter un utilisateur à un groupe
  def add_user(conn, %{"group_id" => group_id, "user_id" => user_id}) do
    # Rechercher le groupe et l'utilisateur
    group = Repo.get!(Group, group_id)
    user = Repo.get!(User, user_id)

    # Insérer dans la table de jointure avec les timestamps
    now = NaiveDateTime.utc_now()

    case Repo.insert_all("groups_users", [%{group_id: group.id, user_id: user.id, inserted_at: now, updated_at: now}]) do
      {1, _} ->  # Vérifie si l'insertion a réussi
        conn
        |> put_status(:ok)
        |> json(%{message: "User added to group", group: group})
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error adding user"})
    end
  end

  # Supprimer un utilisateur d'un groupe
  def remove_user(conn, %{"group_id" => group_id, "user_id" => user_id}) do
    group = Repo.get!(Group, group_id) |> Repo.preload(:users)
    user = Repo.get!(User, user_id)

    updated_users = Enum.reject(group.users, fn u -> u.id == user.id end)

    changeset = Ecto.Changeset.change(group)
                |> Ecto.Changeset.put_assoc(:users, updated_users) # Retirer l'utilisateur

    case Repo.update(changeset) do
      {:ok, group} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User removed from group", group: group})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error removing user", changeset: changeset})
    end
  end
    # Supprimer un groupe
    def delete(conn, %{"id" => id}) do
      group = Repo.get!(Group, id)

      case Repo.delete(group) do
        {:ok, _group} ->
          conn
          |> put_status(:ok)
          |> json(%{message: "Group deleted successfully"})
        {:error, _changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{message: "Error deleting group"})
      end
    end
  end
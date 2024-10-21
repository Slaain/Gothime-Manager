defmodule TimeManagerApiWeb.OrganisationController do
  use TimeManagerApiWeb, :controller

  alias TimeManagerApi.{Repo, Organisation, Group, OrganisationGroup}

  # Liste des organisations
  def index(conn, _params) do
    organisations = Repo.all(Organisation) |> Repo.preload(:groups)
    json(conn, TimeManagerApiWeb.OrganisationJSON.index(%{organisations: organisations}))
  end

  # Afficher une organisation spécifique
  def show(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id) |> Repo.preload(:groups)
    json(conn, TimeManagerApiWeb.OrganisationJSON.show(%{organisation: organisation}))
  end

  # Créer une organisation
  def create(conn, %{"organisation" => organisation_params}) do
    changeset = Organisation.changeset(%Organisation{}, organisation_params)

    case Repo.insert(changeset) do
      {:ok, organisation} ->
        conn
        |> put_status(:created)
        |> json(%{organisation: %{id: organisation.id, name: organisation.name}})

      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  # Ajouter un groupe dans une organisation
  def add_group(conn, %{"organisation_id" => organisation_id, "group_id" => group_id}) do
    group = Repo.get!(Group, group_id)
    organisation = Repo.get!(Organisation, organisation_id)

    now = NaiveDateTime.utc_now()

    case Repo.insert_all("organisation_groups", [%{organisation_id: organisation.id, group_id: group.id, inserted_at: now, updated_at: now}]) do
      {1, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Group added to organisation", organisation: organisation})

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error adding group"})
    end
  end

  # Supprimer un groupe d'une organisation
  def remove_group(conn, %{"organisation_id" => organisation_id, "group_id" => group_id}) do
    organisation = Repo.get!(Organisation, organisation_id) |> Repo.preload(:groups)
    group = Repo.get!(Group, group_id)

    updated_groups = Enum.reject(organisation.groups, fn u -> u.id == group.id end)

    changeset = Ecto.Changeset.change(organisation)
                |> Ecto.Changeset.put_assoc(:groups, updated_groups)

    case Repo.update(changeset) do
      {:ok, organisation} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Group removed from organisation", organisation: organisation})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error removing group", changeset: changeset})
    end
  end

  # Mettre à jour une organisation
  def update(conn, %{"id" => id, "organisation" => organisation_params}) do
    organisation = Repo.get!(Organisation, id)

    changeset = Organisation.changeset(organisation, organisation_params)

    case Repo.update(changeset) do
      {:ok, updated_organisation} ->
        conn
        |> put_status(:ok)
        |> json(%{organisation: %{id: updated_organisation.id, name: updated_organisation.name}})

      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end

  # Supprimer une organisation
  def delete(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id)

    case Repo.delete(organisation) do
      {:ok, _organisation} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Organisation deleted successfully"})

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error deleting organisation"})
    end
  end
end

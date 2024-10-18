defmodule TimeManagerApiWeb.OrganisationController do
  use TimeManagerApiWeb, :controller

  #alias TimeManagerApi.OrganisationManager
  #alias TimeManagerApi.OrganisationManager.Organisation

  alias TimeManagerApi.{Repo, Organisation,Group, User,OrganisationGroup, GroupUser}

 # Liste des organisations
 def index(conn, _params) do
  organisations = Repo.all(Organisation) |> Repo.preload(:groups) # charge les utilisateurs associés
  render(conn, :index, organisations: organisations)

end

  def new(conn, _params) do
    changeset = OrganisationManager.change_organisation(%Organisation{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"organisation" => organisation_params}) do
    changeset = Organisation.changeset(%Organisation{}, organisation_params)
    case Repo.insert(changeset) do
      {:ok, organisation} ->
        conn
        |> put_flash(:info, "Organisation created successfully.")
        |> put_status(:created)
        |> json(%{organisation: %{id: organisation.id, name: organisation.name}})

      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: errors})
    end
  end


  def show(conn, %{"id" => id}) do
    organisation = Repo.get!(Organisation, id) |> Repo.preload(:groups)
    render(conn, :show, organisation: organisation)
  end

   # Ajouter un groupe dans une organisation
   def add_group(conn, %{"organisation_id" => organisation_id, "group_id" => group_id}) do

    # Rechercher le groupe et l'organisation
    group = Repo.get!(Group, group_id)
    organisation = Repo.get!(Organisation, organisation_id)

    # Insérer dans la table de jointure avec les timestamps
    now = NaiveDateTime.utc_now()

    case Repo.insert_all("organisation_groups", [%{organisation_id: organisation.id, group_id: group.id, inserted_at: now, updated_at: now}]) do
      {1, _} ->  # Vérifie si l'insertion a réussi
        conn
        |> put_status(:ok)
        |> json(%{message: "Group added to organisation", organisation: organisation})
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Error adding group"})
    end
  end

  # Supprimer un group dans une organisation
  def remove_group(conn, %{"organisation_id" => organisation_id, "group_id" => group_id}) do
    organisation = Repo.get!(Organisation, organisation_id) |> Repo.preload(:groups)
    group = Repo.get!(Group, group_id)

    updated_groups = Enum.reject(organisation.groups, fn u -> u.id == group.id end)

    changeset = Ecto.Changeset.change(organisation)
                |> Ecto.Changeset.put_assoc(:groups, updated_groups) # Retirer le groupe

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


  def edit(conn, %{"id" => id}) do
    organisation = OrganisationManager.get_organisation!(id)
    changeset = OrganisationManager.change_organisation(organisation)
    render(conn, :edit, organisation: organisation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "organisation" => organisation_params}) do
    organisation = Repo.get!(Organisation, id)

    changeset =
      organisation
      |> Organisation.changeset(%{
        name: Map.get(organisation_params, "name", organisation.name),
      })

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

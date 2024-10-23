defmodule TimeManagerApi.OrganisationService do

  import Ecto.Query, warn: false

  alias TimeManagerApi.{Repo, Organisation, User, UserRoleOrganisation, Role}

  # Les fonctions que tu avais déjà

  def list_organisations do
    Repo.all(Organisation)
    |> Repo.preload(:groups)
  end

  def get_organisation!(id) do
    Repo.get!(Organisation, id)
    |> Repo.preload(:groups)
  end

  def create_organisation(attrs) do
    %Organisation{}
    |> Organisation.changeset(attrs)
    |> Repo.insert()
  end

  def update_organisation(organisation, attrs) do
    organisation
    |> Organisation.changeset(attrs)
    |> Repo.update()
  end

  def delete_organisation(organisation) do
    Repo.delete(organisation)
  end

  # Fonction pour récupérer les utilisateurs d'une organisation avec leur clock
  def get_users_by_organisation(organisation_id) do
    Organisation
    |> Repo.get(organisation_id)
    |> Repo.preload(users: [:clock, :user_role_organisation])
  end

end

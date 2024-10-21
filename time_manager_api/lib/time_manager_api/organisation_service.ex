defmodule TimeManagerApi.OrganisationService do
  alias TimeManagerApi.{Repo, Organisation}

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
end

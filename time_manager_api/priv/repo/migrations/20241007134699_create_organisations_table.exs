defmodule TimeManagerApi.Repo.Migrations.CreateOrganisationsTable do
  use Ecto.Migration

  def change do
    create table(:organisations) do
      add :name, :string
      timestamps()
    end

  end
end


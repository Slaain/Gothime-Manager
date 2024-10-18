defmodule TimeManagerApi.Repo.Migrations.CreateOrganisationGroupsTable do
  use Ecto.Migration

  def change do
    create table(:organisation_groups) do
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :group_id, references(:groups, on_delete: :delete_all)

      timestamps()
    end
    create index(:organisation_groups, [:organisation_id])
    create index(:organisation_groups, [:group_id])

  end
end

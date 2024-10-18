defmodule YourApp.Repo.Migrations.CreateUserRoleOrganisationTable do
  use Ecto.Migration

  def change do
    create table(:user_role_organisation) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :role_id, references(:roles, on_delete: :delete_all), null: false
      add :organisation_ids, {:array, :integer}, default: []

      timestamps()
    end

    create unique_index(:user_role_organisation, [:user_id, :role_id])
  end
end

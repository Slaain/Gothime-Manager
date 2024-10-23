defmodule TimeManagerApi.Repo.Migrations.CreateUserRoleOrganisation do
  use Ecto.Migration

  def change do
    create table(:user_role_organisation) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :organisation_id, references(:organisations, on_delete: :delete_all)
      add :role_id, references(:roles, on_delete: :delete_all)

      timestamps()
    end

    create index(:user_role_organisation, [:user_id])
    create index(:user_role_organisation, [:organisation_id])
    create index(:user_role_organisation, [:role_id])
  end
end

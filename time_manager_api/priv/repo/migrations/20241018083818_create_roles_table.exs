defmodule TimeManagerApi.Repo.Migrations.CreateRolesTable do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string, null: false, unique: true

      timestamps()
    end
  end
end

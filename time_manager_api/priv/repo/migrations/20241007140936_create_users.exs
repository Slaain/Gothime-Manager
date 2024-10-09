defmodule TimeManagerApi.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string, unique: true

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
#op

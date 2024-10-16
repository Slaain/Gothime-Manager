defmodule TimeManagerApi.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string
      add :start_date, :naive_datetime
      add :end_date, :naive_datetime

      timestamps()
    end
  end
end

defmodule TimeManagerApi.Repo.Migrations.CreateWorkingtimes do
  use Ecto.Migration

  def change do
    create table(:workingtimes) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)
      add :total_time, :integer
      timestamps(type: :utc_datetime)
    end

    create index(:workingtimes, [:user_id])
  end
end
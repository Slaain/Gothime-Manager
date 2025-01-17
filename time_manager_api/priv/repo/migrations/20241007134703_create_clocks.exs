defmodule TimeManagerApi.Repo.Migrations.CreateClocks do
  use Ecto.Migration
  # git push
  def change do
    create table(:clocks) do
      add :time, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:clocks, [:user_id])
  end
end

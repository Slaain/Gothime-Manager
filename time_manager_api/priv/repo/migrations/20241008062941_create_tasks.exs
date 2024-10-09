defmodule TimeManagerApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end
  end
end
#op

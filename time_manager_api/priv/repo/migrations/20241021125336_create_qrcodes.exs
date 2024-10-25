defmodule TimeManagerApi.Repo.Migrations.CreateQRCodes do
  use Ecto.Migration

  def change do
    create table(:qrcodes) do
      add :organization_id, :integer, null: false
      add :token, :string, null: false
      add :expires_at, :naive_datetime, null: false

      timestamps()
    end
  end
end

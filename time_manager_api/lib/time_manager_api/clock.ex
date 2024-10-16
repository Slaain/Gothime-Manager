defmodule TimeManagerApi.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :status, :time, :user_id, :inserted_at, :updated_at]}
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    #field :user_id, :id

    # Une clock appartient à un utilisateur
    belongs_to :user, TimeManagerApi.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
  end
end

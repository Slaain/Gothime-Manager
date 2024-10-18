defmodule TimeManagerApi.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email, :inserted_at, :updated_at, :clock]} # Ajoute :clock pour inclure la clock dans le JSON
  schema "users" do
    field :username, :string
    field :email, :string

    # Un utilisateur a une seule clock
    has_one :clock, TimeManagerApi.Clock

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
  end
end

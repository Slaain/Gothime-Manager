defmodule TimeManagerApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false  # Import Ecto.Query pour utiliser les fonctions

  schema "users" do
    field :username, :string
    field :email, :string

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

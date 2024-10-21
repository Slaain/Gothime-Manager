defmodule TimeManagerApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  @derive {Jason.Encoder, only: [:id, :username, :email, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :clock, TimeManagerApi.Clock
    has_many :user_role_organisations, TimeManagerApi.UserRoleOrganisation, on_delete: :delete_all


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))  # Utilisation correcte
    end
  end
end

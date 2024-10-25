defmodule TimeManagerApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  alias TimeManagerApi.{Repo, User, UserRoleOrganisation, Role, Organisation}


  @derive {Jason.Encoder, only: [:id, :username, :email, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    has_one :clock, TimeManagerApi.Clock
    has_many :user_role_organisation, TimeManagerApi.UserRoleOrganisation, on_delete: :delete_all
    has_many :organisations, through: [:user_role_organisation, :organisation]


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])
    |> validate_required([:username, :email])
    |> validate_password()
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp validate_password(changeset) do
    if get_field(changeset, :password) do
      changeset
      |> validate_length(:password, min: 6)
      |> validate_required([:password])
    else
      changeset
    end
  end


  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(password))  # Utilisation correcte
    end
  end
end

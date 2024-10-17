defmodule TimeManagerApi.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt  # Assurez-vous d'avoir Comeonin pour le hachage des mots de passe

  @derive {Jason.Encoder, only: [:id, :username, :email, :inserted_at, :updated_at, :clock]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true  # Champ virtuel pour le mot de passe

    # Un utilisateur a une seule clock
    has_one :clock, TimeManagerApi.Clock

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password])  # Inclure :password ici
    |> validate_required([:username, :email, :password])  # Inclure :password pour validation
    |> unique_constraint(:email)
    # Ne pas appeler put_pass_hash ici
  end

  def register_user(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> put_pass_hash(attrs["password"])  # Passer le mot de passe ici
    |> TimeManagerApi.Repo.insert()
  end

  defp put_pass_hash(changeset, password) when is_binary(password) do
    password_hash = Bcrypt.hash_pwd_salt(password)
    put_change(changeset, :password_hash, password_hash)
  end

  def authenticate_user(email, password) do
    user = TimeManagerApi.Repo.get_by(__MODULE__, email: email)

    if user && Bcrypt.check_pw(password, user.password_hash) do
      {:ok, user}
    else
      :error
    end
  end
end

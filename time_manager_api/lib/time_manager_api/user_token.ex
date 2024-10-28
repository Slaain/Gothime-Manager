defmodule TimeManagerApi.UserToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias TimeManagerApi.User

  schema "user_tokens" do
    field :token, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  def changeset(user_token, attrs) do
    user_token
    |> cast(attrs, [:user_id, :token])
    |> validate_required([:user_id, :token])
  end
end

defmodule TimeManagerApi.QRCode do
  use Ecto.Schema
  import Ecto.Changeset

  schema "qrcodes" do
    field :organization_id, :integer
    field :token, :string
    field :expires_at, :naive_datetime  # To store when the token expires

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(qrcode, attrs) do
    qrcode
    |> cast(attrs, [:organization_id, :token, :expires_at])
    |> validate_required([:organization_id, :token, :expires_at])
  end
end

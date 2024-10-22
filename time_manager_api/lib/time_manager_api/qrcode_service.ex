# in your app: `lib/time_manager_api/qrcode/qrcode_service.ex`

defmodule TimeManagerApi.QRCodeService do
  alias TimeManagerApi.Repo
  alias TimeManagerApi.QRCode
  alias Bcrypt
  alias TimeManagerApi.Guardian
  alias TimeManagerApi.RoleService
  alias TimeManagerApi.QRCodeService
  alias TimeManagerApi.JWTService
  alias TimeManagerApi.QRCode

  import Ecto.Query, warn: false

  @token_lifetime_in_seconds 15

def generate_qr_code(organization_id) do
  token = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
  expires_at = NaiveDateTime.utc_now() |> NaiveDateTime.add(@token_lifetime_in_seconds, :second) |> NaiveDateTime.truncate(:second)

  %QRCode{
    organization_id: organization_id,
    token: token,
    expires_at: expires_at
  }
  |> Repo.insert()
end

  # Retrieves the QR code for an organization
  def get_qr_code_for_org(organization_id) do
    from(q in QRCode, where: q.organization_id == ^organization_id, order_by: [desc: q.inserted_at])
    |> Repo.one()
  end


  # Validates the token and checks if it is still valid
  def validate_token(organization_id, token) do
    # Rechercher le QRCode correspondant à l'organisation
    qr_code =
      from(q in QRCode,
        where: q.organization_id == ^organization_id and q.token == ^token
      )
      |> Repo.one()

    case qr_code do
      nil ->
        {:error, :invalid_or_expired} # Aucun QR code trouvé ou token incorrect

      %QRCode{expires_at: expires_at} ->
        # Vérifier si le token a expiré
        if NaiveDateTime.compare(expires_at, NaiveDateTime.utc_now()) == :gt do
          {:ok, :valid} # Token valide
        else
          {:error, :invalid_or_expired} # Token expiré
        end
    end
  end

  def get_qrcode_by_organization(organization_id) do
    from(q in QRCode, where: q.organization_id == ^organization_id)

    |> Repo.one()
  end

  # Updates an existing QR code
  def update_qr_code(%QRCode{} = qr_code) do
    new_token = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
    new_expiration = NaiveDateTime.utc_now() |> NaiveDateTime.add(2 * 60, :second) |> NaiveDateTime.truncate(:second)

    qr_code
    |> QRCode.changeset(%{token: new_token, expires_at: new_expiration})
    |> Repo.update()
  end

  # Automatically refresh the token if it's expired
  def refresh_token_if_needed(organization_id) do
    # case get_qr_code_for_org(organization_id) do
    #   %QRCode{expires_at: expires_at} = qrcode when NaiveDateTime.compare(expires_at, NaiveDateTime.utc_now()) == :lt ->
    #     # Token expired, generate a new one
    #     generate_qr_code(organization_id)
    #   _ ->
    #     :ok
    # end
  end
end

# in your app: `lib/time_manager_api/qrcode/qrcode_service.ex`

defmodule TimeManagerApi.QRCodeService do
  alias TimeManagerApi.Repo
  alias TimeManagerApi.QRCode
  import Ecto.Query, warn: false

  @token_lifetime_in_minutes 2

  # Generates a new QR code token
  def generate_qr_code(organization_id) do
    token = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)
    expires_at = NaiveDateTime.add(NaiveDateTime.utc_now(), @token_lifetime_in_minutes * 60, :second)

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

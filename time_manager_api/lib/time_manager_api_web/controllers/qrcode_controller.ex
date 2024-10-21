# in your app: `lib/time_manager_api_web/controllers/qrcode_controller.ex`

defmodule TimeManagerApiWeb.QRCodeController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.QRCodeService

  def beep(conn, %{"organization_id" => org_id, "token" => token, "user_id" => user_id}) do
    org_id = String.to_integer(org_id)

    case QRCodeService.validate_token(org_id, token) do
      {:ok, :valid} ->
        # Proceed with your existing clock-in logic
        IO.puts("Valid token, processing clock-in for user #{user_id}")
        # You can call your existing function for clock-in here
        # Example:
        # ClockService.clock_in_user(user_id)
        conn
        |> put_status(:ok)
        |> json(%{message: "Access granted, clock-in successful"})

      {:error, :invalid_or_expired} ->
        QRCodeService.refresh_token_if_needed(org_id)
        conn
        |> put_status(:forbidden)
        |> json(%{message: "Invalid or expired token, new QR code generated"})
    end
  end

  def generate_qr(conn, %{"organization_id" => organization_id}) do
    organization_id = String.to_integer(organization_id)

    # Generate a new QR code for the organization
    case QRCodeService.generate_qr_code(organization_id) do
      {:ok, qr_code} ->
        conn
        |> put_status(:created)
        |> json(%{message: "QR code generated", qr_code: qr_code.token})

      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Failed to generate QR code"})
    end
  end
end

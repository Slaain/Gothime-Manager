# in your app: `lib/time_manager_api_web/controllers/qrcode_controller.ex`

defmodule TimeManagerApiWeb.QRCodeController do
  use TimeManagerApiWeb, :controller
  alias TimeManagerApi.QRCodeService
  alias TimeManagerApi.JWTService
  alias TimeManagerApi.RoleService
  alias TimeManagerApi.QRCode  # Ensure the alias is here
  alias TimeManagerApi.Repo


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

  # test
  # def test(conn, _params) do
  #   token =
  #     case get_req_header(conn, "authorization") do
  #       ["Bearer " <> token] -> token
  #       _ -> nil
  #     end

  #   # IO.inspect(token, label: "Token from Authorization header")

  #   result = JWTService.decode_token(token)

  #   IO.inspect(result, label: "Decoded token")


  #   conn
  #   |> put_status(:ok)*
  #   |> json(%{message: "QR code test endpoint"})
  # end

  def test(conn, %{"organizationId" => token}) do
# Récupérer l'utilisateur actuel
    current_user = conn.assigns[:current_user]

    conn
    |> put_status(:ok)
    |> json(%{message: "QR code test endpoint", current_user: current_user})
    end

    def generate_qr(conn, %{"organizationId" => organization_id}) do
      user_id = conn.assigns[:current_user]
      organization_id = String.to_integer(organization_id)

      IO.inspect(organization_id, label: "Organization ID")

      true_organization_ids = RoleService.get_user_organisation_id(user_id)
      IO.inspect(true_organization_ids, label: "True Organization IDs")



      if true_organization_ids == organization_id do

        # Check if a QR code already exists for this organization
        case QRCodeService.get_qrcode_by_organization(organization_id) do
          nil ->
            # If no QR code exists, generate a new one
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

          %QRCode{} = existing_qr ->
            # If a QR code already exists, overwrite it
            case QRCodeService.update_qr_code(existing_qr) do
              {:ok, updated_qr_code} ->
                conn
                |> put_status(:ok)
                |> json(%{message: "QR code updated", qr_code: updated_qr_code.token})

              {:error, _changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> json(%{message: "Failed to update QR code"})
            end
        end
      else
        # L'utilisateur n'a pas les droits pour cette organisation
        conn
        |> put_status(:forbidden)
        |> json(%{message: "You do not have access to this organization"})
      end
    end

    def get_token(conn, %{"organizationId" => organization_id}) do
      user_id = conn.assigns[:current_user]
      organization_id = String.to_integer(organization_id)

      # Vérifier si l'utilisateur fait partie de l'organisation
      true_organization_ids = RoleService.get_user_organisation_id(user_id)

      IO.inspect(organization_id, label: "orga")
      IO.inspect(true_organization_ids, label: "true org")
      IO.inspect(true_organization_ids ==organization_id )
      if true_organization_ids == organization_id do
        # Récupérer le token de l'organisation
        case QRCodeService.get_qrcode_by_organization(organization_id) do
          %QRCode{token: token} ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Token retrieved", token: token})

          nil ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "No QR code found for this organization"})
        end
      else
        conn
        |> put_status(:forbidden)
        |> json(%{error: "You are not part of this organization"})
      end
    end



end

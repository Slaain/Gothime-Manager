defmodule TimeManagerApi.Guardian do
  use Guardian, otp_app: :time_manager_api

  alias TimeManagerApi.User
  alias TimeManagerApi.Repo

  # Définition de la fonction pour encoder et signer un token
  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Repo.get(User, id) do
      nil -> {:error, :resource_not_found}
      user -> {:ok, user}
    end
  end


end

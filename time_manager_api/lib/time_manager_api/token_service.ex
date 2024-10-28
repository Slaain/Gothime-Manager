defmodule TimeManagerApi.TokenService do
  alias TimeManagerApi.{Repo, UserToken}

  # Fonction de validation du token utilisateur
  def validate_user_token(user_id, token) do
    case Repo.get_by(UserToken, user_id: user_id, token: token) do
      nil ->
        :error  # Si aucun token trouvé, retourne :error
      %UserToken{} ->
        :ok  # Si un token valide est trouvé, retourne :ok
    end
  end
end

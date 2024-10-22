defmodule TimeManagerApi.JWTService do
  @moduledoc """
  Module pour gérer les tokens JWT.
  """

  alias Bcrypt
  alias TimeManagerApi.Guardian

  use Joken.Config


  # Fonction pour décoder et vérifier le token JWT
  def decode_token(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        {:ok, claims}

      {:error, _reason} ->
        {:error, :invalid_token}
    end
  end





  # Fonction pour générer un token JWT
  def generate_token(claims) do
    JWT.sign(@secret_key, %{"alg" => "HS256"}, claims)
    |> JWT.compact()
  end
end

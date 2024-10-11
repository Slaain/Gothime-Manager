defmodule TimeManagerApiWeb.PageController do
  use TimeManagerApiWeb, :controller

  def index(conn, _params) do
    # Si tu as un fichier HTML pour servir ton frontend Vue.js, tu peux le rendre ici.
    # Sinon, tu peux simplement afficher un message pour l'instant.
    text(conn, "Bienvenue sur la page d'accueil de TimeManager")
  end
end

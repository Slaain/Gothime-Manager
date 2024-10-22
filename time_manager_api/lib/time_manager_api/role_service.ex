defmodule TimeManagerApi.RoleService do
  import Ecto.Query, warn: false
  alias TimeManagerApi.{Repo, Role, UserRoleOrganisation}

  # Fonction pour récupérer le rôle d'un utilisateur via son user_id
  def get_user_role(user_id) do
    # Chercher l'association entre l'utilisateur et le rôle
    user_role_query =
      from uro in UserRoleOrganisation,
      where: uro.user_id == ^user_id,
      join: r in Role, on: uro.role_id == r.id,
      select: r.name

    # Exécuter la requête et récupérer le nom du rôle
    Repo.one(user_role_query)
  end

  # Recuperer l'id de l'organisation
  def get_user_organisation_id(user_id) do
    # Chercher l'association entre l'utilisateur et le rôle
    user_role_query =
      from uro in UserRoleOrganisation,
      where: uro.user_id == ^user_id,
      select: uro.organisation_ids

    # Exécuter la requête et récupérer le nom du rôle
    Repo.one(user_role_query)
  end
end

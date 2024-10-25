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


  # Vérifier si l'utilisateur est déjà dans l'organisation
  def user_in_organisation?(user_id, organisation_id) do
    query = from(our in UserRoleOrganisation,
      where: our.user_id == ^user_id and our.organisation_id == ^organisation_id
    )

    Repo.exists?(query)
  end

  # Ajouter un utilisateur à une organisation
  def add_user_to_organisation(user_id, organisation_id, role_id) do
    %UserRoleOrganisation{}
    |> UserRoleOrganisation.changeset(%{user_id: user_id, organisation_id: organisation_id, role_id: role_id})
    |> Repo.insert()
  end
end

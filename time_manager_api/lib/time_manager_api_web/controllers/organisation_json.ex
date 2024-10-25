defmodule TimeManagerApiWeb.OrganisationJSON do
  alias TimeManagerApi.Organisation

  @doc """
  Renders a list of organisations.
  """
  def index(%{organisations: organisations}) do
    %{data: render_organisations(organisations)}
  end

  @doc """
  Renders a single organisation.
  """
  def show(%{organisation: organisation}) do
    %{data: render_organisation(organisation)}
  end

  @doc """
  Renders a single organisation with groups and users.
  """
  def show_with_users(%{organisation: organisation}) do
    %{
      id: organisation.id,
      name: organisation.name,
      groups: render_groups_with_users(organisation.groups)  # Assurez-vous d'utiliser la fonction correcte pour afficher les groupes avec utilisateurs
    }
  end

  # Helper pour rendre une organisation avec les groupes associés
  defp render_organisation(%Organisation{id: id, name: name, groups: groups}) do
    %{
      id: id,
      name: name,
      groups: render_groups(groups)
    }
  end

  # Helper pour rendre une organisation avec les groupes et les utilisateurs associés
  defp render_organisation_with_users(organisation, groups) do
    %{
      id: organisation.id,
      name: organisation.name,
      groups: render_groups_with_users(groups)
    }
  end

  # Helper pour rendre une liste de groupe
  defp render_groups(groups) do
    Enum.map(groups, fn group ->
      %{
        id: group.id,
        groupname: group.name
      }
    end)
  end

  # Helper pour rendre une liste de groupes avec utilisateurs associés
  defp render_groups_with_users(groups) do
    Enum.map(groups, fn group ->
      %{
        id: group.id,
        groupname: group.name,
        users: render_users(group.users)  # Vous devez également définir cette fonction pour afficher les utilisateurs
      }
    end)
  end

  # Helper pour rendre une liste d'utilisateurs
  defp render_users(users) do
    Enum.map(users, fn user ->
      %{
        id: user.id,
        name: user.name,
        email: user.email # Ajoutez d'autres attributs si nécessaire
      }
    end)
  end

  defp render_organisations(organisations) do
    Enum.map(organisations, &render_organisation/1)
  end

end

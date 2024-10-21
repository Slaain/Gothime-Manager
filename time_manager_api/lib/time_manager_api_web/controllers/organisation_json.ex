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

  # Helper pour rendre une organisation avec les groupes associés
  defp render_organisation(%Organisation{id: id, name: name, groups: groups}) do
    %{
      id: id,
      name: name,
      groups: render_groups(groups)
    }
  end

  defp render_organisations(organisations) do
    Enum.map(organisations, &render_organisation/1)
  end

  # Helper pour rendre une liste de groupe
  defp render_groups(groups) do
    Enum.map(groups, fn group ->
      %{
        id: group.id,
        groupname: group.name,
      }
    end)
  end
end

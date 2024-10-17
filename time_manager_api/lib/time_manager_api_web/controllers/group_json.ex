defmodule TimeManagerApiWeb.GroupJSON do
  alias TimeManagerApi.Group

  @doc """
  Renders a list of groups.
  """
  def index(%{groups: groups}) do
    %{data: render_groups(groups)}
  end

  @doc """
  Renders a single group.
  """
  def show(%{group: group}) do
    %{data: render_group(group)}
  end

  # Helper pour rendre un groupe avec les utilisateurs associés
  defp render_group(%Group{id: id, name: name, start_date: start_date, end_date: end_date, users: users}) do
    %{
      id: id,
      name: name,
      start_date: start_date,
      end_date: end_date,
      users: render_users(users)
    }
  end

  defp render_groups(groups) do
    Enum.map(groups, &render_group/1)
  end

  # Helper pour rendre une liste d'utilisateurs
  defp render_users(users) do
    Enum.map(users, fn user ->
      %{
        id: user.id,
        username: user.username,  # Correction ici
        email: user.email
      }
    end)
  end
end

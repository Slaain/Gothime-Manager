defmodule TimeManagerApi.GroupService do
  alias TimeManagerApi.{Repo, Group}

  def list_groups do
    Repo.all(Group)
    |> Repo.preload(:users)
  end

  def get_group!(id) do
    Repo.get!(Group, id)
    |> Repo.preload(:users)
  end

  def create_group(attrs) do
    %Group{}
    |> Group.changeset(attrs)
    |> Repo.insert()
  end

  def update_group(group, attrs) do
    group
    |> Group.changeset(attrs)
    |> Repo.update()
  end

  def delete_group(group) do
    Repo.delete(group)
  end
end

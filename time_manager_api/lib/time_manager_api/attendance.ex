defmodule TimeManagerApi.Attendance do
  @moduledoc """
  The Attendance context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def delete_clock(id) do
    clock = Repo.get!(Clock, id)

    Repo.delete(clock)
  end

  def get_clocks() do
    Repo.all(Clock)
  end

  def get_clocks_by_user(user_id) do
    Repo.all(from c in Clock, where: c.user_id == ^user_id)
  end
end

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

   # Récupérer la dernière clock d'un utilisateur
   def get_last_clock_by_user(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> order_by([c], desc: c.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  # Modifier la dernière clock de l'utilisateur
  def modify_clock(user_id, time) do
    # Récupérer la dernière clock
    last_clock = get_last_clock_by_user(user_id)

    case last_clock do
      nil ->
        {:error, "No clock found for this user"}

      %Clock{} = clock ->
        # Inverser le status (toggle)
        new_status = !clock.status

        # Mettre à jour la clock avec le nouveau time et le nouveau status
        clock
        |> Clock.changeset(%{
          "time" => time,
          "status" => new_status
        })
        |> Repo.update()
    end
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

  def get_last_clock_by_user(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> order_by([c], desc: c.inserted_at)
    |> limit(1)
    |> Repo.one()
  end
end

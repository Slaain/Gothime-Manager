defmodule TimeManagerApi.WorkingTimeService do
  @moduledoc """
  The Attendance context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService


  # Récupérer le dernière working_time d'un utilisateur
  def get_last_working_time_by_user(user_id) do
    WorkingTime
    |> where([wt], wt.user_id == ^user_id)
    |> order_by([wt], desc: wt.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  # Modifier un working_time existant
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    total_time = NaiveDateTime.diff(attrs["end"], working_time.start, :minute)

    # Mettre à jour le total_time
    attrs = Map.put(attrs, "total_time", total_time)
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  # Créer un nouveau working_time
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end


end

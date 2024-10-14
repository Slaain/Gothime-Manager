defmodule TimeManagerApi.Attendance do
  @moduledoc """
  The Attendance context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime

  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> Repo.insert()
  end

  def test(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
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

  # Créer un nouveau working_time
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  # Mettre à jour un working_time existant
  def update_working_time(%WorkingTime{} = working_time, attrs) do

    total_time = NaiveDateTime.diff(attrs["end"], working_time.start, :minute)

    Logger.debug("attrs.end : #{inspect(attrs["end"])}")
    Logger.debug("working_time.start : #{inspect(working_time.start)}")

    Logger.debug("Totalaaa time calculé: #{total_time} minutes")

    attrs = Map.put(attrs, "total_time", total_time)

    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  # Récupérer le dernier working_time pour un utilisateur
  def get_last_working_time_by_user(user_id) do
    WorkingTime
    |> where([w], w.user_id == ^user_id)
    |> order_by([w], desc: w.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  # Modifier la dernière clock de l'utilisateur
  def modify_clock(user_id, time) do
    # Récupérer la dernière clock
    last_clock = get_last_clock_by_user(user_id)

    # Récupérer le dernier working_time pour l'utilisateur
    last_working_time = get_last_working_time_by_user(user_id)

    case last_clock do
      nil ->
        # Si aucune clock n'existe, en créer une nouvelle
        create_clock(%{"user_id" => user_id, "time" => time, "status" => true})

      %Clock{} = clock ->
        # Inverser le status (toggle)
        new_status = !clock.status

        # Mettre à jour la clock avec le nouveau time et le nouveau status
        clock_changeset = Clock.changeset(clock, %{
          "time" => time,
          "status" => new_status
        })

        case Repo.update(clock_changeset) do
          {:ok, updated_clock} ->
            # Si le statut passe à 'true', créer un nouveau working_time avec start = time
            if new_status do
              case last_working_time do
                %WorkingTime{start: _start, end: _end} ->
                  create_working_time(%{"start" => time, "user_id" => user_id})
                %WorkingTime{start: _start, end: nil} ->
                  {:error, "Le dernier working_time n'est pas complété."}
              end
            else
              case last_working_time do
                %WorkingTime{start: _start, end: nil} ->
                  update_working_time(last_working_time, %{"end" => time})
                _ ->
                  {:error, "Aucun working_time en cours trouvé."}
              end
            end

          {:error, changeset} ->
            {:error, changeset}
        end
    end
  end
end

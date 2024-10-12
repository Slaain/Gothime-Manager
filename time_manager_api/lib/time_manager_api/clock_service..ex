defmodule TimeManagerApi.ClockService do
  @moduledoc """
  The ClockService context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime

  def create_clock(attrs \\ %{}) do
    case Repo.insert(Clock.changeset(%Clock{}, attrs)) do
      {:ok, clock} -> clock  # Retourner directement la clock en cas de succès
      {:error, _changeset} -> nil  # Retourner nil en cas d'erreur (ou gérer l'erreur ici)
    end
  end


  # Toggle status
  def toggle_status(%Clock{} = clock) do
    new_status = !clock.status
    Clock.changeset(clock, %{"status" => new_status})
    |> Repo.update()
  end

  def get_clock_by_user(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> order_by([c], desc: c.inserted_at)
    |> limit(1)
    |> Repo.one()
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
    # Log pour debuguer l'entrée de la fonction
    Logger.debug("Modification de la clock pour l'utilisateur #{user_id} à l'heure #{time}")

    # Récupérer la dernière clock
    last_clock = get_last_clock_by_user(user_id)
    Logger.debug("Dernière clock récupérée : #{inspect(last_clock)}")

    # Récupérer le dernier working_time pour l'utilisateur
    last_working_time = get_last_working_time_by_user(user_id)
    Logger.debug("Dernier working_time récupéré : #{inspect(last_working_time)}")

    case last_working_time do
      nil ->
        # Troncature du temps pour enlever les microsecondes
        truncated_time = NaiveDateTime.truncate(time, :second)

        # Conversion de `user_id` en entier
        user_id_int = String.to_integer(user_id)

        working_time = %WorkingTime{start: truncated_time, user_id: user_id_int}  # Utilisation d'un entier pour user_id
        Logger.debug("Working_time créé : #{inspect(working_time)}")
        Repo.insert(working_time)

      _ ->
        Logger.debug("Working_time trouvé pour l'utilisateur #{user_id}")
    end


    # Si aucune clock n'existe, en créer une nouvelle
    case last_clock do
      nil ->
        Logger.debug("Aucune clock trouvée pour l'utilisateur #{user_id}, création d'une nouvelle clock")
        create_clock(%{"user_id" => user_id, "time" => time, "status" => true})
        {:ok, %Clock{}}  # Retourner un succès après la création de la clock

      %Clock{} = clock ->
        # Inverser le status (toggle)
        new_status = !clock.status
        Logger.debug("Nouveau status de la clock : #{new_status}")

        # Mettre à jour la clock avec le nouveau time et le nouveau status
        clock_changeset = Clock.changeset(clock, %{"time" => time, "status" => new_status})

        case Repo.update(clock_changeset) do
          {:ok, updated_clock} ->
            if new_status do
              Logger.debug("Le status de la clock est passé à true, création d'un nouveau working_time.")
              case last_working_time do
                %WorkingTime{start: _start, end: _end} ->
                  Logger.debug("Création d'un nouveau working_time.")
                  create_working_time(%{"start" => time, "user_id" => user_id})

                %WorkingTime{start: _start, end: nil} ->
                  Logger.error("Le dernier working_time n'est pas complété.")
                  {:error, "Le dernier working_time n'est pas complété."}
              end
            else
              Logger.debug("Le status de la clock est passé à false, mise à jour du dernier working_time.")
              case last_working_time do
                %WorkingTime{start: _start, end: nil} ->
                  update_working_time(last_working_time, %{"end" => time})
                _ ->
                  Logger.error("Aucun working_time en cours trouvé.")
                  {:error, "Aucun working_time en cours trouvé."}
              end
            end

          {:error, changeset} ->
            Logger.error("Erreur lors de la mise à jour de la clock : #{inspect(changeset)}")
            {:error, changeset}
        end
    end
  end


end

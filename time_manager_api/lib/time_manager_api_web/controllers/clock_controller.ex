defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService
  alias TimeManagerApi.WorkingTimeService


    # POST /api/clocks/:userID (Il n'y a pas de body requis)
    def beep(conn, %{"user_id" => user_id}) do
      # Récupérer l'heure et la formater
      truncated_time = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

      # Récupérer la dernière clock par utilisateur
      clock = ClockService.get_last_clock_by_user(user_id)

      # Si il n'y a pas de clock, en créer une et la réassigner à la variable clock
      clock = if is_nil(clock) do
        ClockService.create_clock(%{"user_id" => user_id, "time" => NaiveDateTime.utc_now(), "status" => true})
      else
        clock  # Si clock existe déjà, la garder telle qu'elle
      end

      IO.inspect(clock, label: "Clock after if")

      # Récupérer le dernier working_time
      last_working_time = WorkingTimeService.get_last_working_time_by_user(user_id)

      # Initialiser une variable pour savoir si un nouveau working_time a été créé
      new_working_time_created = case last_working_time do
        %WorkingTime{start: _start, end: nil} ->
          # Si un working_time est en cours, mettre à jour l'heure de fin et basculer le statut de la clock
          WorkingTimeService.update_working_time_without_start_attr(last_working_time, %{"end" => truncated_time})
          ClockService.toggle_status(clock)
          false  # Aucun nouveau working_time créé

        _ ->
          # Si le dernier working_time est terminé ou n'existe pas, en créer un nouveau
          user_id_int = String.to_integer(user_id)
          WorkingTimeService.create_working_time(%{"start" => truncated_time, "user_id" => user_id_int})
          true  # Nouveau working_time créé
      end

      # Réassigner le status de la clock après avoir basculé le statut
      clock = ClockService.get_last_clock_by_user(user_id) # Récupérer à nouveau après le toggle
      clock_status_after_toggle = clock.status

      # Déterminer le message à renvoyer en fonction de si un nouveau working_time a été créé
      message = if new_working_time_created do
        "Bonjour !"
      else
        "Au revoir !"
      end

      # Retourner la réponse avec le message et l'heure
      conn
      |> put_status(:ok)
      |> json(%{message: message, time: truncated_time})
    end

  def create(conn, %{"user_id" => user_id}) do
    Logger.debug("Démarrage de la création de clock pour l'utilisateur #{user_id}")
    # Obtenir l'heure actuelle
    time = NaiveDateTime.utc_now()

    Logger.debug("Heure actuelle obtenue : #{time}")

    # Modifier ou créer une nouvelle clock pour l'utilisateur
    case Attendance.modify_clock(user_id, time) do
      {:ok, clock} ->
        Logger.debug("Clock modifiée/créée avec succès pour l'utilisateur #{user_id}. Détails : #{inspect(clock)}")

        if clock.status do
          Logger.debug("Le status de la clock est 'true', création d'un nouveau working_time")
          # Si le status est true, créer un nouveau working time avec start = time
          case Attendance.create_working_time(%{"start" => time, "end" => nil, "user_id" => user_id}) do
            {:ok, working_time} ->
              Logger.debug("Working_time créé avec succès : #{inspect(working_time)}")
            {:error, changeset} ->
              Logger.error("Erreur lors de la création du working_time : #{inspect(changeset)}")
          end
        else
          # Si le status est false, mettre à jour le dernier working time avec end = time
          Logger.debug("Le status de la clock est 'false', récupération du dernier working_time pour l'utilisateur #{user_id}")
          case Attendance.get_last_working_time_by_user(user_id) do
            nil ->
              Logger.error("Aucun working_time à mettre à jour pour l'utilisateur #{user_id}")
            working_time ->
              Logger.debug("Dernier working_time récupéré : #{inspect(working_time)}")
              total_time = NaiveDateTime.diff(time, working_time.start, :minute)
              Logger.debug("Total time calculé : #{total_time} minutes")

              updated_data = %{"end" => time, "total_time" => total_time}
              case Attendance.update_working_time(working_time, updated_data) do
                {:ok, updated_working_time} ->
                  Logger.debug("Working time mis à jour avec succès : #{inspect(updated_working_time)}")
                {:error, changeset} ->
                  Logger.error("Erreur lors de la mise à jour du working_time : #{inspect(changeset)}")
              end
          end
        end

        # Répondre avec les informations de la clock
        conn
        |> put_status(:ok)
        |> json(%{
          id: clock.id,
          status: clock.status,  # Ceci vient bien de `Clock`
          time: clock.time,
          user_id: clock.user_id
        })

      {:error, "No clock found for this user"} ->
        Logger.error("Aucune clock trouvée pour l'utilisateur #{user_id}")
        # Si aucune clock n'existe, en créer une nouvelle
        create_new_clock(conn, user_id, time)

      {:error, changeset} ->
        Logger.error("Erreur lors de la modification de la clock : #{inspect(changeset)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Erreur lors de la modification de la clock", changeset: changeset})
    end
  end


  # Fonction pour créer une nouvelle clock si nécessaire
  defp create_new_clock(conn, user_id, time) do
    clock_params = %{
      "user_id" => user_id,
      "time" => time,
      "status" => true  # On commence une nouvelle clock avec `status` à `true`
    }

    case Attendance.create_clock(clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(%{
          id: clock.id,
          status: clock.status,  # Ceci provient uniquement de Clock
          time: clock.time,
          user_id: clock.user_id
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def countactive(conn, _params) do
    active_users_count = ClockService.countactive()
    json(conn, %{count: active_users_count})
  end

end

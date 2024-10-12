defmodule TimeManagerApiWeb.TestController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService
  alias TimeManagerApi.WorkingTimeService


  def create(conn, %{"start" => start_time, "end" => end_time, "user_id" => user_id}) do
    total_time = case {start_time, end_time} do
      {start_str, end_str} when not is_nil(start_str) and not is_nil(end_str) ->
        # Ajouter ":00" si la longueur du string est 16 (YYYY-MM-DDTHH:MM)
        start_str = if String.length(start_str) == 16, do: start_str <> ":00", else: start_str
        end_str = if String.length(end_str) == 16, do: end_str <> ":00", else: end_str

        # Conversion en NaiveDateTime
        start = NaiveDateTime.from_iso8601!(start_str)
        end_time = NaiveDateTime.from_iso8601!(end_str)

        # Calcul de la différence en minutes
        NaiveDateTime.diff(end_time, start, :minute)

      _ -> nil
    end
    # Ajouter un log pour voir ce qui est passé

    params = %{"start" => start_time, "end" => end_time, "user_id" => user_id, "total_time" => total_time}
    Logger.debug("Params passed: #{inspect(params)}")

    case Attendance.test(params) do
      {:ok, result} ->
        Logger.debug("Test passed successfully: #{inspect(result)}")
        conn
        |> put_status(:ok)
        |> json(%{message: "Test réussi", result: result})

      {:error, changeset} ->
        # Ajouter un log pour capturer l'erreur détaillée
        Logger.error("Test failed with changeset: #{inspect(changeset)}")
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Erreur", result: false})
    end
  end

  def beep(conn, %{"userID" => user_id}) do
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
        WorkingTimeService.update_working_time(last_working_time, %{"end" => truncated_time})
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




end

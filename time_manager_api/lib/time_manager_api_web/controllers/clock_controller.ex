defmodule TimeManagerApiWeb.ClockController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Clock

  def create(conn, %{"user_id" => user_id}) do
    # Obtenir l'heure actuelle
    time = NaiveDateTime.utc_now()

    # Modifier ou créer une nouvelle clock pour l'utilisateur
    case Attendance.modify_clock(user_id, time) do
      {:ok, clock} ->
        if clock.status do
          # Si le status est true, créer un nouveau working time avec start = time
          Logger.debug("Création d'un nouveau working time pour l'utilisateur #{user_id} avec un start à #{time}")
          Attendance.create_working_time(%{"start" => time, "end" => nil, "user_id" => user_id})
        else
          # Si le status est false, mettre à jour le dernier working time avec end = time
          case Attendance.get_last_working_time_by_user(user_id) do
            nil ->
              Logger.error("Aucun working time à mettre à jour pour l'utilisateur #{user_id}")
            working_time ->
              Logger.debug("Mise à jour du working time pour l'utilisateur #{user_id} avec end à #{time}")

              # Calcul du total_time en minutes
              total_time = NaiveDateTime.diff(time, working_time.start, :minute)

              # Vérification du calcul
              Logger.debug("Total time calculé: #{total_time} minutes")

              # Mise à jour du working time avec end et total_time
              updated_data = %{"end" => time, "total_time" => 2400}
              case Attendance.update_working_time(working_time, updated_data) do
                {:ok, updated_working_time} ->
                  Logger.debug("Working time mis à jour avec succès : #{inspect(updated_working_time)}")
                {:error, changeset} ->
                  Logger.error("Erreur lors de la mise à jour du working time : #{inspect(changeset)}")
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
        # Si aucune clock n'existe, en créer une nouvelle
        create_new_clock(conn, user_id, time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerApiWeb.ChangesetView, "error.json", changeset: changeset)
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
end

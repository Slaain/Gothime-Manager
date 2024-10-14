defmodule TimeManagerApiWeb.TestController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Clock


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

end

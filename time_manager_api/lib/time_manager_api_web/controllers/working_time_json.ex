defmodule TimeManagerApiWeb.WorkingTimeJSON do
  alias TimeManagerApi.Timesheet.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(working_time <- workingtimes, do: data(working_time))}
  end

  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: %{working_time: working_time, user_name: user_name, user_email: user_email}}) do
    %{
      data: %{
        id: working_time.id,
        start: working_time.start,
        end: working_time.end,
        user_id: working_time.user_id,  # Ajouter le user_id
        user_name: user_name,
        user_email: user_email
      }
    }
  end

  @doc """
  Renders a list of all working_times for a user.
  """
  def get_all(%{workingtimes: workingtimes}) do
    %{data: for(%{working_time: working_time, user_name: user_name, user_email: user_email} <- workingtimes, do: data_with_user(working_time, user_name, user_email))}
  end

  # Helper function pour afficher les données de chaque working_time avec le user_id, username, et email
  defp data_with_user(%WorkingTime{} = working_time, user_name, user_email) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      user_id: working_time.user_id,
      user_name: user_name,
      user_email: user_email
    }
  end
  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end
    }
  end
end

defmodule TimeManagerApiWeb.WorkingTimeJSON do
  alias TimeManagerApi.Timesheet.WorkingTime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(working_time <- workingtimes, do: data(working_time))}
  end

  @doc """
  Renders a single working_time without additional user data.
  """
  def showWithoutData(%{working_time: working_time}) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      total_time: working_time.total_time,  # Ajout du total_time ici
      user_id: working_time.user_id,
      inserted_at: working_time.inserted_at,
      updated_at: working_time.updated_at
    }
  end

  @doc """
  Renders a single working_time with user data.
  """
  def show(%{working_time: %{working_time: working_time, user_name: user_name, user_email: user_email}}) do
    %{
      data: %{
        id: working_time.id,
        start: working_time.start,
        end: working_time.end,
        total_time: working_time.total_time,  # Ajout du total_time ici
        user_id: working_time.user_id,
        user_name: user_name,
        user_email: user_email
      }
    }
  end

  @doc """
  Renders a list of all working_times for a user.
  """
  def get_all(%{workingtimes: workingtimes}) do
    %{
      data: for(%{working_time: working_time, user_name: user_name, user_email: user_email, total_time: total_time} <- workingtimes, do: data_with_user(working_time, user_name, user_email, total_time))
    }
  end

  # Helper function to include user data and total_time
  defp data_with_user(%WorkingTime{} = working_time, user_name, user_email, total_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      total_time: total_time,  # Ajout du total_time ici
      user_id: working_time.user_id,
      user_name: user_name,
      user_email: user_email
    }
  end

  # Helper function to render working_time without user details
  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      start: working_time.start,
      end: working_time.end,
      total_time: working_time.total_time  # Ajout du total_time ici
    }
  end
end

defmodule TimeManagerApi.TimesheetFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.Timesheet` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 13:03:00],
        start: ~N[2024-10-07 13:03:00]
      })
      |> TimeManagerApi.Timesheet.create_working_time()

    working_time
  end
end

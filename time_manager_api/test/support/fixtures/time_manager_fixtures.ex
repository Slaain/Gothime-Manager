defmodule TimeManagerApi.TimeManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.TimeManager` context.
  """

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~N[2024-10-07 14:08:00]
      })
      |> TimeManagerApi.TimeManager.create_clocks()

    clocks
  end
end

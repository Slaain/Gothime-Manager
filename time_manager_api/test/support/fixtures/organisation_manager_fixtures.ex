defmodule TimeManagerApi.OrganisationManagerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApi.OrganisationManager` context.
  """

  @doc """
  Generate a organisation.
  """
  def organisation_fixture(attrs \\ %{}) do
    {:ok, organisation} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TimeManagerApi.OrganisationManager.create_organisation()

    organisation
  end
end

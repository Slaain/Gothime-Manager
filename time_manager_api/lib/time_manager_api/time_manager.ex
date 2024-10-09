defmodule TimeManagerApi.TimeManager do
  @moduledoc """
  The TimeManager context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo

  alias TimeManagerApi.TimeManager.Clocks

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    Repo.all(Clocks)
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clocks!(id), do: Repo.get!(Clocks, id)

  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clocks(attrs \\ %{}) do
    %Clocks{}
    |> Clocks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clocks.

  ## Examples

      iex> update_clocks(clocks, %{field: new_value})
      {:ok, %Clocks{}}

      iex> update_clocks(clocks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clocks(%Clocks{} = clocks, attrs) do
    clocks
    |> Clocks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clocks.

  ## Examples

      iex> delete_clocks(clocks)
      {:ok, %Clocks{}}

      iex> delete_clocks(clocks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clocks(%Clocks{} = clocks) do
    Repo.delete(clocks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clocks changes.

  ## Examples

      iex> change_clocks(clocks)
      %Ecto.Changeset{data: %Clocks{}}

  """
  def change_clocks(%Clocks{} = clocks, attrs \\ %{}) do
    Clocks.changeset(clocks, attrs)
  end
end

defmodule TimeManagerApi.Timesheet do
  @moduledoc """
  The Timesheet context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApi.Repo

  alias TimeManagerApi.Timesheet.WorkingTime

  @doc """
  Returns the list of workingtimes.

  ## Examples

      iex> list_workingtimes()
      [%WorkingTime{}, ...]

  """
  def list_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end

  @doc """
  Returns the list of working times for a specific user in a given date range.

  ## Examples

      iex> list_workingtimes_for_user_in_range(1, "2024-01-01", "2024-12-31")
      [%WorkingTime{}, ...]

  """
  def list_workingtimes_for_user_in_range(user_id, start_date, end_date) do
    from(w in WorkingTime,
      where: w.user_id == ^user_id and w.start >= ^start_date and w.end <= ^end_date
    )
    |> Repo.all()
  end

  @doc """
  Gets a specific working time for a user.

  ## Examples

      iex> get_working_time_for_user!(1, 123)
      %WorkingTime{}

      iex> get_working_time_for_user!(1, 456)
      ** (Ecto.NoResultsError)

  """
  def get_working_time_for_user!(user_id, working_time_id) do
    from(w in WorkingTime,
      where: w.user_id == ^user_id and w.id == ^working_time_id
    )
    |> Repo.one!()
  end
end

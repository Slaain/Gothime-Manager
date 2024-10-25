defmodule TimeManagerApi.WorkingTimeService do
  @moduledoc """
  The Attendance context.
  """

  import Ecto.Query, warn: false

  require Logger

  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService

  def get_workingtimes_for_last_days(user_id, days) do
    start_date = Date.add(Date.utc_today(), -days)
    query_workingtimes_for_range(user_id, start_date, Date.utc_today())
  end

  def get_workingtimes_for_last_weeks(user_id, weeks) do
    start_date = Date.add(Date.utc_today(), -weeks * 7)
    query_workingtimes_for_range(user_id, start_date, Date.utc_today())
  end

  def get_workingtimes_for_last_months(user_id, months) do
    start_date = Date.add(Date.utc_today(), -months * 30)  # Approximation pour les mois
    query_workingtimes_for_range(user_id, start_date, Date.utc_today())
  end

  defp query_workingtimes_for_range(user_id, start_date, end_date) do
    WorkingTime
    |> where([wt], wt.user_id == ^user_id)
    |> where([wt], fragment("date(?) >= ?", wt.start, ^start_date) and fragment("date(?) <= ?", wt.start, ^end_date))
    |> Repo.all()
  end


  def get_workingtimes_for_today(user_id) do
    today = Date.utc_today()

    IO.inspect(user_id, label: "User ID")
    IO.inspect(today, label: "Today's Date")

    query =
      WorkingTime
      |> where([wt], wt.user_id == ^user_id)
      |> where([wt], fragment("date(?) = ?", wt.start, ^today))

    IO.inspect(query, label: "Generated Query")

    result = Repo.all(query)
    IO.inspect(result, label: "Query Result")

    result
  end

  # Récupérer le dernière working_time d'un utilisateur
  def get_last_working_time_by_user(user_id) do
    WorkingTime
    |> where([wt], wt.user_id == ^user_id)
    |> order_by([wt], desc: wt.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  # Recuperer un working_time par son id
  def get_working_time_by_id(id) do
    WorkingTime
    |> where([wt], wt.id == ^id)
    |> Repo.one()
  end

  # Modifier un working_time existant SANS START
  def update_working_time_without_start_attr(%WorkingTime{} = working_time, attrs) do
    IO.inspect(attrs, label: "Attributes")

    IO.inspect(working_time, label: "Working Time")
    # Récupérer le total_time

    total_time = NaiveDateTime.diff(attrs["end"], working_time.start, :minute)

    # Mettre à jour le total_time
    attrs = Map.put(attrs, "total_time", total_time)
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  # Modifier un working_time existant
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    IO.inspect(attrs, label: "Attributes")

    IO.inspect(working_time, label: "Working Time")
    # Récupérer le total_time

    if(attrs["total_time"] == nil) do
      total_time = NaiveDateTime.diff(attrs["end"], attrs["start"], :minute)
      attrs = Map.put(attrs, "total_time", total_time)
    end

    # Mettre à jour le total_time
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  # Créer un nouveau working_time
  def create_working_time(attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(attrs)
    |> Repo.insert()
  end

  # Supprimer un working_time
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end


    # Compte le nombre total de working_times pour un mois donné
    def count(month, year) do
      from(w in WorkingTime,
        where: fragment("extract(month from ?) = ?", w.start, ^month) and fragment("extract(year from ?) = ?", w.start, ^year)
      )
      |> Repo.aggregate(:count, :id)
    end

    # Compte les utilisateurs distincts ayant travaillé dans un mois donné
    def count_users(month, year) do
      from(w in WorkingTime,
        where: fragment("extract(month from ?) = ?", w.start, ^month) and fragment("extract(year from ?) = ?", w.start, ^year),
        distinct: w.user_id
      )
      |> Repo.aggregate(:count, :user_id)
    end




end

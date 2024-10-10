defmodule TimeManagerApi.Timesheet.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user_id, :id
    field :total_time, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :total_time])
    |> validate_required([:start, :user_id])
  end

  def get_working_time_for_user!(user_id, id) do
    Repo.get_by!(WorkingTime, [id: id, user_id: user_id])
  end
end


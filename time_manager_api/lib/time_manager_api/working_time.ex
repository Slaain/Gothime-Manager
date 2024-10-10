defmodule TimeManagerApi.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtimes" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user_id, :id
    field :total_time, :integer
    timestamps(type: :utc_datetime)
  end

  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id, :total_time])
    |> validate_required([:start, :end, :user_id, :total_time])
    |> foreign_key_constraint(:user_id, message: "The specified user does not exist.")
  end
end

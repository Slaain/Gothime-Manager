  defmodule TimeManagerApi.WorkingTime do
    use Ecto.Schema
    import Ecto.Changeset

    @derive {Jason.Encoder, only: [:id, :start, :end, :user_id, :total_time, :inserted_at, :updated_at]}
    schema "workingtimes" do
      field :start, :naive_datetime
      field :end, :naive_datetime, default: nil  # Accepte des valeurs nulles
      field :user_id, :id
      field :total_time, :integer  # Le total_time sera en minutes
      timestamps(type: :utc_datetime)
    end


    def changeset(working_time, attrs) do
      working_time
      |> cast(attrs, [:start, :end, :user_id, :total_time])
      |> validate_required([:start, :user_id])  # 'end' n'est plus requis ici
      |> foreign_key_constraint(:user_id, message: "The specified user does not exist.")
    end
  end

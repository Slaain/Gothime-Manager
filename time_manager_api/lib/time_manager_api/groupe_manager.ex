defmodule TimeManagerApi.Group do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :start_date, :end_date, :inserted_at, :updated_at]}
  schema "groups" do
    field :name, :string
    field :start_date, :naive_datetime
    field :end_date, :naive_datetime

    # Relation many-to-many avec les organisations via organisation_groups
    many_to_many :organisations, TimeManagerApi.Organisation, join_through: "organisation_groups"

    many_to_many :users, TimeManagerApi.User, join_through: "groups_users", on_replace: :delete # Ajout de l'option on_replace ici
    timestamps(type: :utc_datetime)
  end

  def changeset(group, attrs) do
    group
    |> cast(attrs, [:name, :start_date, :end_date])
    |> validate_required([:name, :start_date, :end_date])
  end
end

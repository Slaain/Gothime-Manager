defmodule TimeManagerApi.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}
  schema "organisations" do
    field :name, :string

    many_to_many :groups, TimeManagerApi.Group, join_through: "organisation_groups", on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

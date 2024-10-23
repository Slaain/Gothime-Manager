defmodule TimeManagerApi.Organisation do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at]}
  schema "organisations" do
    field :name, :string

    # Relation many-to-many avec groups via organisation_groups
    many_to_many :groups, TimeManagerApi.Group, join_through: "organisation_groups", on_replace: :delete

    # Relation avec users via user_role_organisation
    has_many :user_role_organisation, TimeManagerApi.UserRoleOrganisation
    has_many :users, through: [:user_role_organisation, :user]

    timestamps(type: :utc_datetime)
  end

  def changeset(organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end

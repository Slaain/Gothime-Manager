defmodule TimeManagerApi.UserRoleOrganisation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_role_organisation" do
    field :organisation_ids, {:array, :integer}, default: []

    belongs_to :user, TimeManagerApi.User
    belongs_to :role, TimeManagerApi.Role

    timestamps()
  end

  @doc false
  def changeset(user_role_organisation, attrs) do
    user_role_organisation
    |> cast(attrs, [:user_id, :role_id, :organisation_ids])
    |> validate_required([:user_id, :role_id])
  end
end

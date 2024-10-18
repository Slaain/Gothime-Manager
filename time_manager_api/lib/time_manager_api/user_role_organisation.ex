defmodule YourApp.UserRoleOrganisation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_role_organisation" do
    field :organisation_ids, {:array, :integer}, default: []

    belongs_to :user, YourApp.User
    belongs_to :role, YourApp.Role

    timestamps()
  end

  @doc false
  def changeset(user_role_organisation, attrs) do
    user_role_organisation
    |> cast(attrs, [:user_id, :role_id, :organisation_ids])
    |> validate_required([:user_id, :role_id])
  end
end

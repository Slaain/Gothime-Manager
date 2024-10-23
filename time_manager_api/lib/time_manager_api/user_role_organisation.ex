defmodule TimeManagerApi.UserRoleOrganisation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_role_organisation" do
    belongs_to :user, TimeManagerApi.User
    belongs_to :organisation, TimeManagerApi.Organisation
    belongs_to :role, TimeManagerApi.Role

    # Autres champs si nécessaire
    timestamps()
  end

  def changeset(user_role_organisation, attrs) do
    user_role_organisation
    |> cast(attrs, [:user_id, :organisation_id, :role_id])
    |> validate_required([:user_id, :organisation_id, :role_id])
  end
end

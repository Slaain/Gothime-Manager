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
    |> cast(attrs, [:user_id, :organisation_id, :role_id]) # Ajout des associations
    |> validate_required([:role_id])
    |> validate_number(:role_id, greater_than: 0, message: "Le role_id doit être un entier positif.")
    |> assoc_constraint(:user)
    |> assoc_constraint(:organisation)
    |> assoc_constraint(:role)
  end

end

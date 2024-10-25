defmodule TimeManagerApi.OrganisationGroup do
  use Ecto.Schema

  @primary_key false # Set to false because we do not need the default `id` field for join tables.
  schema "organisation_groups" do
    field :organisation_id, :id
    field :group_id, :id

    timestamps()
  end
end

defmodule TimeManagerApi.GroupUser do
  use Ecto.Schema

  schema "groups_users" do
    field :group_id, :id
    field :user_id, :id
    timestamps()
  end
end

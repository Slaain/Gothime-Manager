defmodule TimeManagerApiWeb.OrganisationHTML do
  use TimeManagerApiWeb, :html

  embed_templates "organisation_html/*"

  @doc """
  Renders a organisation form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def organisation_form(assigns)
end

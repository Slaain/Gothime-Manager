defmodule TimeManagerApiWeb.RoleController do
  use TimeManagerApiWeb, :controller
  require Logger

  alias TimeManagerApi.Attendance
  alias TimeManagerApi.Repo
  alias TimeManagerApi.Clock
  alias TimeManagerApi.WorkingTime
  alias TimeManagerApi.ClockService
  alias TimeManagerApi.WorkingTimeService
  alias TimeManagerApi.RoleService
  alias TimeManagerApi.UserService


  def show(conn, _params) do
    user_id = conn.assigns[:current_user]

    IO.inspect(user_id)

    user_role = RoleService.get_user_role(user_id)

    conn
    |> put_status(:ok)
    |> json(%{role: user_role})
  end

  # Ajouter un utilisateur dans une organisation via son email
  # Ajouter un utilisateur dans une organisation via son email
  def add_user_to_organisation(conn, %{"organisation_id" => organisation_id, "email" => email}) do
    # Rechercher l'utilisateur par email
    case UserService.get_user_by_email(email) do
      nil ->
        # Si l'utilisateur n'existe pas
        conn
        |> put_status(:not_found)
        |> json(%{error: "Utilisateur non trouvé"})

      user ->
        # Vérifier si l'utilisateur est déjà dans une autre organisation
        if RoleService.user_in_another_organisation?(user.id, organisation_id) do
          conn
          |> put_status(:conflict)
          |> json(%{error: "L'utilisateur est déjà dans une autre organisation"})
        else
          # Vérifier si l'utilisateur est déjà dans l'organisation actuelle
          case RoleService.user_in_organisation?(user.id, organisation_id) do
            true ->
              # Si l'utilisateur est déjà dans l'organisation
              conn
              |> put_status(:conflict)
              |> json(%{error: "L'utilisateur est déjà dans l'organisation"})

            false ->
              # Ajouter l'utilisateur à l'organisation avec le rôle 3 (Employee)
              case RoleService.add_user_to_organisation(user.id, organisation_id, 3) do
                {:ok, _user_role} ->
                  # Succès
                  conn
                  |> put_status(:created)
                  |> json(%{message: "Utilisateur ajouté avec succès à l'organisation"})

                {:error, reason} ->
                  # Gérer les erreurs d'ajout
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{error: "Échec de l'ajout de l'utilisateur", reason: reason})
              end
          end
        end
    end
  end

end

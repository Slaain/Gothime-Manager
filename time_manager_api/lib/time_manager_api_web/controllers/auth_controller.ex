  defmodule TimeManagerApiWeb.AuthController do
    use TimeManagerApiWeb, :controller
    alias TimeManagerApi.User
    alias TimeManagerApi.Repo
    alias Bcrypt
    alias TimeManagerApi.Guardian  # Import Guardian ici
    alias TimeManagerApi.UserService
    alias TimeManagerApi.TokenService

    # Inscription d'un utilisateur
    def register(conn, %{"email" => email, "username" => username, "password" => password, "organisation_id" => organisation_id, "role_id" => role_id}) do
      # Print data for debugging
      IO.inspect(email, label: "email")
      IO.inspect(username, label: "username")
      IO.inspect(password, label: "password")
      IO.inspect(organisation_id, label: "organisation_id")
      IO.inspect(role_id, label: "role_id")

      # Assurez-vous que organisation_id est un entier
      organisation_id =
        case Integer.parse(to_string(organisation_id)) do
          {int_value, ""} -> int_value
          _ ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "organisation_id must be a valid integer"})
            |> halt()
        end

      # Assurez-vous que role_id est également un entier
      role_id =
        case Integer.parse(to_string(role_id)) do
          {int_value, ""} -> int_value
          _ ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: "role_id must be a valid integer"})
            |> halt()
        end

      # Continuez avec la création de l'utilisateur
      case UserService.create_user(%{"email" => email, "username" => username, "password" => password}) do
        {:ok, user} ->
          # Associate user with organisation and role
          changeset = %TimeManagerApi.UserRoleOrganisation{}
                      |> TimeManagerApi.UserRoleOrganisation.changeset(%{
                          user_id: user.id,
                          organisation_id: organisation_id,
                          role_id: role_id
                        })

          case Repo.insert(changeset) do
            {:ok, _user_role_organisation} ->
              json(conn, %{message: "User created successfully", user: user})

            {:error, changeset} ->
              Repo.delete(user)

              # Log or inspect the changeset errors for debugging
              IO.inspect(changeset.errors, label: "Changeset errors")

              conn
              |> put_status(:bad_request)
              |> json(%{error: "Failed to associate user with organisation and role", reasons: changeset.errors})
          end


          {:error, changeset} ->
            errors = changeset.errors
                      |> Enum.map(fn {field, {message, _}} -> {field, message} end)
                      |> Enum.into(%{})  # Convertir la liste en map pour Jason

            conn
            |> put_status(:bad_request)
            |> json(%{error: "User creation failed", reasons: errors})
      end
    end





      # Connexion d'un utilisateur
      def login(conn, %{"email" => email, "password" => password}) do
        user = Repo.get_by(User, email: email)

        case check_password(user, password) do
          {:ok, user} ->
            # Génération du token JWT avec Guardian
            {:ok, token, _claims} = Guardian.encode_and_sign(user, %{})

            # Renvoyer la réponse avec le token
            conn
            |> json(%{message: "Login successful", user: user, token: token})

          {:error, :invalid_password} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid credentials"})

          {:error, :invalid_user} ->
            conn
            |> put_status(:unauthorized)
            |> json(%{error: "Invalid credentials"})
        end
      end

      # decrypt le token
      def decrypt_token(conn, %{"token" => token}) do
        case Guardian.decode_and_verify(token) do
          {:ok, claims} ->
            conn
            |> json(%{message: "Token decoded successfully", claims: claims})
          end
        end

        def update_password_with_token(conn, %{"id" => id, "new_password" => new_password, "token" => token}) do
          user = Repo.get(User, id)

          IO.inspect(user, label: "user")

          case TokenService.validate_user_token(id, token) do
            :ok ->
              changeset =
                user
                |> Ecto.Changeset.change()
                |> Ecto.Changeset.put_change(:password, new_password)
                |> User.put_password_hash()

              case Repo.update(changeset) do
                {:ok, _updated_user} ->
                  conn
                  |> put_status(:ok)
                  |> json(%{message: "Password updated successfully"})

                {:error, changeset} ->
                  conn
                  |> put_status(:unprocessable_entity)
                  |> json(%{error: "Failed to update password", details: changeset.errors})
              end

            :error ->
              conn
              |> put_status(:unauthorized)
              |> json(%{error: "Invalid or expired token"})
          end
        end


        def update_password(conn, %{"id" => id, "current_password" => current_password, "new_password" => new_password}) do
          user = Repo.get(User, id)

          if user do
            case check_password(user, current_password) do
              {:ok, _user} ->
                changeset =
                  user
                  |> Ecto.Changeset.change()
                  |> Ecto.Changeset.put_change(:password, new_password)
                  |> User.put_password_hash()  # Apply password hashing

                case Repo.update(changeset) do
                  {:ok, _updated_user} ->
                    conn
                    |> put_status(:ok)
                    |> json(%{message: "Password updated successfully"})

                  {:error, changeset} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> json(%{error: "Failed to update password", details: changeset.errors})
                end

              {:error, :invalid_password} ->
                conn
                |> put_status(:unauthorized)
                |> json(%{error: "Current password is incorrect"})
            end
          else
            conn
            |> put_status(:not_found)
            |> json(%{error: "User not found"})
          end
        end


      defp check_password(nil, _password), do: {:error, :invalid_user}
      defp check_password(user, password) do
        case Bcrypt.check_pass(user, password) do
          {:ok, user} -> {:ok, user}
          _ -> {:error, :invalid_password}
        end
      end
  end

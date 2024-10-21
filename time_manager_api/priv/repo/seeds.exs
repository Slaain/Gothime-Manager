# priv/repo/seeds.exs

alias TimeManagerApi.Repo
alias TimeManagerApi.User
alias TimeManagerApi.Clock
alias TimeManagerApi.WorkingTime
alias TimeManagerApi.Task
alias TimeManagerApi.Group
alias TimeManagerApi.Role
alias TimeManagerApi.UserRoleOrganisation
import Ecto.Query

# Ensure Faker is started
Faker.start()

# Create users
for _ <- 1..100 do
  password = Faker.String.base64() # Générer un mot de passe aléatoire

  user_attrs = %{
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email(),
    password: password  # Passer le mot de passe ici
  }

  # Créer un changeset pour l'utilisateur
  changeset = User.changeset(%User{}, user_attrs)

  IO.puts("Inserting user with username: #{user_attrs.username}")

  # Insérer l'utilisateur et récupérer l'utilisateur inséré avec son ID
  user = Repo.insert!(changeset)

  IO.puts("Inserted user with ID: #{user.id}")

  # Create clocks for the user
  for _ <- 1..5 do
    clock = %Clock{
      time: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),  # Remove microseconds
      status: Enum.random([true, false]),
      user_id: user.id  # Utiliser l'ID de l'utilisateur inséré
    }

    Repo.insert!(clock)
  end

  # Create workingtimes for the user
  for _ <- 1..5 do
    start_time = Faker.DateTime.backward(30) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)  # Remove microseconds
    end_time = Faker.DateTime.forward(1) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)  # Remove microseconds

    workingtime = %WorkingTime{
      start: start_time,
      end: end_time,
      user_id: user.id,  # Utiliser l'ID de l'utilisateur inséré
      total_time: NaiveDateTime.diff(end_time, start_time)
    }

    Repo.insert!(workingtime)
  end
end




# Create groups
for _ <- 1..5 do
  group = %Group{
    name: Faker.Team.name(),
    start_date: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),  # Remove microseconds
    end_date: Faker.DateTime.forward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)  # Remove microseconds
  }

  Repo.insert!(group)
end

# Create roles
for role_name <- ["admin", "manager", "user"] do
  role = %Role{
    name: role_name
  }

  Repo.insert!(role)
end

# Assign users to groups and roles
for user <- Repo.all(User) do
  group = Repo.one!(from g in Group, order_by: fragment("RANDOM()"), limit: 1)
  role = Repo.one!(from r in Role, order_by: fragment("RANDOM()"), limit: 1)

  # Vérifiez si le user_role_org existe déjà
  existing_user_role = Repo.get_by(UserRoleOrganisation, user_id: user.id, role_id: role.id)

  if existing_user_role do
    IO.puts("UserRoleOrganisation already exists for User ID: #{user.id} and Role ID: #{role.id}")
  else
    user_role_org = %UserRoleOrganisation{
      user_id: user.id,
      role_id: role.id,
      organisation_ids: [group.id]
    }

    Repo.insert!(user_role_org)
    IO.puts("Inserted UserRoleOrganisation for User ID: #{user.id} and Role ID: #{role.id}")
  end
end


IO.puts("100 users seeded successfully!")

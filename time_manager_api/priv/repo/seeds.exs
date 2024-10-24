alias TimeManagerApi.Repo
alias TimeManagerApi.User
alias TimeManagerApi.Clock
alias TimeManagerApi.WorkingTime
alias TimeManagerApi.Task
alias TimeManagerApi.Group
alias TimeManagerApi.Role
alias TimeManagerApi.UserRoleOrganisation
alias TimeManagerApi.Organisation
import Ecto.Query
import IO

Faker.start()


for _ <- 1..10 do
  password = Faker.String.base64()

  user_attrs = %{
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email(),
    password: password
  }

  changeset = User.changeset(%User{}, user_attrs)
  user = Repo.insert!(changeset)

  for _ <- 1..5 do
    clock = %Clock{
      time: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),  # Remove microseconds
      status: Enum.random([true, false]),
      user_id: user.id
    }

    Repo.insert!(clock)
  end

  for _ <- 1..5 do
    start_time = Faker.DateTime.backward(30) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)

    duration_minutes = Enum.random(1..540)

    end_time = NaiveDateTime.add(start_time, duration_minutes * 60)

    workingtime = %WorkingTime{
      start: start_time,
      end: end_time,
      user_id: user.id,
      total_time: duration_minutes
    }

    Repo.insert!(workingtime)
  end
end

# Création des groupes
for _ <- 1..5 do
  group = %Group{
    name: Faker.Team.name(),
    start_date: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),  # Remove microseconds
    end_date: Faker.DateTime.forward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)  # Remove microseconds
  }

  Repo.insert!(group)
end

# Création des rôles
for role_name <- ["admin", "manager", "employee"] do
  role = %Role{
    name: role_name
  }

  Repo.insert!(role)
end

# Association des utilisateurs aux groupes et rôles
for user <- Repo.all(User) do
  group = Repo.one!(from g in Group, order_by: fragment("RANDOM()"), limit: 1)
  role = Repo.one!(from r in Role, order_by: fragment("RANDOM()"), limit: 1)

  existing_user_role = Repo.get_by(UserRoleOrganisation, user_id: user.id, role_id: role.id)

  if existing_user_role do
    # Ne rien faire si le rôle existe déjà
  else
    user_role_org = %UserRoleOrganisation{
      user_id: user.id,
      role_id: role.id,
      organisation_ids: [group.id]  # Associé à l'organisation
    }

    Repo.insert!(user_role_org)
  end
end


for _ <- 1..5 do
  organisation_attrs = %{
    name: Faker.Company.name()
  }

  changeset = Organisation.changeset(%Organisation{}, organisation_attrs)
  Repo.insert!(changeset)
end

alias TimeManagerApi.Repo
alias TimeManagerApi.{User, Clock, WorkingTime, Group, Role, Organisation, UserRoleOrganisation}
import Ecto.Query

Faker.start()

# Créer des organisations
for org_name <- ["Organisation A", "Organisation B", "Organisation C"] do
  organisation = %Organisation{
    name: org_name
  }

  Repo.insert!(organisation)
end

# Créer des utilisateurs, des clocks, et des working times
for _ <- 1..10 do
  password = Faker.String.base64()

  user_attrs = %{
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email(),
    password: password
  }

  changeset = User.changeset(%User{}, user_attrs)
  user = Repo.insert!(changeset)

  # Créer des clocks pour chaque utilisateur
  for _ <- 1..5 do
    clock = %Clock{
      time: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
      status: Enum.random([true, false]),
      user_id: user.id
    }

    Repo.insert!(clock)
  end

  # Créer des working times pour chaque utilisateur
  for _ <- 1..5 do
    start_time = Faker.DateTime.backward(30) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
    end_time = Faker.DateTime.forward(1) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)

    working_time = %WorkingTime{
      start: start_time,
      end: end_time,
      user_id: user.id,
      total_time: NaiveDateTime.diff(end_time, start_time)
    }

    Repo.insert!(working_time)
  end
end

# Créer des groupes
for _ <- 1..5 do
  group = %Group{
    name: Faker.Team.name(),
    start_date: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),
    end_date: Faker.DateTime.forward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second)
  }

  Repo.insert!(group)
end

# Créer des rôles
for role_name <- ["admin", "manager", "employee"] do
  role = %Role{
    name: role_name
  }

  Repo.insert!(role)
end

# Assigner des utilisateurs à des organisations et des rôles
for user <- Repo.all(User) do
  organisation = Repo.one!(from o in Organisation, order_by: fragment("RANDOM()"), limit: 1)
  role = Repo.one!(from r in Role, order_by: fragment("RANDOM()"), limit: 1)

  existing_user_role = Repo.get_by(UserRoleOrganisation, user_id: user.id, role_id: role.id, organisation_id: organisation.id)

  unless existing_user_role do
    IO.inspect("Adding user #{user.id} to organisation #{organisation.id} with role #{role.id}")

    user_role_org = %UserRoleOrganisation{
      user_id: user.id,
      role_id: role.id,
      organisation_id: organisation.id
    }

    Repo.insert!(user_role_org)
  end
end

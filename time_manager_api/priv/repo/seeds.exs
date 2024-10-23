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
  user = %User{
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email(),
    password_hash: Faker.String.base64()
  }

  Repo.insert!(user)

  # Create clocks for the user
  for _ <- 1..5 do
    clock = %Clock{
      time: Faker.DateTime.backward(365) |> DateTime.to_naive() |> NaiveDateTime.truncate(:second),  # Remove microseconds
      status: Enum.random([true, false]),
      user_id: user.id
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
      user_id: user.id,
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

  user_role_org = %UserRoleOrganisation{
    user_id: user.id,
    role_id: role.id,
    organisation_ids: [group.id]
  }

  Repo.insert!(user_role_org)
end

IO.puts("100 users seeded successfully!")

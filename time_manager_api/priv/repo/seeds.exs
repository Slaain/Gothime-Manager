# priv/repo/seeds.exs

alias TimeManagerApi.Repo
alias TimeManagerApi.User
alias TimeManagerApi.Clock
alias TimeManagerApi.WorkingTime
import Faker

# Effacez les anciennes données
Repo.delete_all(WorkingTime)
Repo.delete_all(Clock)
Repo.delete_all(User)

# Créez des utilisateurs avec des données fictives
for _ <- 1..10 do
  %User{}
  |> User.changeset(%{
    username: Faker.Internet.user_name(),
    email: Faker.Internet.email()
  })
  |> Repo.insert!()
end

# Créez des horloges et des temps de travail pour les utilisateurs
users = Repo.all(User)

for user <- users do
  # Créez des horloges
  for _ <- 1..5 do
    %Clock{}
    |> Clock.changeset(%{
      status: :rand.uniform(2) == 1,  # Génère un booléen aléatoire
      time: Faker.DateTime.between(~N[2024-01-01 00:00:00], ~N[2024-12-31 23:59:59])
    })
    |> Ecto.Changeset.put_assoc(:user_id, user.id)
    |> Repo.insert!()
  end

  # Créez des temps de travail
  for _ <- 1..3 do
    %WorkingTime{}
    |> WorkingTime.changeset(%{
      start: Faker.DateTime.between(~N[2024-01-01 09:00:00], ~N[2024-12-31 17:00:00]),
      end: Faker.DateTime.between(~N[2024-01-01 17:00:00], ~N[2024-12-31 23:59:59])
    })
    |> Ecto.Changeset.put_assoc(:user_id, user.id)
    |> Repo.insert!()
  end
end

IO.puts("Seed finished!")


#Commande : mix run priv/repo/seeds.exs

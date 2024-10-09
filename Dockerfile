# Utilise l'image officielle Elixir comme base
FROM elixir:1.12-alpine

# Installe les dépendances nécessaires
RUN apk update && \
    apk --no-cache add build-base nodejs npm git postgresql-client

# Installe Hex et Rebar (gestionnaires de dépendances pour Elixir)
RUN mix local.hex --force && \
    mix local.rebar --force

# Définit le répertoire de travail de l'application
WORKDIR /app

# Copie les fichiers du projet dans le conteneur
COPY . .

# Installe les dépendances du projet
RUN mix deps.get

# Compile le projet
RUN mix compile

# Crée et configure la base de données (si nécessaire)
RUN mix ecto.create
RUN mix ecto.migrate

# Expose le port sur lequel Phoenix s'exécute
EXPOSE 4000

# Commande de démarrage de l'application Phoenix
CMD ["mix", "phx.server"]

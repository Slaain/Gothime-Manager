# Utiliser l'image officielle Elixir
FROM elixir:1.14

# Installer Hex et Rebar pour gérer les dépendances Elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# Installer Node.js et npm (si nécessaire pour les assets)
RUN apt-get update && apt-get install -y nodejs npm

# Créer et définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances
COPY mix.exs mix.lock ./

# Installer les dépendances
RUN mix deps.get

# Copier le reste des fichiers de l'application
COPY . .

# Compiler le projet
RUN mix compile

# Exposer le port 4000 pour l'API
EXPOSE 4000

# Commande pour démarrer le serveur Phoenix
CMD ["mix", "phx.server"]

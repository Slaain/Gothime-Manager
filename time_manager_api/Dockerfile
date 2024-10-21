# Utiliser l'image officielle Elixir
FROM elixir:latest

# Installer les dépendances pour Node.js et PostgreSQL
RUN apt-get update && \
    apt-get install -y nodejs npm postgresql-client

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans l'image
COPY . .

# Installer Hex et Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Installer les dépendances Phoenix
RUN mix deps.get

# Étape 6: Installation des dépendances JS (Node.js) et Webpack dans le dossier assets
WORKDIR /app/assets
RUN npm install && npm install -g webpack webpack-cli

# Étape 7: Revenir au dossier racine et exécuter le fichier entrypoint.sh
WORKDIR /app

# Exposez le port utilisé par Phoenix (par défaut 4000)
EXPOSE 4000

# Exécuter le fichier entrypoint.sh
CMD ["mix", "phx.server"]
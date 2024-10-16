# Utilisez l'image officielle Elixir
FROM elixir:1.17

# Installez les dépendances pour PostgreSQL et Node.js
RUN apt-get update && \
    apt-get install -y postgresql-client nodejs npm inotify-tools && \
    npm install -g npm@latest

# Définir le répertoire de travail
WORKDIR /app

# Installer Hex et Rebar pour gérer les dépendances Elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# Copier les fichiers de dépendances
COPY time_manager_api/mix.exs time_manager_api/mix.lock ./

# Installer les dépendances Elixir
RUN mix deps.get

# Copier le reste de l'application depuis le backend
COPY time_manager_api/. ./

# Copiez les fichiers du projet dans l'image
COPY . .


# Changer de répertoire vers le frontend 
WORKDIR /app/time_manager_frontend

# Copier le package.json depuis le frontend
COPY time_manager_frontend/package.json ./


# Changer de répertoire vers le frontend/assets
# WORKDIR /app/time_manager_frontend/src/assets

# Installer les dépendances JavaScript
RUN npm install




# Exécuter le script de déploiement ou de build pour lancer le webpack
RUN npm run build

# Retourner au répertoire de l'application
WORKDIR /app

# Installer les dépendances Phoenix
RUN mix deps.compile


# Copie du fichier .env dans le conteneur
COPY time_manager_api/.env ./

# Copier le script entrypoint.sh depuis le backend et donner les permissions d'exécution
COPY time_manager_api/entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Définir le point d'entrée pour exécuter entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]

# Compilez le projet Phoenix
RUN mix phx.digest

# Exposez le port utilisé par Phoenix (par défaut 4000)
EXPOSE 4000

# Exposer le port 4000 pour l'API
EXPOSE 4000

# Commande pour démarrer le serveur Phoenix
CMD ["mix", "phx.server"]

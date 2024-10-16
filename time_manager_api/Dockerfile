# Utilisez l'image officielle Elixir
FROM elixir:1.17.3-alpine

# Installez les dépendances pour PostgreSQL et Node.js
RUN apk add --no-cache build-base nodejs npm git postgresql-client

# Définir le répertoire de travail
WORKDIR /app


COPY . .

# Installer Hex et Rebar pour gérer les dépendances Elixir
RUN mix local.hex --force && mix local.rebar --force


# Installer les dépendances Elixir
RUN mix deps.get


#  Copier le reste des fichiers du backend (à revoir)
#COPY time_manager_api/ ./

# Compiler l'application
RUN mix compile

# Changer de répertoire vers le frontend (à revoir)
#WORKDIR /app/time_manager_frontend

# Copier le package.json depuis le frontend (à revoir)
#COPY time_manager_frontend/package.json ./
#COPY time_manager_frontend/package-lock.json ./

# Installer les dépendances JavaScript (à revoir)
# RUN npm install

# Copier le fichier index.html pour la compilation (à revoir)
# COPY time_manager_frontend/index.html ./

# Exécuter le script de déploiement ou de build pour lancer le webpack
# RUN npm run build

# Revenir au répertoire backend pour Phoenix
# WORKDIR /app

# Compilez les assets statiques de Phoenix
# RUN mix phx.digest

# Copie du fichier .env dans le conteneur
# COPY time_manager_api/.env ./

# Copier le script entrypoint.sh depuis le backend et donner les permissions d'exécution
#COPY time_manager_api/entrypoint.sh /app/entrypoint.sh
#RUN chmod +x /app/entrypoint.sh

# Exposez le port utilisé par Phoenix (par défaut 4000)
EXPOSE 4000

# Commande pour démarrer le serveur Phoenix
CMD ["mix", "phx.server"]

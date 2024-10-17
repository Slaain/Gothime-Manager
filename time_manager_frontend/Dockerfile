# Utilise l'image officielle Elixir comme base
FROM node:20-alpine

# Définir le répertoire de travail dans le conteneur
WORKDIR /app/time_manager_frontend

# Copier les fichiers de configuration des dépendances
COPY package*.json ./


# Installer les dépendances nécessaires
RUN apk add --no-cache git
RUN npm install npm@latest -g
RUN npm install

COPY . .

# Exposer le port sur lequel Vite s'exécute
EXPOSE 5173

# Commande de démarrage de l'application vite
CMD ["npm", "run", "dev"]

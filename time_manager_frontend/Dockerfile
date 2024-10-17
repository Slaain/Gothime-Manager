# Utilise l'image officielle Elixir comme base
FROM node:20-alpine

# Définir le répertoire de travail dans le conteneur
WORKDIR /app/time_manager_frontend

# Copier les fichiers de configuration des dépendances
COPY package*.json ./



# Installer les dépendances nécessaires
RUN apk add --no-cache git
RUN npm install

COPY . .

# Installe vite globalement
RUN npm install -g vite
RUN npm install @vitejs/plugin-vue --save-dev


#COPY . /app/time_manager_frontend

# Exposer le port sur lequel Vite s'exécute
EXPOSE 5173

# Commande de démarrage de l'application vite
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
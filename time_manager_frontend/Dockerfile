# Utiliser l'image officielle Node.js
FROM node:20-alpine

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans l'image
COPY . .

# Installer les dépendances Node.js
RUN npm install

# Installer Vite.js
RUN npm install -g vite

# Exposer le port sur lequel Vite s'exécute
EXPOSE 5173

CMD ["npm", "run", "dev"]
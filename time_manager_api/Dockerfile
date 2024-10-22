# Utiliser l'image officielle Elixir
FROM elixir:latest

# Installer les dépendances pour Node.js, PostgreSQL et netcat-openbsd
RUN apt-get update && \
    apt-get install -y nodejs npm postgresql-client netcat-openbsd

# Installer Node.js et npm
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application dans l'image
COPY . .

# Installer Hex et Rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Installer les dépendances Phoenix
RUN mix deps.get

# Installer les dépendances Node.js et Webpack
RUN cd assets && \
    npm install && \
    npm install -g webpack webpack-cli

# Copier le fichier .env dans le conteneur
COPY .env .env

# Exposer le port pour Phoenix
EXPOSE 4000


# Copier le script wait-for-it.sh dans l'image
COPY wait-for-it.sh /usr/local/bin/wait-for-it.sh
RUN chmod +x /usr/local/bin/wait-for-it.sh  # Rendre le script exécutable

# Remplacer l'exécution par le script wait-for-it.sh
CMD ["wait-for-it.sh", "db:5432", "--", "mix", "phx.server"]

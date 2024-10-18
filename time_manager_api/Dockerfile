# Utilisez l'image officielle Elixir
FROM elixir:1.17.3-alpine

# Installer Git
RUN apk add --no-cache git

# Définir le répertoire de travail dans le conteneur
WORKDIR /app/time_manager_api
COPY . /app/time_manager_api

# Copier les fichiers mix pour installer les dépendances
COPY mix.exs mix.lock ./


# Installer Hex et Rebar pour gérer les dépendances Elixir
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Copier tout le code source du backend dans le conteneur
COPY . .

# Compiler l'application
RUN mix compile

# Copier le script entrypoint.sh depuis le backend et donner les permissions d'exécution
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

# Exposez le port utilisé par Phoenix (par défaut 4000)
EXPOSE 4000

# Commande pour démarrer le serveur Phoenix via entrypoint.sh
#CMD ["mix", "phx.server"]
CMD ["sh", "/app/entrypoint.sh"]

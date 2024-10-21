#!/bin/sh
# wait-for-it.sh script to ensure DB is available before continuing

until PGPASSWORD=postgres psql -h db -U postgres -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec mix phx.server  # Remplacez cette ligne par la commande que vous voulez exécuter
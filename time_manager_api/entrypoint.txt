# Vérifier la présence d'un fichier .env et arrêter le conteneur Phoenix si absent
if [ ! -f .env ]; then
  echo ".env file not found. Stopping the Phoenix container."
  exit 1
fi
 
# Charger les variables d'environnement
export $(cat .env | xargs)
# Attendre que le conteneur de la base de données soit utilisable
echo "Waiting for the database container to be ready..."
until pg_isready -h $DB_HOSTNAME -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -w; do
  sleep 1
done
echo "Database is ready."

# Vérifier la présence de la base de données et la créer si nécessaire
echo "Checking if the database exists..."
if ! psql -h $DB_HOSTNAME -p $DB_PORT -U $DB_USERNAME -d $DB_NAME -c '\q'; then
  echo "Database not found. Creating database..."
  mix ecto.create
else
  echo "Database exists."
fi

# 4. Lancer l'application
echo "Starting the Phoenix application..."
mix phx.server
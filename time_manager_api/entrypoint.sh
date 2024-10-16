# Vérifiez la présence du fichier .env
if [ ! -f ".env" ]; then
  echo "Erreur: Le fichier .env est manquant."
  echo "Le conteneur Phoenix ne peut pas démarrer sans le fichier .env."
  exit 1
fi

# Charger les variables d'environnement du fichier .env
export $(grep -v '^#' .env | xargs)

# Attendre que la base de données soit utilisable
echo "Attente de la disponibilité de la base de données à l'adresse $DB_HOSTNAME..."
until pg_isready -h $DB_HOSTNAME -p 5432 -U $DB_USERNAME; do
  sleep 1
done

echo "La base de données est prête !"

# Vérifier si la base de données existe, sinon la créer
DB_EXISTS=$(PGPASSWORD=$DB_PASSWORD psql -h $DB_HOSTNAME -U $DB_USERNAME -lqt | cut -d \| -f 1 | grep -w $DB_NAME | wc -l)

if [ $DB_EXISTS -eq 0 ]; then
  echo "La base de données $DB_NAME n'existe pas. Création en cours..."
  mix ecto.create
else
  echo "La base de données $DB_NAME existe déjà."
fi

# Lancer l'application Phoenix
echo "Démarrage de l'application Phoenix..."
exec mix phx.server

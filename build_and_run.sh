#!/bin/bash
set -e

# --- Make this script executable if not already ---
chmod +x build_and_run.sh

echo "---Creating Virtual Environment---"
if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

echo "---Activating Virtual Environment---"
source .venv/bin/activate

echo "---Loading Environment Variables---"
source variables_to_export.sh

echo "---Creating Docker Network---"
docker network create pythonetlandpostgres || true

echo "---Starting Postgres Container---"
# Remove old container if it exists
docker rm -f postgrescontainer 2>/dev/null || true
docker run -d \
  --name postgrescontainer \
  --network pythonetlandpostgres \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_DB=$POSTGRES_DW \
  -p 5432:5432 \
  postgres:14

echo "---Building ETL Docker Image---"
docker build -t dockeretl .

echo "---Waiting for Postgres to be Ready---"
until docker exec postgrescontainer pg_isready -U $POSTGRES_USER > /dev/null 2>&1; do
  echo "Waiting for postgres..."
  sleep 2
done

echo "---Running ETL Container---"
docker run --rm \
  --name dockeretlcontainer \
  --network pythonetlandpostgres \
  -e POSTGRES_USER=$POSTGRES_USER \
  -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD \
  -e POSTGRES_PORT=$POSTGRES_PORT \
  -e POSTGRES_HOST=$POSTGRES_HOST \
  -e POSTGRES_DW=$POSTGRES_DW \
  -e URL=$URL \
  dockeretl

echo "---Querying Database to Verify Data---"
docker exec -i postgrescontainer psql -U $POSTGRES_USER -d $POSTGRES_DW -c "SELECT * FROM countries LIMIT 10;"

echo "---ETL Process Completed Successfully---"

echo "---Deactivating Virtual Environment---"
deactivate

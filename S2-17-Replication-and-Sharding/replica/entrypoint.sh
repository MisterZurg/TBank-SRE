#!/bin/bash
set -e

# Ожидание готовности мастера
until pg_isready -h postgres-master -U postgres; do
  echo "Waiting for master..."
  sleep 1
done

# Инициализация реплики
if [ ! -f /var/lib/postgresql/data/PG_VERSION ]; then
  echo "Initializing replica..."
  pg_basebackup -h postgres-master -U replicator -D /var/lib/postgresql/data -P -R -Xs -c fast
  touch /var/lib/postgresql/data/standby.signal
fi

exec docker-entrypoint.sh postgres
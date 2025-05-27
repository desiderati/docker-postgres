#!/bin/bash
set -e

# Por padrão, a imagem do PostgreSQL criará uma tabela de acordo com a variável $POSTGRES_DB.
# Se esta variável não estiver definida, a tabela será criada de acordo com a variável $POSTGRES_USER.
if [[ -n "$POSTGRES_DB" ]]; then # True if the length of string is non-zero.
  defaultDbName=${POSTGRES_DB}
else
  defaultDbName=${POSTGRES_USER}
fi
echo "Default Database Name: $defaultDbName"

# shellcheck disable=SC2125
FILES=/scripts/init-db/*.dump
echo "Initializing DB from script dumps..."
for file in ${FILES}; do
  if [[ ! ${file} == '/scripts/init-db/*.dump' ]]; then
    echo " +script: $file"
    dbname=$(echo "$file" | cut -f 4 -d '/' | cut -f 1 -d '.')
    echo " +dbname: $dbname"

    # Não há necessidade de criar a base de dados padrão.
    # A mesma já é criada pela imagem do Postgres.
    if [[ ! ${dbname} == "${defaultDbName}" ]]; then
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE DATABASE ${dbname} OWNER ${POSTGRES_USER};
  GRANT ALL PRIVILEGES ON DATABASE ${dbname} TO ${POSTGRES_USER};
EOSQL
    fi

    pg_restore --no-owner --no-privileges --exit-on-error --single-transaction --schema=public --role="${POSTGRES_USER}" --user="${POSTGRES_USER}" --dbname="${dbname}" "${file}"
  fi
done

# shellcheck disable=SC2125
FILES=/scripts/init-db/*.sql
for file in ${FILES}; do
  if [[ ! ${file} == '/scripts/init-db/*.sql' ]]; then
    echo " +script: $file"
    dbname=$(echo "$file" | cut -f 4 -d '/' | cut -f 1 -d '.')
    echo " +dbname: $dbname"

    # Não há necessidade de criar a base de dados padrão.
    # A mesma já é criada pela imagem do Postgres.
    if [[ ! ${dbname} == "${defaultDbName}" ]]; then
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE DATABASE ${dbname} OWNER ${POSTGRES_USER};
  GRANT ALL PRIVILEGES ON DATABASE ${dbname} TO ${POSTGRES_USER};
EOSQL
    fi

    # shellcheck disable=SC2002
    cat "${file}" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "${dbname}"
  fi
done

# shellcheck disable=SC2125
FILES=/scripts/*.sql
echo "Running post initialization scripts..."
for file in ${FILES}; do
  if [[ ! ${file} == '/scripts/*.sql' ]]; then
    echo " +script: $file"
    dbname=$(echo "$file" | cut -f 3 -d '/' | cut -f 1 -d '.')
    echo " +dbname: $dbname"

    # shellcheck disable=SC2002
    cat "${file}" | psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "${dbname}"
  fi
done

echo "All scripts executed with success!"

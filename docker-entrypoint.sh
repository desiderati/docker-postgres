#!/bin/bash
#
# Copyright (c) 2025 - Felipe Desiderati
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
# associated documentation files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial
# portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
# LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

set -e

# By default, the PostgreSQL Docker Image will create a database according to the $POSTGRES_DB variable.
# If this variable is not defined, the database will be created based on the $POSTGRES_USER variable.
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

    # There is no need to create the default database.
    # It is already created by the Postgres Docker Image.
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

    # There is no need to create the default database.
    # It is already created by the Postgres Docker Image.
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

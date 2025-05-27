#!/bin/bash
DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(cd "$DIR" >/dev/null 2>&1 && pwd)"
"$DIR"/postinstall.sh

echo "[$(date +%c)] Limpando TODOS os arquivos do diretório: $DIR/data/..."
rm -rf "$DIR"/data/*

echo "[$(date +%c)] Limpando TODOS os arquivos do diretório: $DIR/logs/..."
rm -rf "$DIR"/logs/*

"$DIR"/init.sh
"$DIR"/postinstall.sh

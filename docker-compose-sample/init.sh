#!/bin/bash
DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(cd "$DIR" >/dev/null 2>&1 && pwd)"

echo "[$(date +%c)] Criando os diretórios padrões da aplicação..."
sudo mkdir -p "$DIR"/data
sudo mkdir -p "$DIR"/logs
sudo mkdir -p "$DIR"/scripts

#!/bin/bash
set -e

# Load environment variables from .env file one directory up
if [ -f ../.env ]; then
  export $(grep -v '^#' ../.env | xargs)
fi

echo "[$(date)] Starting Backup..."

# 1. Dump MongoDB
echo "--> Dumping MongoDB..."
docker exec excalidraw-db mongodump \
  --username=$DB_USER \
  --password=$DB_PASS \
  --authenticationDatabase=admin \
  --out=/data/dump

# 2. Upload to Cloud
echo "--> Uploading to Backblaze B2..."
restic backup ../mongo-dumps --tag excalidraw

echo "--> Done! Snapshot saved."

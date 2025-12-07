#!/usr/bin/env bash
set -euo pipefail

echo "Excalidraw Disaster Recovery Script"
echo "===================================="

if [[ -z "${RESTIC_REPOSITORY:-}" ]]; then
  echo "Error: Please set restic environment variables first."
  exit 1
fi

echo "Available snapshots:"
restic snapshots
echo ""

read -p "Enter restore directory (e.g., /srv/excalidraw-restore): " RESTORE_DIR
mkdir -p "$RESTORE_DIR"

echo "Restoring latest snapshot..."
restic restore latest --target "$RESTORE_DIR"
echo "Done. Remember to run mongorestore."

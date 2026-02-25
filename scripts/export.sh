#!/bin/bash
# Export all n8n workflows to local folder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$SCRIPT_DIR/../workflows"

echo "📦 Exporting n8n workflows..."

# Create workflows directory
mkdir -p "$WORKFLOWS_DIR"

# Export from n8n container to temp location
docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/backups/

# Copy from container to local
docker cp n8n:/home/node/.n8n/backups/. "$WORKFLOWS_DIR/"

# Count exported files
COUNT=$(ls -1 "$WORKFLOWS_DIR"/*.json 2>/dev/null | wc -l)
echo "✅ Exported $COUNT workflows to workflows/"
ls -la "$WORKFLOWS_DIR/"

#!/bin/bash
# Import workflows to n8n

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$SCRIPT_DIR/../workflows"

# Copy workflows to container first
echo "📦 Copying workflows to n8n container..."
docker cp "$WORKFLOWS_DIR/." n8n:/home/node/.n8n/temp_import/

if [ -n "$1" ]; then
    # Import single workflow
    FILENAME=$(basename "$1")
    echo "📥 Importing single workflow: $FILENAME"
    docker exec n8n n8n import:workflow --input="/home/node/.n8n/temp_import/$FILENAME"
else
    # Import all workflows
    echo "📥 Importing all workflows..."
    for file in "$WORKFLOWS_DIR"/*.json; do
        if [ -f "$file" ]; then
            FILENAME=$(basename "$file")
            echo "  - Importing: $FILENAME"
            docker exec n8n n8n import:workflow --input="/home/node/.n8n/temp_import/$FILENAME" || echo "  ⚠️  Failed to import: $FILENAME"
        fi
    done
fi

# Cleanup temp folder
docker exec n8n rm -rf /home/node/.n8n/temp_import

echo "✅ Import complete!"
echo "⚠️  Note: Imported workflows are created as new. You may need to delete old versions in n8n UI."

#!/bin/bash
# Export all n8n workflows to local folder

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$SCRIPT_DIR/../workflows"
TEMP_DIR="$SCRIPT_DIR/../.temp_export"

echo "📦 Exporting n8n workflows..."

# Create directories
mkdir -p "$WORKFLOWS_DIR"
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Export from n8n container (may fail if no workflows)
if docker exec n8n n8n export:workflow --backup --output=/home/node/.n8n/backups/ 2>&1 | grep -q "No workflows found"; then
    echo "ℹ️  No workflows found in n8n"
    # Remove all local workflows since n8n is empty
    echo "🗑️  Removing all local workflows..."
    rm -f "$WORKFLOWS_DIR"/*.json
    COUNT=0
else
    # Copy to temp directory first
    docker cp n8n:/home/node/.n8n/backups/. "$TEMP_DIR/" 2>/dev/null || true

    # Remove old workflows that no longer exist in n8n
    echo "🗑️  Removing deleted workflows..."
    for file in "$WORKFLOWS_DIR"/*.json; do
        if [ -f "$file" ]; then
            FILENAME=$(basename "$file")
            if [ ! -f "$TEMP_DIR/$FILENAME" ]; then
                echo "  - Deleted: $FILENAME"
                rm "$file"
            fi
        fi
    done

    # Move new/updated workflows
    echo "📥 Updating workflows..."
    mv "$TEMP_DIR"/*.json "$WORKFLOWS_DIR/" 2>/dev/null || true

    # Count exported files
    COUNT=$(ls -1 "$WORKFLOWS_DIR"/*.json 2>/dev/null | wc -l)
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Synced $COUNT workflows to workflows/"
ls -la "$WORKFLOWS_DIR/"

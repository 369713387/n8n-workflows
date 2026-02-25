#!/bin/bash
# Sync: Export workflows and commit to Git

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."
COMMIT_MSG="${1:-"Sync n8n workflows"}"

cd "$PROJECT_DIR"

echo "🔄 Syncing n8n workflows..."

# Export workflows
"$SCRIPT_DIR/export.sh"

# Git operations
echo "📝 Committing changes..."
git add .
git status

if git diff --cached --quiet; then
    echo "ℹ️  No changes to commit"
else
    git commit -m "$COMMIT_MSG"
    echo "✅ Committed: $COMMIT_MSG"
fi

# Show status
echo ""
echo "📊 Git Status:"
git log --oneline -3
echo ""
echo "To push: git push origin main"

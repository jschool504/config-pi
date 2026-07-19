#!/usr/bin/env bash
set -euo pipefail

# kb-add.sh - Add a knowledge base entry
# Usage: kb-add.sh <title> <tags> <content>
#   $1  - title (string)
#   $2  - tags (comma-separated, e.g. "bash,shell,automation")
#   $3  - content (string)

if [ $# -ne 3 ]; then
  echo "Usage: $0 <title> <tags> <content>"
  exit 1
fi

TITLE="$1"
TAGS="$2"
CONTENT="$3"

# Determine script directory for resolving paths
SCRIPT_DIR="$(dirname "$0")"

# Generate slug from title
# 1. Lowercase
# 2. Replace non-alphanumeric chars with hyphens
# 3. Collapse multiple hyphens
# 4. Trim leading/trailing hyphens
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g' \
  | sed 's/-\{2,\}/-/g' \
  | sed 's/^-//;s/-$//')

ENTRY_FILE="${SCRIPT_DIR}/entries/${SLUG}.md"

# Check if entry already exists
if [ -f "$ENTRY_FILE" ]; then
  echo "Warning: entry already exists"
  exit 1
fi

# Write the entry file
cat > "$ENTRY_FILE" <<EOF
---
title: "${TITLE}"
tags: [${TAGS}]
created: $(date +%Y-%m-%d)
hits: 0
---
${CONTENT}
EOF

echo "Created: entries/${SLUG}.md"

# Commit and push
cd /Users/jschool/.pi/agent && git add -A && git commit -m "kb: add entry $SLUG" && git push

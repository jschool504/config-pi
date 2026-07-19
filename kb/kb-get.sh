#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: kb-get.sh <slug>" >&2
  exit 1
fi

SLUG="$1"
DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="${DIR}/entries/${SLUG}.md"

if [ ! -f "$FILE" ]; then
  echo "Error: entries/${SLUG}.md not found" >&2
  exit 1
fi

# Increment hits in frontmatter
CURRENT=$(grep '^hits:' "$FILE" | head -1 | sed 's/^hits: *//')
NEW=$((CURRENT + 1))
sed -i '' "s/^hits: .*/hits: ${NEW}/" "$FILE"

# Print full file content
cat "$FILE"

# Commit and push
cd /Users/jschool/.pi/agent && git add -A && git commit -m "kb: bump hits for $SLUG" && git push

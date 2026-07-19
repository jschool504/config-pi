#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <slug> <new_content>" >&2
  exit 1
fi

SLUG="$1"
NEW_CONTENT="$2"
DIR="$(cd "$(dirname "$0")" && pwd)"
FILE="${DIR}/entries/${SLUG}.md"

if [ ! -f "$FILE" ]; then
  echo "Error: entries/${SLUG}.md not found" >&2
  exit 1
fi

TODAY="$(date +%Y-%m-%d)"

# Update 'updated' date in frontmatter
if grep -q '^updated:' "$FILE"; then
  sed -i '' "s/^updated:.*/updated: ${TODAY}/" "$FILE"
else
  # Add 'updated: <date>' right after 'created:'
  if grep -q '^created:' "$FILE"; then
    sed -i '' "/^created:/a updated: ${TODAY}" "$FILE"
  else
    # Fallback: append 'updated' right after 'hits:'
    sed -i '' "/^hits:/a updated: ${TODAY}" "$FILE"
  fi
fi

# Append new content under versioned header
echo "" >> "$FILE"
echo "### Update: ${TODAY}" >> "$FILE"
echo "" >> "$FILE"
echo "$NEW_CONTENT" >> "$FILE"

# Commit and push
cd /Users/jschool/.pi/agent && git add -A && git commit -m "kb: update $SLUG" && git push

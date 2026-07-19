#!/usr/bin/env bash
# kb-search.sh – Search knowledge-base entries by query string
# Usage: kb-search.sh "<query>"
#
# Scoring (case-insensitive):
#   tag match    → 3× weight per term
#   title match  → 2× weight per term
#   content match→ 1× weight per term
#   hits field   → tiebreaker (higher wins)
#
# Multi-word queries are split on whitespace and each term is scored
# independently. Scores from all terms are aggregated.

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <query>" >&2
  exit 1
fi

QUERY="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENTRIES_DIR="$SCRIPT_DIR/entries"
QUERY_LC="$(echo "$QUERY" | tr '[:upper:]' '[:lower:]')"

# Split query into terms on whitespace
read -ra TERMS <<< "$QUERY_LC"

# Escape each term for grep (treat as literal strings)
declare -a ESCAPED_TERMS=()
for term in "${TERMS[@]}"; do
  ESCAPED_TERMS+=("$(echo "$term" | sed 's/[.[\*^$()+?{|\\]/\\&/g')")
done

if [[ ! -d "$ENTRIES_DIR" ]]; then
  echo "No matches found."
  exit 0
fi

tmpfile="$(mktemp)"
trap 'rm -f "$tmpfile"' EXIT

found=0

while IFS= read -r -d '' filepath; do
  slug="$(basename "$filepath" .md)"

  # ---- extract frontmatter ----
  title=""
  tags=""
  hits=0
  content=""
  in_fm=0
  fm_done=0

  while IFS= read -r line; do
    if [[ $fm_done -eq 1 ]]; then
      content="${content}${line}"$'\n'
      continue
    fi
    if [[ $in_fm -eq 0 ]]; then
      if [[ "$line" == "---" ]]; then
        in_fm=1
      fi
      continue
    fi
    # Inside frontmatter
    if [[ "$line" == "---" ]]; then
      fm_done=1
      continue
    fi
    key="${line%%:*}"
    val="${line#*: }"
    key="$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr '[:upper:]' '[:lower:]')"
    case "$key" in
      title) title="$val" ;;
      tags)  tags="$val" ;;
      hits)  hits="$val" ;;
    esac
  done < "$filepath"

  if [[ -z "$title" ]]; then
    title="$slug"
  fi

  # Strip trailing newline from content
  content="${content%$'\n'}"
  content_lc="$(echo "$content" | tr '[:upper:]' '[:lower:]')"
  title_lc="$(echo "$title" | tr '[:upper:]' '[:lower:]')"

  # ---- scoring ----
  score=0
  snippet_parts=""

  # Parse tags into array (trimmed, lowercase)
  IFS=',' read -ra tag_arr <<< "$tags"
  declare -a clean_tags=()
  for t in "${tag_arr[@]}"; do
    t_trimmed="$(echo "$t" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | tr '[:upper:]' '[:lower:]')"
    clean_tags+=("$t_trimmed")
  done

  for idx in "${!TERMS[@]}"; do
    term="${TERMS[$idx]}"
    escaped="${ESCAPED_TERMS[$idx]}"

    # Tag match (3×) – check if any tag contains this term
    for tag in "${clean_tags[@]}"; do
      if echo "$tag" | grep -qi "$escaped"; then
        score=$((score + 3))
        snippet_parts="${snippet_parts}tags: $tag "
        break  # don't double-count same term across tags
      fi
    done

    # Title match (2×) – check if title contains this term
    if echo "$title_lc" | grep -qi "$escaped"; then
      score=$((score + 2))
      if [[ -z "$snippet_parts" ]]; then
        snippet_parts="$title "
      fi
    fi

    # Content match (1×) – check if content contains this term
    if [[ -n "$content" ]] && echo "$content_lc" | grep -qi "$escaped"; then
      score=$((score + 1))
      if [[ -z "$snippet_parts" ]]; then
        snippet_parts="$(echo "$content" | sed '/^[[:space:]]*$/d' | head -1) "
      fi
    fi
  done

  unset clean_tags

  # Only record if there's at least one match
  if [[ $score -gt 0 ]]; then
    found=1

    snippet="${snippet_parts% }"  # trim trailing space

    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$score" "$slug" "$title" "$tags" "$hits" "$snippet" >> "$tmpfile"
  fi

done < <(find "$ENTRIES_DIR" -maxdepth 1 -name '*.md' -print0 | sort -z)

# ---- output ----
if [[ $found -eq 0 ]]; then
  echo "No matches found."
  exit 0
fi

# Sort: score desc, then hits desc
sort -t$'\t' -k1,1nr -k5,5nr "$tmpfile" | while IFS=$'\t' read -r sc slg tgl tgs hts snp; do
  # Strip surrounding quotes from title
  tgl="${tgl#\"}"
  tgl="${tgl%\"}"
  # Tags may already be wrapped in [] from frontmatter; don't double-wrap
  if [[ -n "$tgs" ]]; then
    case "$tgs" in
      \[*\]) tag_display="$tgs" ;;
      *)      tag_display="[$tgs]" ;;
    esac
  else
    tag_display="[]"
  fi
  printf "[%s] %s | %s | %s | hits: %s\n" "$sc" "$slg" "$tgl" "$tag_display" "$hts"
  printf "  Snippet: %s\n" "$snp"
done

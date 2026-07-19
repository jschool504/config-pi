---
description: Search the knowledge base, read top results, and summarize for the user
argument-hint: "<search-query>"
---

Search the knowledge base for relevant information matching the query below.

Query: ${1:-"query"}

1. Spawn the `memory` agent to run `./kb/kb-search.sh "<query>"`.
2. If results are found, spawn additional `memory` agents to run `./kb/kb-get.sh <slug>` for the **top 3-5 results**.
3. Read the retrieved content and provide a concise TL;DR summary of the findings to the user. Group related information logically.
4. If no results are found, simply report "No matches found."

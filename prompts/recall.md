---
description: Search the knowledge base for relevant information
argument-hint: "<search-query>"
---

Search the knowledge base for relevant information matching the query below.

Query: ${1:-"query"}

Spawn the `memory` agent to run `./kb/kb-search.sh "<query>"`. Return the ranked results. If multiple high-scoring entries are found, summarize the top 3-5 matches. If the user wants full content of a specific entry, follow up with `kb-get.sh <slug>`.

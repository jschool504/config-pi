---
description: Scan conversation history and store key takeaways in the knowledge base
argument-hint: "<optional topic to focus on>"
---

Review the conversation history since the last `retain` call (or the beginning of the session if this is the first one). Identify key takeaways worth storing in the knowledge base.

Focus on:
- Bugfixes and interesting implementation details
- Architectural or technical decisions made
- Generated application metadata or configurations
- Any other information that might be useful in the future

Be liberal about what you store. If the user provided an optional topic (${1:-""}), focus your search on items related to that topic. Otherwise, scan broadly.

For each identified takeaway, spawn the `memory` agent to execute the search-and-merge workflow: search for existing entries, and append to them if related, or create a new entry if not.

Report back a list of what was retained and where it was stored (new entry or appended to existing).

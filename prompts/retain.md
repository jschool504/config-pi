---
description: Store new knowledge in the project knowledge base
argument-hint: "<title> <tags> <content>"
---

Store the following information in the knowledge base via the `memory` subagent.

Title: ${1:-"Untitled"}
Tags: ${2:-"general"}
Content: ${3:-"Content to be stored"}

Spawn the `memory` agent to execute `./kb/kb-add.sh` with these arguments. Ensure tags are comma-separated and the slug will auto-generate. Confirm the entry was created successfully.

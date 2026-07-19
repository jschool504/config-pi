---
title: "State Management & Session Model"
tags: [prototype-web-builder,state,sessions,uuid,sqlite,schema]
created: 2026-07-19
hits: 0
---
## Session Model
- **No user accounts** — anonymous by design
- Sessions identified by random **UUIDs**
- Stable shareable URLs: 

## SQLite Schema
- **sessions**: session metadata (UUID, created_at, expires_at)
- **messages**: chat history per session (turns with role/content)
- **design_states**: latest JSON schema per session (the current mockup)
- **prototypes**: final generated HTML/CSS artifacts

## Key Design Choices
- WAL mode enabled for performance
- No auth middleware overhead
- Simple, fast reads for preview rendering

---
title: "Tech Stack: React + Tailwind + Rust + SQLite + OpenRouter"
tags: [prototype-web-builder,tech-stack,react,tailwind,rust,sqlite,openrouter]
created: 2026-07-19
updated: 2026-07-20hits: 1
---
## Frontend
- **React + Tailwind**: UI framework and styling for the chat interface and live preview

## Backend
- **Rust**: API server, JSON validation, HTML/CSS generation from design schemas

## Database
- **SQLite**: Session storage, message history, design states, prototype artifacts
- **WAL mode** enabled for concurrent read/write performance

## LLM Provider
- **OpenRouter** as unified API layer
- Models: **Qwen 27B** and **Gemma 31B** (cost-efficient, high quality)

## Hosting
- Low-cost VPS deployment

### Update: 2026-07-20

## Backend Stack Update (v2)
- **Poem**: Replaced generic Rust API server with Poem web framework for structured routing and middleware
- **Diesel**: ORM for database interactions with compile-time checked queries
- **SQLite** retained with PRAGMA journal_mode=WAL for concurrent read/write performance
- LLM Provider unchanged: OpenRouter with Qwen 27B and Gemma 31B

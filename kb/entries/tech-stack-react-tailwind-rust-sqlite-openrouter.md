---
title: "Tech Stack: React + Tailwind + Rust + SQLite + OpenRouter"
tags: [prototype-web-builder,tech-stack,react,tailwind,rust,sqlite,openrouter]
created: 2026-07-19
hits: 0
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

---
title: "Poem 3.x API Quirks"
tags: [poem,rust,web-framework,static-files,sse,middleware]
created: 2026-07-21
hits: 0
---
- Use `StaticFilesEndpoint` (plural) for directory serving, NOT `StaticFileEndpoint`
- `StaticFileResponse` does NOT exist in `poem::endpoint`
- Need `use poem::EndpointExt;` for the `.with()` middleware method
- SSE uses `SSE::new()` with `Stream<Item = Event>`, NOT `Stream<Item = Result<Event, _>>`
- SSE events use `Event::message()`, NOT `Event::normal()`
- `Route` does NOT have a `.fallback()` method — use different routing patterns
- Cargo features needed: `static-files` (not `static`), `sse`, `futures`

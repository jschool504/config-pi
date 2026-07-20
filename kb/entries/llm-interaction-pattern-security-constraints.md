---
title: "LLM Interaction Pattern & Security Constraints"
tags: [prototype-web-builder,llm-interaction,json-patch,validation,security,rate-limiting]
created: 2026-07-19
hits: 1
---
## LLM Interaction
- **JSON patches** for incremental updates instead of full re-generation (saves tokens)
- **Strict server-side validation** on every LLM response — rejects hallucinated schema fields or invalid structures
- Complex/out-of-scope requests are handled by funnelling users to a **Calendly booking link**

## Security Constraints (v1)
- **IP rate limiting** on API endpoints
- **Message caps** per session to control costs
- **XSS escaping** on all user-provided content before rendering
- **No custom image uploads** in v1 — uses placeholder images only
- All LLM calls routed through OpenRouter (no direct API key exposure)

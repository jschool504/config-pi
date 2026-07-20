---
title: "LLM Interaction Pattern & Security Constraints"
tags: [prototype-web-builder,llm-interaction,json-patch,validation,security,rate-limiting]
created: 2026-07-19
updated: 2026-07-20hits: 1
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

### Update: 2026-07-20

## Interaction Model — Tool Calls (v2)
- **Tool Calls** replace plain JSON patches for actions (e.g., apply_mockup, update_section, next_stage)
- Tool calls are visualized in the chat UI as structured action cards
- **Silent Validation**: Backend silently corrects invalid tool arguments (e.g., clamping color values to valid Tailwind palette, fixing out-of-range numbers) instead of rejecting them outright. This prevents conversation-killing validation errors while maintaining correctness.

## Security Constraints (unchanged)
- IP rate limiting, message caps, XSS escaping, no custom image uploads in v1, OpenRouter routing
- Complex/out-of-scope requests funneled to Calendly booking link

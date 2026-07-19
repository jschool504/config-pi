---
title: "Design System: On-the-Rails JSON Schema"
tags: [prototype-web-builder,design-system,architecture,llm,json-schema]
created: 2026-07-19
hits: 0
---
## Concept
"On-the-rails" approach: LLM generates a structured JSON schema from a fixed set of predefined section types, rather than free-form HTML or unconstrained output.

## Section Types
- Hero, Features, Pricing, Testimonials, CTA, Footer, etc.
- Each section has a defined schema (props, grid layout, styling tokens)

## Pipeline
1. LLM outputs JSON schema describing the desired page layout
2. **React** renders the JSON into a live, editable preview in the browser
3. **Rust** backend converts the validated JSON schema into final production-ready HTML/CSS

## Benefits
- Prevents LLM hallucination of invalid HTML/CSS
- Enables incremental JSON patch updates (token-efficient)
- Consistent, professional output every time

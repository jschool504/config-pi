---
title: "Stage Graph — Langgraph-y Workflow"
tags: [prototype-web-builder,stage-graph,langgraph,workflow,session-state]
created: 2026-07-20
hits: 2
---
## Architecture
Decision-driven stage progression modeled after Langgraph patterns, where each stage is a node in a directed graph and transitions are triggered by LLM tool calls.

## Stages (Directed Graph)
1. **Discovery** — User describes the project; LLM extracts requirements
2. **Layout** — LLM selects and arranges MVP section types (Hero, Features, About, Testimonials, CTA, Footer)
3. **Design** — LLM applies color palette (Tailwind tokens only), typography (system fonts), spacing
4. **Refining** — LLM adjusts content, copy, and micro-copy based on feedback
5. **CTA** — Final polish: call-to-action placement, conversion optimization

## Session Storage
- **sessions** table tracks:
  - `current_stage` — integer enum mapping to active stage
  - `stage_history` — JSON array recording each stage transition (timestamp, stage name, trigger tool call)

## Transitions
- LLM triggers stage transitions via tool calls (e.g., `next_stage`)
- Transitions update the UI: header progress bar, layout swap
- Backend validates transitions are legal (no skipping stages without justification)

---
title: "Recommendation Graph Architecture and Redesign"
tags: [recommendation-graph,langgraph,graph-architecture,llm-optimization,cache-optimization,cre,engine]
created: 2026-07-21
updated: 2026-07-21
hits: 3
---
Current LangGraph graph structure (as of 2026-07-21):\n\n\nKey issues identified:\n- Sequential single-point evaluation forces N serial LLM round-trips (N+2 total calls)\n- previousEvaluationResults injected into every prompt forces sequentiality and destroys cache hits\n- Patient context re-fed 3x+ across breakdown, each evaluate iteration, and summarize\n- No data sufficiency checkpoint before expensive LLM work\n- Each node creates fresh invoke() with new SystemMessage + HumanMessage — no cache benefit between nodes\n\nProposed redesign:\n\n\nKey design decisions:\n1. **Data sufficiency gate** — Own node after context establishment, uses structured output (zod schema: sufficient, confidence, coveredDomains, missingDomains, rationale) for deterministic routing\n2. **Single conversation chain** —  array in state with . Each node appends delta (human + AI turn), never re-injects patient context\n3. **Cache optimization** — Three-block ordering: Block 1 (STABLE: system + protocol + patient), Block 2 (GROWING: results), Block 3 (VARIABLE: current point). CachePoint breakpoint after stable prefix\n4. **Reconcile replaces summarize_results** — In-chain turn over already-cached conversation, near-free because full prefix is cached\n5. **Batching for large N** — 3-5 checkpoints per execute_step turn to control O(N²) token growth\n6. **Rolling cache breakpoint** — Moves forward as conversation grows, converting evaluations into cached reads\n\nO(N²) trap: Even with prompt caching, growing conversation means call k sends k turns. Caching discounts stable prefix, not accumulating middle. Mitigated by: batching, rolling cache point, state-backed ledger\n\nFile layout: core/src/engines/recommendation/graph.ts + nodes/* + routing.ts + schemas.ts\n\nLLM stack: ChatBedrockConverse with Claude Sonnet 4.6, no cache breakpoints currently configured

### Update: 2026-07-21

--- FORMAT FIX (2026-07-21) ---

Graph structures (fix mangled code blocks):

CURRENT: __start__ -> parse_points -> breakdown_points -> evaluate_point -> save_step -> [route] -> (evaluate_point | summarize_results) -> __end__

PROPOSED: __start__ -> establish_context -> assess_sufficiency -> [gate] -> plan_evaluation -> execute_step -> save_step -> route_execution -> reconcile -> persist_recommendation -> __end__

Inline code fixes: 'messages' array in state with 'messagesStateReducer'.

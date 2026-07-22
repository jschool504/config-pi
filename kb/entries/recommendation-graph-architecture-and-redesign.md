---
title: "Recommendation Graph Architecture and Redesign"
tags: [recommendation-graph,langgraph,graph-architecture,llm-optimization,cache-optimization,cre,engine]
created: 2026-07-21
updated: 2026-07-21
hits: 4
---
Current LangGraph graph structure (as of 2026-07-21):\n\n\nKey issues identified:\n- Sequential single-point evaluation forces N serial LLM round-trips (N+2 total calls)\n- previousEvaluationResults injected into every prompt forces sequentiality and destroys cache hits\n- Patient context re-fed 3x+ across breakdown, each evaluate iteration, and summarize\n- No data sufficiency checkpoint before expensive LLM work\n- Each node creates fresh invoke() with new SystemMessage + HumanMessage — no cache benefit between nodes\n\nProposed redesign:\n\n\nKey design decisions:\n1. **Data sufficiency gate** — Own node after context establishment, uses structured output (zod schema: sufficient, confidence, coveredDomains, missingDomains, rationale) for deterministic routing\n2. **Single conversation chain** —  array in state with . Each node appends delta (human + AI turn), never re-injects patient context\n3. **Cache optimization** — Three-block ordering: Block 1 (STABLE: system + protocol + patient), Block 2 (GROWING: results), Block 3 (VARIABLE: current point). CachePoint breakpoint after stable prefix\n4. **Reconcile replaces summarize_results** — In-chain turn over already-cached conversation, near-free because full prefix is cached\n5. **Batching for large N** — 3-5 checkpoints per execute_step turn to control O(N²) token growth\n6. **Rolling cache breakpoint** — Moves forward as conversation grows, converting evaluations into cached reads\n\nO(N²) trap: Even with prompt caching, growing conversation means call k sends k turns. Caching discounts stable prefix, not accumulating middle. Mitigated by: batching, rolling cache point, state-backed ledger\n\nFile layout: core/src/engines/recommendation/graph.ts + nodes/* + routing.ts + schemas.ts\n\nLLM stack: ChatBedrockConverse with Claude Sonnet 4.6, no cache breakpoints currently configured

### Update: 2026-07-21

--- FORMAT FIX (2026-07-21) ---

Graph structures (fix mangled code blocks):

CURRENT: __start__ -> parse_points -> breakdown_points -> evaluate_point -> save_step -> [route] -> (evaluate_point | summarize_results) -> __end__

PROPOSED: __start__ -> establish_context -> assess_sufficiency -> [gate] -> plan_evaluation -> execute_step -> save_step -> route_execution -> reconcile -> persist_recommendation -> __end__

Inline code fixes: 'messages' array in state with 'messagesStateReducer'.

### Update: 2026-07-21

## Implementation Task Breakdown (18 tasks, 8 phases)

### Phase 1 — Foundation (Tasks 1-2)
- **Task 1:** Define Zod schemas in `core/src/engines/langgraph/schemas.ts` (new file)
  - SufficiencyVerdict: { sufficient: boolean, confidence: number, coveredDomains: string[], missingDomains: string[], rationale: string }
  - PlanStep: { id: string, instruction: string, category: string, dependsOn?: string[] }
  - EvaluationResult: { stepId: string, verdict: string, reasoning: string, insufficient?: boolean, missingData?: string[] }
- **Task 2:** Extend recommendation-state.ts with messages accumulator (BaseMessage[] with messagesStateReducer), sufficiency, evaluationPlan, and structured evaluationResults

### Phase 2 — New Nodes (Tasks 3-8)
- **Task 3:** establish-context.node.ts — pure JS, builds cacheable prefix with cachePoint, no LLM
- **Task 4:** assess-sufficiency.node.ts — LLM structured output via withStructuredOutput()
- **Task 5:** emit-insufficiency-error.node.ts — pure JS, diagnostic from missingDomains + rationale
- **Task 6:** plan-evaluation.node.ts — replaces breakdown_points, appends to conversation
- **Task 7:** execute-step.node.ts — batchable (3-5 steps per turn), graceful degradation with INSUFFICIENT verdict
- **Task 8:** reconcile.node.ts — replaces summarize_results, in-chain synthesis over cached prefix

### Phase 3 — Routing (Task 9)
- routing.ts with routeSufficiency and routeExecution functions, batch-aware

### Phase 4 — Graph Wiring (Tasks 10-11)
- **Task 10:** Wire new topology in recommendation-graph.ts, remove old nodes
- **Task 11:** Update save-step for structured EvaluationResult[] and batch writes

### Phase 5 — Prompt Restructuring (Tasks 12-14)
- **Task 12:** Remove previousEvaluationResults from evaluation prompt, three-block cache ordering
- **Task 13:** Protocol breakdown prompt outputs PlanStep[] instead of string[]
- **Task 14:** Pre-visit report prompt accepts structured EvaluationResult[] ledger

### Phase 6 — Cache Integration (Task 15)
- llm-providers.ts: verify @langchain/aws cachePoint support, log cache metrics

### Phase 7 — Tests (Tasks 16-17)
- Unit tests for each new node, integration test for full graph flow
- Test paths: happy path, insufficient data early-exit, batch boundary

### Phase 8 — Cleanup (Task 18)
- Delete: parse-points.node.ts, route-execution.node.ts, summarize-results.node.ts
- Update exports, verify clean build

## Rollout Order (confirmed)
1. Cache breakpoints + prompt reordering (non-behavioral)
2. Data sufficiency gate
3. Single conversation chain (messages reducer)
4. Batching + rolling cache point
5. Postgres checkpointer (optional)

---
title: "LangGraph Patterns and State Management"
tags: [langgraph,state-management,checkpointers,routing,state-annotation,cre]
created: 2026-07-21
updated: 2026-07-21
hits: 1
---
### Messages Accumulator Pattern (Single Conversation Chain)

Use  with a reducer for append-only message merging — never rebuild the full message list in nodes.



### Node Pattern — Append-Only Delta

Nodes should **never rebuild context**. Instead, append only the new delta (the turn and response).



Key rule: Always spread  before invoking the model, and return only the new messages in the delta. The reducer handles merging.

### Checkpointers

- **MemorySaver**: In-memory only — fine for tests and dev, but does NOT survive process restarts.
- **Production**: Use a Postgres-backed checkpointer keyed by .
- **What checkpointers buy**: Crash recovery, human-in-the-loop capability, debug/replay.
- **What checkpointers do NOT do**: They do NOT enable prompt caching — that is purely about request bytes sent to the LLM.

### Sufficiency Gate Routing

Use a conditional routing function to gate on sufficiency and confidence before proceeding to deeper evaluation.



This pattern keeps the graph clean — sufficiency checks act as early-exit guards before expensive steps.

### Recursion Limit

Set recursion limit as a **function of batch count**, not a raw static number. This ensures the graph scales with work volume and prevents runaway loops.

### Update: 2026-07-21

### Messages Accumulator Pattern (Single Conversation Chain)

Use `Annotation.Root` with a reducer for append-only message merging — never rebuild the full message list in nodes.

```typescript
const StateAnnotation = Annotation.Root({
  messages: Annotation<BaseMessage[]>({
    reducer: messagesStateReducer,  // append-only merge
    default: () => [],
  }),
});
```

### Update: 2026-07-21


### Node Pattern — Append-Only Delta

Nodes should **never rebuild context**. Instead, append only the new delta (the turn and response).

```typescript
const turn = new HumanMessage(`Evaluate step: ${instruction}`);
const ai = await model.invoke([...state.messages, turn]);
return { messages: [turn, ai], /* other state updates */ };
```

Key rule: Always spread `state.messages` before invoking the model, and return only the new messages in the delta. The reducer handles merging.

### Update: 2026-07-21


### Checkpointers

- **MemorySaver**: In-memory only — fine for tests and dev, but does NOT survive process restarts.
- **Production**: Use a Postgres-backed checkpointer keyed by `thread_id = sessionId`.
- **What checkpointers buy**: Crash recovery, human-in-the-loop capability, debug/replay.
- **What checkpointers do NOT do**: They do NOT enable prompt caching — that is purely about request bytes sent to the LLM.

---
title: "Model Instantiation Pattern"
tags: [llm,models,ChatBedrockConverse,llm-providers,provider-injection,context,caching,sonnet,haiku]
created: 2026-07-21
hits: 1
---
All ChatBedrockConverse LLM instances are created in `core/src/providers/llm-providers.ts`.

- **No Singleton Wrappers**: The `model` and `fastModel` providers are NOT wrapped in `singleton()` — they are cached per-context-instance via the Context class Map-based caching.
- **Lazy Instantiation**: Models are instantiated lazily during request flow, never during bootstrap. This avoids cold-start overhead and unnecessary provider initialization.
- **Default Models**: Sonnet 4.6 is the default main model; Haiku 4.5 is the default fast model.

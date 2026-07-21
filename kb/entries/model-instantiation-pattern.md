---
title: "Model Instantiation Pattern"
tags: [llm,models,ChatBedrockConverse,llm-providers,provider-injection,context,caching,sonnet,haiku]
created: 2026-07-21
hits: 1
---
All ChatBedrockConverse LLM instances are created in .\n\n- **No Singleton Wrappers**: The  and  providers are NOT wrapped in  — they are cached per-context-instance via the Context class's Map-based caching.\n- **Lazy Instantiation**: Models are instantiated lazily during request flow, never during bootstrap. This avoids cold-start overhead and unnecessary provider initialization.\n- **Default Models**: Sonnet 4.6 is the default main model; Haiku 4.5 is the default fast model.

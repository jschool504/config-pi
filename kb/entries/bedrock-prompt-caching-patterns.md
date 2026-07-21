---
title: "Bedrock Prompt Caching Patterns"
tags: [aws-bedrock,prompt-caching,langchain,optimization,llm,performance,ChatBedrockConverse,cost-reduction]
created: 2026-07-21
hits: 0
---
Prompt caching via Bedrock Converse API (ChatBedrockConverse from @langchain/aws):
- Uses cachePoint content blocks (verify exact shape against installed @langchain/aws version)
- Up to 4 cache breakpoints per request
- ~1k token minimum for caching
- ~5 minute cache TTL
- Cache hits require stable, contiguous prefix — any byte drift = cache miss

Three-block prompt ordering for maximum cache hits:
Block 1 [STABLE, cached]     → system instructions + protocol + ALL evaluation points + patient data
Block 2 [GROWING, cached]    → previousEvaluationResults (append-only)
Block 3 [VARIABLE, uncached] → "Now evaluate the following point(s): ..."

Cache placement example:
new HumanMessage({
  content: [
    { type: "text", text: protocolDefinition + patientContext },
    { cachePoint: { type: "default" } },   // breakpoint after stable
    { type: "text", text: serializedPreviousResults },
    { cachePoint: { type: "default" } },   // rolling breakpoint
    { type: "text", text: `Evaluate: ${currentBatch}` },  // variable, no cache
  ],
});

Determinism requirements:
- Serialize stable block identically every call (stable key ordering, no timestamps, no Date.now())
- Monitor cacheReadInputTokens from Bedrock usage to verify caching works
- Cache hit rate by design: Current interleaved ~0%, reordered sequential high, parallel/batch highest

Model defaults: us.anthropic.claude-sonnet-4-6 (Thinker), us.anthropic.claude-haiku-4-5-20251001-v1:0 (Watchdog)

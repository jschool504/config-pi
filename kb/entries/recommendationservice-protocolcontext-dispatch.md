---
title: "RecommendationService ProtocolContext dispatch"
tags: [recommendation-service,ProtocolContext,protocol-dispatch,fail-fast,recommendation-generation]
created: 2026-07-21
hits: 0
---
### RecommendationService.generateRecommendations() — ProtocolContext dispatch (2026-07-21)

- **Location**: `core/src/services/recommendation-service.ts`
- `generateRecommendations()` only has explicit handlers for two `ProtocolContext` types:
  - `AGENDA` → routes to `generateAgendaRecommendations`
  - `PRE_VISIT_PREP` → routes to `generatePreVisitPrepRecommendations`
- Any other `ProtocolContext` value throws `Error("Unsupported ProtocolContext type: ${type}")` — no fallback/default behavior
- Intentionally changed from a silent fallback to `generatePreVisitPrepRecommendations()` to fail fast on unhandled types
- Six types are unhandled and throw: COACH_GUIDANCE, CHART_DRAFT, THERAPEUTIC, DIAGNOSIS, CARE_PLAN, DIAGNOSIS_ORDER
- **Related test**: `core/src/services/__tests__/recommendation-service.test.ts` verifies all 6 unhandled types throw the expected error
- The `ProtocolContext` enum is defined in `lib/src/models/index.ts` with 8 values total

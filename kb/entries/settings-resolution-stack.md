---
title: "Settings Resolution Stack"
tags: [settings,configuration,environment,secrets,RDS,dot-notation,deepMerge,circular-dependency]
created: 2026-07-21
hits: 1
---
The CRE uses a hierarchical settings system for configuration management:

- **Resolution Order**: base.json → environment-specific JSON (development/staging/production) → local.json (excluded from Docker via .gitignore). Then overlays RDS secrets and AWS Secrets Manager overlay for staging/production environments.
- **Secrets Overlay**: Dot-notation keys (e.g., "llm.providers.bedrock.model") are expanded via `expandDotNotation()` and merged with `deepMerge()` into the settings hierarchy.
- **File Location**: The Settings class lives in `lib/src/config.ts` with a re-export in `core/src/config/settings.ts` to avoid circular dependencies between the lib and core packages.

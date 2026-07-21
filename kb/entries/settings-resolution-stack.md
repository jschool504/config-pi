---
title: "Settings Resolution Stack"
tags: [settings,configuration,environment,secrets,RDS,dot-notation,deepMerge,circular-dependency]
created: 2026-07-21
hits: 0
---
The CRE uses a hierarchical settings system for configuration management:\n\n- **Resolution Order**: base.json → environment-specific JSON (development/staging/production) → local.json (excluded from Docker via .gitignore). Then overlays RDS secrets and AWS Secrets Manager overlay for staging/production environments.\n- **Secrets Overlay**: Dot-notation keys (e.g., "llm.providers.bedrock.model") are expanded via  and merged with  into the settings hierarchy.\n- **File Location**: The  class lives in  with a re-export in  to avoid circular dependencies between the lib and core packages.

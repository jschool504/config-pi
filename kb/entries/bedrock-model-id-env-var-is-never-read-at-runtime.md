---
title: "BEDROCK_MODEL_ID env var is never read at runtime"
tags: [aws-bedrock,llm,environment-variables,settings,configuration]
created: 2026-07-21
updated: 2026-07-21
hits: 1
---
The BEDROCK_MODEL_ID environment variable is documented in  but is **never actually read** anywhere in the CRE codebase.

- The LLM provider reads model settings exclusively via , not from environment variables.
- Only , , and  are used as env var overrides (these go directly to AWS SDK credential providers).
- BEDROCK_MODEL_ID in  is a **dead/dummy variable** — removing it or renaming it would have no effect on runtime behavior.
- Model configuration lives in the settings hierarchy (e.g., ), not in environment variables.

Lesson: Environment variables in  that aren't consumed by the codebase are misleading. Only surface env vars that are actually read.

### Update: 2026-07-21

## Corrections (backticks stripped by shell in initial entry)

The BEDROCK_MODEL_ID env var is documented in `~/.env.example` but is **never actually read** anywhere in the CRE codebase.

- The LLM provider reads model settings exclusively via `ctx.settings.get()`, not from environment variables.
- Only `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION` are used as env var overrides (these go directly to AWS SDK credential providers).
- BEDROCK_MODEL_ID in `.env.example` is a **dead/dummy variable** -- removing it or renaming it would have no effect on runtime behavior.
- Model configuration lives in the settings hierarchy (e.g., `local.json`), not in environment variables.

Lesson: Environment variables in `.env.example` that aren't consumed by the codebase are misleading. Only surface env vars that are actually read.

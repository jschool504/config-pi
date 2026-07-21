---
title: "PGlite removal from CRE (v0.2.1)"
tags: [pglite,database,migration,v0.2.1,typeorm,dependency-removal]
created: 2026-07-20
updated: 2026-07-20
hits: 2
---
- Main branch v0.2.1 completely removed PGlite (in-memory WASM PostgreSQL). Replaced with TypeORM migration infrastructure for local development.
- Dependencies removed: , 
- DatabaseConnectionType enum no longer includes PGLITE variant
- DatabaseProvider no longer has a PGlite initialization branch — only supports POSTGRES (local) and RDS (AWS Secrets Manager)
- All PGlite references must be cleaned up when merging main into feature branches:
  - database-provider.ts: Remove PGliteDriver import, PGLiteSettings type, PGlite init block, PGlite JSDoc refs
  - config.test.ts: Change  defaults to 
  - Example/project files: Remove "pglite" from database type unions
  - dist/database-settings.d.ts: PGLITE enum value will be gone from main
- ADR 0017 and 0019 document the original PGlite adoption and migration rationale

### Update: 2026-07-20

## Content Correction (2026-07-20)

The following lines had backtick-quoted text stripped during initial creation. Corrected content:

- Dependencies removed: @electric-sql/pglite, typeorm-pglite
- config.test.ts: Change type: "pglite" defaults to type: "postgres"
- Example/project files: Remove "pglite" from database type unions
- dist/database-settings.d.ts: PGLITE enum value will be gone from main

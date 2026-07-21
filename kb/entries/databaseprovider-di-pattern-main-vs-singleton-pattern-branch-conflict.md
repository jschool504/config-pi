---
title: "DatabaseProvider DI pattern (main) vs singleton pattern (branch) conflict"
tags: [database,database-provider,merge-conflict,di-pattern,singleton,build-error]
created: 2026-07-20
hits: 0
---
- Main branch uses public constructor + `withSettings(settings: Settings)` DI pattern. Core's factory `databaseProvider` in core/src/providers/database-provider.ts does: `new DatabaseProvider().withSettings(ctx.settings)`.\n- Branch fix/rds-secret-refresh-in-place originally used a private constructor + singleton `getInstance()` pattern, causing TS2673 build error in core package.\n- Resolution: Removed `private static instance` and `getInstance()`, made constructor public, added `withSettings()` method, replaced internal `new Settings()` with injected `this.settings`, added null checks in `initialize()` and `refresh()`.\n- Tests updated: replaced `DatabaseProvider.getInstance()` with `new DatabaseProvider()` + `provider.withSettings(new Settings())` in beforeEach.\n- Lesson: When merging main into a feature branch, check how the core package instantiates shared services — singleton patterns on branches that diverge from main's DI approach will cause build failures downstream.

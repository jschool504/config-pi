---
title: "Test Mocking — Settings.prototype.get Best Practices"
tags: [test-mocking,jest,mock-patterns,settings,prototype-pollution]
created: 2026-07-20
hits: 0
---
## Safe Mock Pattern

When mocking `Settings.prototype.get` (from `lib/config`), use a static top-level import and `jest.spyOn(Settings.prototype, "get").mockReturnValue(...)`.

**DO NOT** use dynamic `await import("lib/config")` + direct assignment to `Settings.prototype.get`. Direct assignment is unsafe — if an assertion fails between mock and manual restore, prototype pollution leaks to all subsequent tests.

Always pair `jest.spyOn` with `afterEach(() => jest.restoreAllMocks())` to guarantee cleanup.

**Example:** `database/src/providers/__tests__/database-provider.test.ts`

## Caution

The editor agent previously accidentally wiped this test file (replaced with `export const fx = 1;`). Had to restore via `git checkout HEAD`. Be careful when editing test files with dynamic imports.

---
title: "Test Mocking — Settings.prototype.get Best Practices"
tags: [test-mocking,jest,mock-patterns,settings,prototype-pollution]
created: 2026-07-20
hits: 0
---
## Safe Mock Pattern\n\nWhen mocking  (from ), use a static top-level import and .\n\n**DO NOT** use dynamic  + direct assignment to . Direct assignment is unsafe — if an assertion fails between mock and manual restore, prototype pollution leaks to all subsequent tests.\n\nAlways pair  with  to guarantee cleanup.\n\n**Example:** \n\n## Caution\n\nThe editor agent previously accidentally wiped this test file (replaced with ). Had to restore via Your branch is up to date with 'origin/main'.. Be careful when editing test files with dynamic imports.

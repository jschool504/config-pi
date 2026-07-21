---
title: "tsconfig-paths-mask-exports-enforcement"
tags: [typescript,moduleResolution,tsconfig,package.json,exports]
created: 2026-07-21
hits: 0
---
moduleResolution bundler enforces package.json exports BUT tsconfig paths aliases short-circuit resolution before exports is checked. Pattern 'database/*: ../database/dist/*' hides ERR_PACKAGE_PATH_NOT_EXPORTED at compile time. Best fix: drop dist/* aliases, let workspace symlinks + exports maps handle resolution. CI gate option: tsconfig.exports-check.json with empty paths, run tsc --noEmit. nodenext is NOT the fix - requires matching module nodenext (forces .js extensions) and paths still mask exports under nodenext.

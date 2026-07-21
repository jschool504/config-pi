---
title: "err-package-path-not-exported"
tags: [consumer,esm,package-exports,monorepo]
created: 2026-07-21
hits: 0
---
Consumer imported 'database/providers/database-provider' but database/package.json only exported root '.'. Node ESM threw ERR_PACKAGE_PATH_NOT_EXPORTED at runtime. tsc compiled fine because paths aliases short-circuited exports checking. Fix: added explicit ./providers/database-provider export entry. PR #77, v0.2.4. Lesson: declare all subpath exports in package.json for ESM monorepos.

---
title: "isConnectionError() — Connection Error Detection"
tags: [database,connection-errors,connection,pool-refresh,debugging]
created: 2026-07-20
hits: 0
---
isConnectionError() in database/src/utils/connection-errors.ts detects transient DB/network connection failures to trigger automatic pool refresh.

DETECTED patterns:
- Message patterns: ECONNREFUSED, ECONNRESET, ETIMEDOUT, "Connection lost", "cannot connect", etc.
- PostgreSQL error codes: 57P01, 08006, 08003, 08000, 28P01, 28000

EXCLUDED patterns (explicitly returns false):
- AWS SDK exceptions like ThrottlingException and AccessDeniedException. These are unrelated to DB connections and would trigger unnecessary pool destroy/reconnect on AWS API failures.

This was a bug caught by GitHub Copilot PR review on PR #73.

Test file: database/src/utils/__tests__/connection-errors.test.ts explicitly asserts isConnectionError(ThrottlingException) returns false.

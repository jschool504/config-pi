---
title: "DatabaseProvider refresh() mutex pattern"
tags: [database,database-provider,bug-fix,mutex,refresh]
created: 2026-07-20
hits: 1
---
The DatabaseProvider.refresh() method uses a coalescing mutex pattern via  to prevent concurrent refresh storms.

**BUG**: The original implementation assigned a new promise to  but never reset it to null after completion. This meant the coalescing guard always short-circuited after the first refresh — making subsequent calls no-ops.

**FIX**: Added  inside the IIFE so the guard releases after each refresh cycle.

**File**: 
**Related PR**: #73 

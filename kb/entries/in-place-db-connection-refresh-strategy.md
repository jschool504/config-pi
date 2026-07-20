---
title: "In-place DB connection refresh strategy"
tags: [database,database-provider,pool-refresh,rds,credentials]
created: 2026-07-20
hits: 0
---
DatabaseProvider.refresh() performs an in-place pool refresh to handle RDS credential rotation without requiring an application restart.

**Strategy**: Destroy pool → re-resolve credentials from AWS Secrets Manager → dataSource.setOptions() to update username/password in-place → dataSource.initialize().

**KEY DESIGN**: Reuses the same DataSource instance. All Repository<T> references stay valid because the DataSource object identity never changes. No constructor changes needed anywhere in the codebase.

**RDS-only behavior**: Only RDS connections re-resolve credentials from Secrets Manager. POSTGRES and PGLITE connection types simply reconnect since their credentials do not rotate.

**setOptions() cast pattern**: Uses  intermediate cast (never ) because TypeORM's Partial<DataSourceOptions> union type makes it impossible to directly access driver-specific fields.

**File**: database/src/providers/database-provider.ts

**Related**: DatabaseProvider refresh() mutex pattern (kb: databaseprovider-refresh-mutex-pattern)

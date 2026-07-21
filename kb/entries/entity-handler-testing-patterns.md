---
title: "Entity handler testing patterns"
tags: [testing,xunit,moq,entity-handler,in-memory-db,request-context]
created: 2026-07-20
hits: 0
---
Testing patterns for entity handlers in shared.tests/:

- Use xUnit with Moq. PatientTrigger is always real instances (never mocked).
- Dependencies like ILogger and service interfaces are mocked.
- Test files follow namespace convention mirroring source (e.g., shared.tests.EventHandlers.PatientHandlers).
- For abstract classes like ISettings (shared/Settings.cs), pass constructor args to Mock<T>: new Mock<ISettings>(factory1, factory2, memoryCache, options).
- EF Core contexts (NewtonContext) CANNOT be mocked with Castle DynamicProxy — use real instances with in-memory DB: new DbContextOptionsBuilder<NewtonContext>().UseInMemoryDatabase(name).Options.
- RequestContext requires RequestStart property when instantiated: new RequestContext { RequestStart = DateTimeOffset.UtcNow }.
- Use unique in-memory DB names per test run (Guid.NewGuid() suffix) to prevent state leakage.

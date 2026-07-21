---
title: "Stale AWS Secrets Manager Cache Bug"
tags: [aws-secrets-manager,cache,stale,secret-rotation,service-restart,sonnet,haiku]
created: 2026-07-21
hits: 0
---
## Problem

The Sonnet model appeared in production despite Haiku being configured in the overlay secret. The root cause was a cached/stale version of the overlay secret in AWS Secrets Manager.

## Resolution

A service restart flushed the cache and the correct Haiku model was loaded.

## Key Takeaway

Overlay secret changes in AWS Secrets Manager may require a service restart (or a manual cache flush) before taking effect. Always verify the deployed configuration after changing overlay secrets in production.

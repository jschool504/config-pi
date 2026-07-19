---
title: "KB Auto-Commit Decision"
tags: [pi,knowledge-base,git,scripts]
created: 2026-07-19
hits: 0
---
kb-add.sh and kb-get.sh automatically run git add/commit/push after every operation. This keeps LLMs (memory agent) free of version control logic and ensures KB state is always synced across machines.

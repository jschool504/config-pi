---
title: "Pi Agent Config Repo Structure"
tags: [pi,git,config,setup]
created: 2026-07-19
hits: 1
---
Track pi config in git. Exclude auth.json (API keys), sessions/ (chat logs), bin/ (machine binaries), npm/node_modules. Use .gitignore at root. Sync across machines via git clone.

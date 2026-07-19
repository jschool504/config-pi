---
title: "KB Search-and-Merge Architecture"
tags: [pi,knowledge-base,scripts,architecture]
created: 2026-07-19
hits: 0
---
Prevents KB fragmentation. Memory agent uses kb-append.sh to find related entries via kb-search.sh before creating new ones. kb-append.sh updates the updated date and appends new content under a date-stamped header in the existing markdown file.

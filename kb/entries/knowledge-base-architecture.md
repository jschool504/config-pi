---
title: "Knowledge Base Architecture"
tags: [pi,knowledge-base,scripts,shell]
created: 2026-07-19
hits: 1
---
Flat structure in kb/entries/ with YAML frontmatter: title, tags, created, hits. Scripts: kb-add.sh (title, tags, content -> slug.md), kb-search.sh (weighted scoring: tags 3x, title 2x, content 1x + hits), kb-get.sh (increment hits, print content). Memory agent wraps scripts. Entries are git-tracked for cross-machine sync.

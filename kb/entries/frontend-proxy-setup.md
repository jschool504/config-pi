---
title: "Frontend Proxy Setup"
tags: [prototype-web-builder,frontend,backend,rust,static-files,build]
created: 2026-07-21
hits: 0
---
Backend serves the React frontend as static files using Poem's  mounted at root . The frontend is built via  and must be rebuilt for any frontend changes to be reflected. Backend does not watch for frontend changes — developers must manually rebuild after frontend modifications.

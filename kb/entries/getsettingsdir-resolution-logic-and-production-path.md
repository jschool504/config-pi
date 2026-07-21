---
title: "getSettingsDir resolution logic and production path"
tags: [settings,environment-variables,production,ecs,configuration,directory-resolution]
created: 2026-07-21
updated: 2026-07-21
hits: 1
---
The Settings service uses  to locate the  directory at startup.

**Resolution logic** (checked in priority order):
1.  env var — if set, use it directly.
2. Climb parent directories from cwd upward, checking for a  folder at: cwd, cwd/.., cwd/../.., etc. (up to root).

**Production path (ECS)**:
- The container working directory is  (set via  in ).
- Settings reside at  (one level up).
- The climb finds  because it exists one parent directory above .
- No volume mounts are used — the  directory is baked into the Docker image during build.

**Docker build context**:
-  copies everything into the image.
-  is excluded via  (it contains local/dev secrets).
- Production settings (e.g., ) are committed and baked in.

**Local development**:
- CWD is typically the repo root or  directory.
-  can override for custom layouts (e.g., pointing to a project-specific settings dir).

Key takeaway:  is intentionally flexible to support both local monorepo layouts and containerized production deployments without configuration changes.

### Update: 2026-07-21

## Corrections (backticks stripped by shell in initial entry)

The Settings service uses `getSettingsDir()` to locate the `settings/` directory at startup.

**Resolution logic** (checked in priority order):
1. `CRE_SETTINGS_DIR` env var -- if set, use it directly.
2. Climb parent directories from cwd upward, checking for a `settings/` folder at: cwd, cwd/.., cwd/../.., etc. (up to root).

**Production path (ECS)**:
- The container working directory is `/app/api` (set via `npm --prefix /app/api start` in `docker-compose.yml`).
- Settings reside at `/app/settings/` (one level up).
- The climb finds `/app/settings` because it exists one parent directory above `/app/api`.
- No volume mounts are used -- the `settings/` directory is baked into the Docker image during build.

**Docker build context**:
- `COPY . .` copies everything into the image.
- `local.json` is excluded via `.dockerignore` (it contains local/dev secrets).
- Production settings (e.g., `production.json`) are committed and baked in.

**Local development**:
- CWD is typically the repo root or `api/` directory.
- `CRE_SETTINGS_DIR` can override for custom layouts.

Key takeaway: `getSettingsDir()` is intentionally flexible to support both local monorepo layouts and containerized production deployments without configuration changes.

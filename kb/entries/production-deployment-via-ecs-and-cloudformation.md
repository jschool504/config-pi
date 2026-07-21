---
title: "Production deployment via ECS and CloudFormation"
tags: [deployment,ecs,cloudformation,production,aws,docker]
created: 2026-07-21
updated: 2026-07-21
hits: 1
---
Production CRE is deployed to AWS ECS using CloudFormation templates located in .

**Deployment characteristics**:
- No volume mounts for settings — the  directory is baked into the Docker image at build time.
-  is set to  in the container environment.
-  is passed as a CloudFormation template parameter (controls color theme in frontend).
- ECS task runs the  command from  (Fastify API + static frontend server).

**Secrets management**:
- The overlay secret name defaults to  (AWS Secrets Manager).
- Overridable via  environment variable.
- The overlay system merges secret values on top of baked-in settings at runtime.

**Image build**:
- Single multi-stage Dockerfile builds all monorepo packages: lib → database → core → consumer → api.
-  copies build artifacts into the runtime image.
-  excluded via .

**Key files**:
- CloudFormation templates: 
- Docker entrypoints configured via  command overrides.
- Settings hierarchy resolved at runtime via  climbing from  to .

Lesson: Production deployment is fully self-contained in the image — no external config mounts needed. The overlay secret provides a way to inject per-environment overrides without rebuilding.

### Update: 2026-07-21

## Corrections (backticks stripped by shell in initial entry)

Production CRE is deployed to AWS ECS using CloudFormation templates located in `cloudformation/production/`.

**Deployment characteristics**:
- No volume mounts for settings -- the `settings/` directory is baked into the Docker image at build time.
- `NODE_ENV` is set to `"production"` in the container environment.
- `STACK_COLOR` is passed as a CloudFormation template parameter (controls color theme in frontend).
- ECS task runs the `app` command from `docker-compose.yml` (Fastify API + static frontend server).

**Secrets management**:
- The overlay secret name defaults to `cre/production/settings` (AWS Secrets Manager).
- Overridable via `CRE_SECRETS_NAME` environment variable.
- The overlay system merges secret values on top of baked-in settings at runtime.

**Image build**:
- Single multi-stage Dockerfile builds all monorepo packages: lib → database → core → consumer → api.
- `COPY . .` copies build artifacts into the runtime image.
- `local.json` excluded via `.dockerignore`.

**Key files**:
- CloudFormation templates: `cloudformation/production/`
- Docker entrypoints configured via `docker-compose.yml` command overrides.
- Settings hierarchy resolved at runtime via `getSettingsDir()` climbing from `/app/api` to `/app/settings/`.

Lesson: Production deployment is fully self-contained in the image -- no external config mounts needed. The overlay secret provides a way to inject per-environment overrides without rebuilding.

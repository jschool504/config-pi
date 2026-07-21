---
title: "Pi Agent Roles and Tool Constraints"
tags: [pi,subagents,tools,architecture]
created: 2026-07-19
updated: 2026-07-21hits: 3
---
Editor: strictly file editing (read, edit, write), no bash. Shell: interprets natural language into bash commands, reports output, no file edits. Explorer: read-only codebase search (read, grep, find, ls). Expert: completely toolless architectural planning with rejection loop. Memory: KB manager via bash scripts.

### Update: 2026-07-21

## Editor File Write Bug & Fix

**Problem:** The Editor subagent (Qwen 35B) sometimes *hallucinates* file writes — it reports success in its turn but the changes are never actually persisted to disk. This is a known issue where the editor's internal file editing can fail silently or the agent lies about success.

**Fix:** Route ALL file modifications (cat >, sed, touch, rm, etc.) through the **Shell** agent instead of the Editor. The Shell agent executes real bash commands and reliably writes to the filesystem.

**Rule:** Never trust the Editor subagent for file creation or modification. Use it only for reading, explaining, and planning. For any write operation, delegate to the Shell agent.

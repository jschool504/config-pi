---
description: Spin up a single subagent to execute an isolated task from the breakdown
argument-hint: "<task-title-or-number>"
---
Locate task $ARGUMENTS from our previous breakdown. 

You are responsible for spawning a single subagent to execute this task. Before launching it, compile a hyper-focused payload for the subagent containing:
1. **Target Files:** Path to the exact files to create or modify.
2. **Context:** Only the minimum necessary details or type definitions needed to complete the objective.
3. **Objective:** What code to write.
4. **Verification:** The exact test command or script to run.

Instruct the subagent to perform the work, run the verification, and report back with a 1-sentence confirmation of success. Do not pass the entire conversation history to the subagent.
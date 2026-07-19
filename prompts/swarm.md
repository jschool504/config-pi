---
description: Have the main agent dispatch multiple parallel subagents to distinct files
argument-hint: "<task-numbers-to-run-in-parallel>"
---
Analyze the tasks matching $ARGUMENTS from our breakdown. 

You (the main agent) will act as the orchestrator to spin up a parallel swarm of subagents according to these rules:
1. **Conflict Check:** Verify that no two tasks target or modify the same file. If there is an overlap, call it out and refuse to run them in parallel.
2. **Launch:** Spawn an independent subagent for each task concurrently. 
3. **Payload:** Provide each subagent with its specific file path, objective, and isolated verification test.
4. **Collate:** Wait for all parallel processes to finish. Collate their verification results and output a clean status report showing which tasks succeeded or if any subagent failed its test.

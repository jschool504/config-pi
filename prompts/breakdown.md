---
description: Deconstruct a feature or goal into isolated execution tasks
argument-hint: "[specific-feature-or-scope]"
---

Deconstruct the requested work ${1:-"discussed above"} into a highly modular execution plan.

Analyze the objective and provide an isolated task list following these strict constraints:
1. **Decoupled Tasks:** Divide the work into independent, bite-sized tasks. Completing step 3 should not require guesswork from step 2.
2. **File Scope:** Specify exactly which files, components, or modules are affected by each step.
3. **Verification Criterion:** For every single task, include a 1-sentence testing step so I can verify it works before moving to the next.

Output format:
### 📋 Implementation Breakdown

#### [ ] Task N: [Concise Title]
* **Files:** `path/to/file`
* **Objective:** Clear, technical description of what to code.
* **Verify:** How to test or run this specific piece in isolation.

Keep your response completely factual, free of fluff, and ready for step-by-step execution.
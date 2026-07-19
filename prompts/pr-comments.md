---
description: Retrieve and organize GitHub PR comments with code context
argument-hint: "[PR-number-or-URL]"
---

Fetch and display all active review comments on the GitHub Pull Request specified by the argument, or the current branch's PR if no argument is provided.

Target PR: ${1:-"current branch"}

Execute the necessary GitHub CLI (`gh`) commands to pull the data and organize your output file-by-file matching this exact format:

### 📄 File: [path/to/file]
**Line [Number]:** [Author Username]: "[Comment text content]"


[2-3 lines of code before the comment for context]

[The exact line of code the comment was left on]


CRITICAL INSTRUCTIONS:
1. Use the GitHub CLI (`gh`) to pull the PR context dynamically. If an argument is provided (URL or number), target that specific PR. Otherwise, pull for the current branch.
2. For each comment, ensure you display 2-3 lines of code *before* the target line to provide structural context for the review.
3. Clearly mark the line receiving the comment with a '>>' visual indicator.
4. If there are no open comments or review items, output exactly: "No active PR comments found."
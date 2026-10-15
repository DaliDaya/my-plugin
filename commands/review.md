---
description: Review a file, directory, or the current changes for bugs and clarity
argument-hint: [path or focus]
allowed-tools: Read, Grep, Glob, Bash(git diff:*), Bash(git status:*)
---

Review the following target: $ARGUMENTS

If no target is given, review the uncommitted changes shown by `git diff` and `git status`.

Check for:
1. Correctness bugs and unhandled edge cases.
2. Error handling gaps.
3. Unclear naming or logic that needs a comment.
4. Missing or weak tests.

Report one finding per line in this format:
`path:line: severity: problem. suggested fix.`

Use severity `high`, `medium`, or `low`. Skip style nits that do not change meaning. Do not edit any files. If nothing is wrong, say so.

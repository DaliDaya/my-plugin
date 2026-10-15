---
name: changelog-entry
description: Draft Keep a Changelog entries from git history and add them under [Unreleased] in CHANGELOG.md. Use when the user asks to update the changelog, write release notes, or prepare a release.
allowed-tools: Read, Edit, Bash(git describe:*), Bash(git log:*), Bash(git status:*)
---

# Changelog entry

Draft changelog entries for commits that are not yet in `CHANGELOG.md`, and add them under `## [Unreleased]`.

## Steps

1. Find the last release tag: `git describe --tags --abbrev=0`. If there is no tag, use the full history.
2. List commits since that tag: `git log --no-merges --format='%s' <tag>..HEAD`.
3. Read `CHANGELOG.md`. Skip any change that `[Unreleased]` already describes.
4. Group the remaining commits under Keep a Changelog headings:
   - `feat` becomes **Added**.
   - `fix` becomes **Fixed**.
   - A change to existing behavior becomes **Changed**.
   - A removal becomes **Removed**.
   - A vulnerability fix becomes **Security**.
5. Rewrite each commit as one user-facing sentence in the past or present tense. Match the style of the existing entries.
6. Edit `CHANGELOG.md`. Insert the entries under `## [Unreleased]`, creating each `### Heading` only when it has entries. Keep the order Added, Changed, Deprecated, Removed, Fixed, Security.
7. Show the user the result and name any commit you left out.

## Rules

- Strip pull request numbers such as `(#12)` and commit hashes from the text.
- Leave out commits with no effect on users of the plugin, such as a typo fix in a code comment or a test-only refactor. Include docs, CI, and tooling changes only when a contributor or user would care.
- Merge several commits about the same change into one entry.
- Never create a version heading and never change the `version` in `.claude-plugin/plugin.json`. Releasing is a separate step.
- If there are no new changes, say so and edit nothing.
- Do not commit. Leave the edit for the user to review.

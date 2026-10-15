---
name: branche
description: Release branch and PR workflow for this plugin. Creates a release branch, bumps the version, turns [Unreleased] into a dated changelog entry, opens a release PR, and after approval merges it and pushes the version tag. Use when the user asks to cut, prepare, or publish a release.
disable-model-invocation: true
allowed-tools: Read, Edit, Bash(git status *), Bash(git switch *), Bash(git pull *), Bash(git tag -l *), Bash(git add *), Bash(git commit *), Bash(git push origin release-*), Bash(gh pr create *), Bash(gh pr checks *), Bash(gh pr list *), Bash(gh run list *), Bash(gh release view *)
---

# Branche

Cut a release of this plugin: a release branch, a release PR, then the merge and the version tag.

`allowed-tools` leaves out `gh pr merge` and `git push` of a tag on purpose. Claude Code asks you to approve those two actions, so the merge and the tag need your confirmation in the harness, not only in this text. The release workflow in `.github/workflows/release.yml` publishes the GitHub release when a `v*` tag is pushed. It fails when the tag does not match `version` in `.claude-plugin/plugin.json`, or when `CHANGELOG.md` has no entry for that version.

`main` is protected, so every change goes through a pull request with the three CI checks passing.

## Inputs

The user gives a version such as `0.6.0`, or `major`, `minor`, or `patch`. If they give neither, read `[Unreleased]` and propose a bump, then ask:

- Removed or incompatible behavior: major (while below 1.0.0, a minor bump).
- New skill, agent, command, hook, or MCP server: minor.
- Fixes and docs only: patch.

## Preflight

Stop and report if any check fails.

1. `git status --short` is empty, and the current branch is `main`.
2. `git pull` leaves `main` level with `origin/main`.
3. The new version is greater than `version` in `.claude-plugin/plugin.json`, and tag `v<version>` does not exist (`git tag -l`).
4. `[Unreleased]` in `CHANGELOG.md` has at least one entry. If it is empty, offer to run the `changelog-entry` skill first.
5. `gh pr list --state open` shows no pull request that should ship first. Ask the user if there is one.

## Prepare the release

1. Create a branch: `git switch -c release-<version>`.
2. Set `version` in `.claude-plugin/plugin.json`.
3. In `CHANGELOG.md`, leave an empty `## [Unreleased]` heading and insert `## [<version>] - <today's date, YYYY-MM-DD>` under it, moving the existing entries beneath the new heading. Merge duplicate `### Added`, `### Changed`, and similar headings into one each, in the order Added, Changed, Deprecated, Removed, Fixed, Security.
4. Commit as `chore: release <version>`, push the branch, and open a pull request with `gh pr create --base main`.
5. Wait about 15 seconds for the checks to register, then run `gh pr checks <number> --watch --fail-fast`. Right after `gh pr create` the command can fail with "no checks reported"; wait and run it again.
6. If a check fails, report the failing job and stop.

## Publish

Merging and tagging are public and hard to undo. Show the user the changelog entry and the PR link, and get an explicit yes before this section.

1. Squash-merge: `gh pr merge <number> --squash --delete-branch`.
2. `git switch main`, then `git pull`.
3. Confirm `version` in `.claude-plugin/plugin.json` equals the new version.
4. Tag and push: `git tag -a v<version> -m "v<version>"`, then `git push origin v<version>`.
5. Wait for the release run (`gh run list --limit 3`), then check the result with `gh release view v<version>`. Confirm it is not a draft and that the notes match the changelog entry.

## Abandoning a release

If a check fails and the user decides not to continue, close the PR with `gh pr close <number> --delete-branch` (ask first), then `git switch main` and delete the local branch with `git branch -D release-<version>`. No tag exists at that point, so nothing else needs cleanup. If the tag was already pushed, follow the Report section instead.

## Report

Give the release URL, the PR number, and the result of the CI run on `main`. If the release workflow failed, show the failing step and do not retry the tag. Never delete or move a pushed tag without the user's explicit instruction.

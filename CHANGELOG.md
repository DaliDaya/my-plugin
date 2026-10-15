# Changelog

All notable changes to this plugin are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- `tests/test-block-dangerous-bash.sh` covering allowed and blocked Bash commands for the hook.
- GitHub Actions workflow `.github/workflows/test.yml` that runs the hook tests on Ubuntu and Windows and validates the plugin JSON files.

## [0.1.0] - 2026-10-15

### Added

- Plugin manifest at `.claude-plugin/plugin.json`.
- `hello` skill that confirms the plugin is loaded.
- `helper` read-only subagent (`Read`, `Grep`, `Glob`).
- `/review` command that reviews a path or the uncommitted changes and reports findings one per line.
- `SessionStart` hook that prints `my-plugin loaded`.
- `PreToolUse` hook on `Bash` that blocks destructive commands (`rm -rf` on root or home, force push, `git reset --hard`, `git clean -f`, `DROP TABLE`/`DROP DATABASE`, `mkfs`, `dd if=`).
- Bundled `context7` MCP server in `.mcp.json`.
- `README.md`, `CLAUDE.md`, `LICENSE` (MIT), and `.gitignore`.

# Changelog

All notable changes to this plugin are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.4.0] - 2026-10-15

### Added

- `changelog-entry` skill that drafts changelog entries from git history under `[Unreleased]`.

## [0.3.0] - 2026-10-15

### Added

- `docs/` folder with an index and a hooks reference.
- CI status badge in `README.md`.

## [0.2.0] - 2026-10-15

### Added

- `CONTRIBUTING.md`, `SECURITY.md`, and `.github/CODEOWNERS`.
- Issue templates (bug report, feature request) and a pull request template.
- Dependabot config that checks GitHub Actions weekly.
- Release workflow `.github/workflows/release.yml` that publishes a GitHub release from `CHANGELOG.md` when a `v*` tag is pushed.

### Changed

- Copyright holder and plugin author set to `DaliDaya`.
- CI uses `actions/checkout@v7`.
- `main` is protected: the three CI checks are required, and force pushes and deletion are blocked.

## [0.1.0] - 2026-10-15

### Added

- Plugin manifest at `.claude-plugin/plugin.json`.
- `hello` skill that confirms the plugin is loaded.
- `helper` read-only subagent (`Read`, `Grep`, `Glob`).
- `/review` command that reviews a path or the uncommitted changes and reports findings one per line.
- `SessionStart` hook that prints `my-plugin loaded`.
- `PreToolUse` hook on `Bash` that blocks destructive commands (`rm -rf` on root or home, force push, `git reset --hard`, `git clean -f`, `DROP TABLE`/`DROP DATABASE`, `mkfs`, `dd if=`).
- Bundled `context7` MCP server in `.mcp.json`.
- `tests/test-block-dangerous-bash.sh` covering allowed and blocked Bash commands for the hook.
- GitHub Actions workflow `.github/workflows/test.yml` that runs the hook tests on Ubuntu and Windows and validates the plugin JSON files.
- `README.md`, `CLAUDE.md`, `LICENSE` (MIT), `.gitignore`, and `.gitattributes` (LF endings for shell scripts).

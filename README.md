# my-plugin

[![test](https://github.com/DaliDaya/my-plugin/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/DaliDaya/my-plugin/actions/workflows/test.yml)

An example Claude Code plugin with one skill, one subagent, and a hook that blocks destructive shell commands.

## Layout

```
my-plugin/
├── .claude-plugin/plugin.json      # plugin manifest
├── skills/hello/SKILL.md           # "hello" skill
├── agents/helper.md                # read-only "helper" subagent
├── commands/review.md              # /review slash command
├── docs/                           # extra documentation
├── hooks/hooks.json                # hook registration
├── .mcp.json                       # bundled MCP servers
├── tests/test-block-dangerous-bash.sh  # hook tests
├── .github/workflows/test.yml      # CI: hook tests and JSON validation
└── scripts/block-dangerous-bash.sh # PreToolUse hook script
```

## Usage

Load the plugin for a single session:

```
claude --plugin-dir ./my-plugin
```

Then verify it loaded:

- `/skills` lists `hello`.
- `/agents` lists `helper`.
- `/hooks` lists the `SessionStart` and `PreToolUse` hooks.

## Components

### Skill: `hello`

Greets the user and confirms the plugin is loaded. Claude invokes it when asked to test the plugin.

### Skill: `changelog-entry`

Drafts Keep a Changelog entries from the commits since the last release tag and adds them under `[Unreleased]` in `CHANGELOG.md`. Claude invokes it when you ask to update the changelog or prepare release notes. It edits the file but never commits or bumps the version.

### Skill: `branche`

Prepares and publishes a release. It bumps `version` in `plugin.json`, turns `[Unreleased]` into a dated changelog entry, and opens a release PR. After you approve, it squash-merges the PR, pushes the `v*` tag, and checks that the release workflow published the release. It runs only when you invoke it (`disable-model-invocation`), and it asks before merging or tagging.

### Agent: `helper`

A read-only subagent restricted to `Read`, `Grep`, and `Glob`. It answers lookup questions with file paths and line numbers and never edits files.

### Command: `/review`

Reviews a path or focus given as an argument, or the uncommitted changes when no argument is given. It is read-only and reports one finding per line as `path:line: severity: problem. suggested fix.` The command may appear as `/my-plugin:review`.

### MCP server: `context7`

`.mcp.json` bundles the Context7 documentation server over HTTP (`https://mcp.context7.com/mcp`). It starts when the plugin loads. Replace or extend the `mcpServers` entries to bundle other servers. If you already configure `context7` elsewhere, remove it here to avoid a duplicate.

### Hooks

- **SessionStart**: prints `my-plugin loaded`. Placeholder; replace with real setup.
- **PreToolUse (Bash)**: runs `scripts/block-dangerous-bash.sh`. The script reads the tool call JSON from stdin and exits with code 2 to block the call when the command matches one of these patterns:
  - `rm -rf` on `/`, `~`, or `$HOME`
  - `git push --force` or `-f`
  - `git reset --hard`
  - `git clean -f`
  - `DROP TABLE` or `DROP DATABASE`
  - `mkfs`
  - `dd if=`

## Limitations

- The blocklist matches raw text, so it can false-positive on a command that only mentions a pattern, such as inside a commit message.
- It is a guardrail, not a security boundary.
- It requires `bash` on `PATH`. On Windows, Git Bash provides it.

## Contributing

See `CONTRIBUTING.md`.

## License

MIT. See `LICENSE`.

## Customizing

- Edit the `patterns` array in `scripts/block-dangerous-bash.sh` to change what is blocked.
- Reference files inside the plugin from hook commands with `${CLAUDE_PLUGIN_ROOT}`.
- Set `author` and `version` in `.claude-plugin/plugin.json`.

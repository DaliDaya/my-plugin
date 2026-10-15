# Contributing

Thanks for helping improve my-plugin. This guide covers how to set up, test, and submit a change.

## Getting started

1. Fork the repository and clone your fork.
2. Load the plugin in Claude Code from the parent directory of the clone:

   ```
   claude --plugin-dir ./my-plugin
   ```

3. Confirm it loaded: `/skills` lists `hello`, `/agents` lists `helper`, `/hooks` lists the hooks.

## Making a change

1. Create a branch from `main`.
2. Make your change. See `CLAUDE.md` for the layout and conventions.
3. Run the tests:

   ```
   bash tests/test-block-dangerous-bash.sh
   ```

   `bash` is required. On Windows, Git Bash works.
4. Update the docs:
   - Add an entry under `[Unreleased]` in `CHANGELOG.md`.
   - Update the layout and component sections in `README.md` if you added or removed a component.
5. Open a pull request and fill in the template.

## Changing the Bash blocklist

Patterns live in the `patterns` array in `scripts/block-dangerous-bash.sh`.

- Add at least one blocked case and one allowed near-miss case to `tests/test-block-dangerous-bash.sh`.
- Do not add a `jq` dependency. The script matches raw JSON with `grep -E`.
- A blocking hook exits with code 2 and writes the reason to stderr.
- The blocklist is a guardrail, not a security boundary. Do not describe it as one.

## Other conventions

- Hook commands must work from Git Bash on Windows and from a POSIX shell.
- Keep `/review` read-only. Do not add edit tools to its `allowed-tools`.
- Never put secrets in `.mcp.json`. Use `${ENV_VAR}` expansion.
- Shell scripts use LF line endings. `.gitattributes` enforces this.

## Continuous integration

Every pull request runs the hook tests on Ubuntu and Windows and validates `plugin.json`, `hooks.json`, and `.mcp.json`. A pull request needs a green run to merge.

## Reporting bugs and requesting features

Use the issue templates. Include the output of `claude -v` and your operating system.

## License

By contributing, you agree that your contributions are licensed under the MIT License in `LICENSE`.

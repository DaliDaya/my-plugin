# Hooks

The plugin registers two hooks in `hooks/hooks.json`.

| Event | Matcher | Command | Purpose |
| ----- | ------- | ------- | ------- |
| `SessionStart` | none | `echo my-plugin loaded` | Placeholder that confirms the plugin loaded. |
| `PreToolUse` | `Bash` | `scripts/block-dangerous-bash.sh` | Blocks destructive shell commands. |

## How the Bash hook works

Before Claude Code runs a Bash command, it sends the tool call as JSON on the script's stdin. The script matches that text against a list of regular expressions.

- No match: exit code `0`. The command runs.
- Match: exit code `2`. The command is blocked, and the message on stderr goes back to Claude, which should ask you to run the command yourself.

The script has no `jq` dependency. It matches the raw JSON with `grep -E`.

## What is blocked

| Pattern | Example |
| ------- | ------- |
| Recursive `rm` (`-r`, `-R`, `-rf`, `-r -f`, `--recursive`) on `/`, `/*`, `~`, `~/`, or `$HOME` | `rm -rf ~` |
| `git push` with `--force`, a short flag containing `f` (`-f`, `-fu`), or a `+refspec` | `git push --force origin main` |
| `git reset --hard` | `git reset --hard HEAD~1` |
| `git clean` with `-f` (any flags containing `f`) or `--force` | `git clean -fd` |
| `DROP TABLE` or `DROP DATABASE`, any case | `drop database prod;` |
| `mkfs` | `mkfs.ext4 /dev/sda1` |
| `dd` with `if=` or `of=`, in either order | `dd if=/dev/zero of=/dev/sda` |

Before matching, the script removes quotes and backslashes from the JSON, so `rm -rf "$HOME"` is caught.

These stay allowed: `git push --force-with-lease`, `git push --follow-tags`, `git reset --soft`, `git clean -n`, `rm -rf ./build`, `rm -rf /tmp/scratch`, and `rm -rf ~/projects/old`.

## Limitations

- The script matches raw text, so it can block a command that only mentions a pattern, such as a commit message containing `git reset --hard`.
- A command written in a way the patterns do not anticipate gets through. The blocklist is a guardrail, not a security boundary.
- It needs `bash` on `PATH`. On Windows, Git Bash provides it.

## Adding a pattern

1. Add a regular expression to the `patterns` array in `scripts/block-dangerous-bash.sh`. Use POSIX classes such as `[[:space:]]`, because the script uses `grep -E`.
2. Add a blocked case and an allowed near-miss case to `tests/test-block-dangerous-bash.sh`.
3. Run `bash tests/test-block-dangerous-bash.sh`. Exit code `0` means every case passed.
4. Add a line to the table above and an entry under `[Unreleased]` in `CHANGELOG.md`.

## Testing the hook by hand

```
printf '{"tool_input":{"command":"git reset --hard"}}' | bash scripts/block-dangerous-bash.sh; echo $?
```

Expect `2` for a blocked command and `0` for an allowed one.

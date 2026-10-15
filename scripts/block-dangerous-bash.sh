#!/usr/bin/env bash
# PreToolUse hook for Bash: block a small set of destructive commands.
# Claude Code passes the tool call as JSON on stdin. Exit code 2 blocks the
# call and sends stderr back to Claude. Exit code 0 allows it.
# No jq dependency: patterns are matched against the raw JSON text.

input="$(cat)"

patterns=(
  'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f?[[:space:]]+(/|~|\$HOME)([[:space:]"]|$)'
  'git[[:space:]]+push[[:space:]].*(--force|-f)([[:space:]"]|$)'
  'git[[:space:]]+reset[[:space:]]+--hard'
  'git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f'
  '[Dd][Rr][Oo][Pp][[:space:]]+([Tt][Aa][Bb][Ll][Ee]|[Dd][Aa][Tt][Aa][Bb][Aa][Ss][Ee])'
  'mkfs(\.|[[:space:]])'
  'dd[[:space:]]+if='
)

for p in "${patterns[@]}"; do
  if printf '%s' "$input" | grep -Eq "$p"; then
    echo "my-plugin: blocked potentially destructive command (matched: $p). Ask the user to confirm and run it manually." >&2
    exit 2
  fi
done

exit 0

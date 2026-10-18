#!/usr/bin/env bash
# PreToolUse hook for Bash: block a small set of destructive commands.
# Claude Code passes the tool call as JSON on stdin. Exit code 2 blocks the
# call and sends stderr back to Claude. Exit code 0 allows it.
# No jq dependency: patterns are matched against the raw JSON text.

# Normalize the JSON: turn escaped newlines and tabs into separators, then drop
# backslashes and quotes so that `rm -rf \"$HOME\"` reads as `rm -rf $HOME`.
input="$(cat | sed -e 's/\\n/;/g' -e 's/\\t/ /g' | tr -d "\\\\\"'")"

# `cmd` is a command word: start of text or a character that cannot be part of a name.
cmd='(^|[^[:alnum:]_./-])'
# `seg` is anything inside the same simple command (no ; & | separator).
seg='[^;&|]*'
# `end` closes a token: whitespace, a separator, the JSON closing brace, or end of text.
end='([[:space:]]|[;&|}]|$)'

patterns=(
  # rm with a recursive flag (-r, -R, -rf, --recursive) aimed at /, ~, or $HOME
  "${cmd}rm[[:space:]]+(-[^[:space:]]+[[:space:]]+)*(-[a-z]*r[a-z]*|--recursive)([[:space:]]+-[^[:space:]]+)*[[:space:]]+(/|~|\\\$HOME|\\\$\\{HOME\\})/?\\*?${end}"
  # git push with --force, a short flag containing f (-f, -fu), or a +refspec
  "${cmd}git${seg}[[:space:]]push([[:space:]]${seg})?[[:space:]](--force|-[a-z]*f[a-z]*|\\+[^[:space:]+-][^[:space:]]*)${end}"
  "${cmd}git${seg}[[:space:]]reset${seg}--hard"
  # git clean with -f/--force
  "${cmd}git${seg}[[:space:]]clean${seg}[[:space:]](-[a-z]*f[a-z]*|--force)${end}"
  'drop[[:space:]]+(table|database)'
  "${cmd}mkfs(\\.|[[:space:]])"
  # dd reading from or writing to anywhere
  "${cmd}dd[[:space:]]+(${seg}[[:space:]])?(if|of)="
)

for p in "${patterns[@]}"; do
  if printf '%s' "$input" | grep -Eiq -- "$p"; then
    echo "my-plugin: blocked potentially destructive command (matched: $p). Ask the user to confirm and run it manually." >&2
    exit 2
  fi
done

exit 0

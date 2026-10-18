#!/usr/bin/env bash
# Tests for scripts/block-dangerous-bash.sh.
# Usage: bash tests/test-block-dangerous-bash.sh
# Exits 0 when all cases pass, 1 otherwise.

set -u

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
hook="$root/scripts/block-dangerous-bash.sh"

pass=0
fail=0

# check <expected exit code> <command string>
check() {
  local expected="$1" cmd="$2" actual
  printf '{"tool_name":"Bash","tool_input":{"command":"%s"}}' "$cmd" \
    | bash "$hook" >/dev/null 2>&1
  actual=$?
  if [ "$actual" -eq "$expected" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    echo "FAIL: expected exit $expected, got $actual: $cmd"
  fi
}

# Allowed (exit 0)
check 0 'ls -la'
check 0 'git status'
check 0 'git push origin main'
check 0 'git push --force-with-lease origin main'
check 0 'git reset --soft HEAD~1'
check 0 'rm -rf ./build'
check 0 'rm -rf /tmp/scratch'
check 0 'echo hello'
check 0 'git push -u origin feature-fix'
check 0 'git push --follow-tags origin main'
check 0 'git clean -n'
check 0 'git add if=notes.txt'
check 0 'rm -r node_modules'
check 0 'rm -rf ~/projects/old'

# Blocked (exit 2)
check 2 'rm -rf /'
check 2 'rm -rf ~'
check 2 'rm -rf $HOME'
check 2 'git push --force origin main'
check 2 'git push origin main -f'
check 2 'git reset --hard HEAD~1'
check 2 'git clean -fd'
check 2 'DROP TABLE users;'
check 2 'drop database prod;'
check 2 'mkfs.ext4 /dev/sda1'
check 2 'dd if=/dev/zero of=/dev/sda'

# Blocked: forms that used to slip through
check 2 'rm -rf /*'
check 2 'rm -rf ~/'
check 2 'rm -r -f /'
check 2 'rm -Rf /'
check 2 'rm --recursive --force /'
check 2 'rm -rf \"$HOME\"'
check 2 'git push -fu origin main'
check 2 'git push origin +main'
check 2 'git -C repo push --force'
check 2 'git clean --force -d'
check 2 'dd of=/dev/sda if=/dev/zero'
check 2 'ls; rm -rf /'

echo "passed: $pass, failed: $fail"
[ "$fail" -eq 0 ]

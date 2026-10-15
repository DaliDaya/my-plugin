# Security Policy

## Supported versions

Only the latest release receives fixes.

| Version | Supported |
| ------- | --------- |
| 0.1.x   | Yes       |

## Reporting a vulnerability

Do not open a public issue for a security problem.

Report it privately through GitHub: go to the **Security** tab of this repository and choose **Report a vulnerability**. If that option is not available, email zoolakay3@gmail.com with the subject `my-plugin security`.

Include:

- A description of the problem and its impact.
- Steps to reproduce, or a proof of concept.
- The plugin version and your Claude Code version (`claude -v`).

You can expect an acknowledgement within 7 days. Fixes are released as a new patch version, and the report is credited in `CHANGELOG.md` unless you ask to stay anonymous.

## Scope

In scope:

- Code execution or data exposure caused by the hook script, the `/review` command, or the bundled MCP configuration.
- Secrets or credentials committed to the repository.

Out of scope:

- Commands that the Bash blocklist in `scripts/block-dangerous-bash.sh` does not catch. The blocklist is a guardrail, not a security boundary, and it matches raw text. Reports of new dangerous patterns are welcome as normal issues or pull requests.
- Vulnerabilities in Claude Code itself or in third-party MCP servers such as Context7. Report those to their maintainers.

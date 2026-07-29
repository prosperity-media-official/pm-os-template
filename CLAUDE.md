# Claude Code Workspace Instructions

Read and follow `AGENTS.md` as the canonical agency-wide workspace guide. Also follow the path-scoped rules in `.claude/rules/`.

Client work lives in separate sibling repositories, not in this one. Resolve a client's path before working on it — never guess or construct it:

```bash
python3 ../pm-skills/_shared/scripts/pm_paths.py resolve <slug>
```

Then read that repository's `AGENTS.md`. Its own `.claude/rules/` load automatically once you open a file inside it.

When working inside a team folder or a client repository, read that folder's `CLAUDE.md` and `AGENTS.md` if present. Keep those two files semantically aligned: `AGENTS.md` is the Codex entry point and `CLAUDE.md` is the Claude Code entry point.

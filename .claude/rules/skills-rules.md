---
paths:
  - "pm-skills/**"
  - ".claude/skills/**"
  - ".codex/skills/**"
---

# Skill-building rules

- Shared Prosperity skills belong in the separate `pm-skills` repository, not this workspace.
- Use self-contained agent specs under `<skill>/agents/` for complex parallel workflows.
- Put common toolchain documentation and utilities in `pm-skills/_shared/`.
- Keep `SKILL.md` focused and under 500 lines; extract detail to `references/`.
- Never hardcode client names, contacts, dashboards, credentials, or metric tables in a skill.
- Add a mechanical validator when a requirement can be checked reliably.

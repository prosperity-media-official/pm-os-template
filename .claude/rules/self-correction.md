---
paths:
  - "**/AGENTS.md"
  - "**/CLAUDE.md"
  - ".claude/rules/**"
---

# Self-correction doctrine

Treat the workspace instructions, scoped rules, skills, and validators as the harness around the model. When a real failure or correction occurs, work backward from the desired behavior and make the smallest durable harness improvement.

Prefer enforcement in this order:

1. Sensor: test, validator, schema, or workflow gate.
2. Guide: the most-local instruction, scoped rule, or skill specification.
3. Memory: context that is useful but not a behavioral rule.

Root instructions are a pilot checklist. Keep them lean, deduplicate before adding, move domain detail to scoped rules, and keep volatile project state out. Every rule should trace to a real failure or hard external constraint.

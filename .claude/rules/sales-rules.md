---
paths:
  - "team/sales/**"
---

# Sales rules

Pre-engagement emails, proposals, lead notes, and call preparation live in `team/sales/` and use a `YYYY-MM-DD-<lead>-<artifact>.md` filename.

Once a lead becomes a client, run `/pm-new-project` to create their dedicated client repository, then migrate relevant source material into it deliberately. Client work never lives in this workspace — `pm-os` keeps pointers only, in `.pm/clients.json`.

---
paths:
  - "knowledge/**"
  - "agency/research/**"
  - "clients/*/research/**"
  - "clients/*/strategy/**"
---

# Standard Frontmatter (Uniform Record Schema)

Every NEW knowledge/research/strategy document gets this frontmatter block. It is the uniform record schema the workspace indexer (`.claude/lib/pm_index.py`) and `pm_search.py` retrieval tools read — one uniform schema so every doc is machine-scannable (Cerebras knowledge-base pattern).

```yaml
---
description: One-line question this doc answers, phrased how someone would search for it
summary: 2–3 sentence distillation of the answer/resolution.
tags: [geo, compare-club]
sources: ["knowledge/raw/geo/2026-04-09-geo-case-studies-deep-dive.md"]
created: 2026-07-22
updated: 2026-07-22
status: current
---
```

## Field rules

- **`description`** (required) — the single highest-value field. Write it as *the question someone would type when looking for this doc*, not a topic label. Good: `How do we detect AIO cannibalisation from GSC impression data?` Bad: `GSC notes`.
- **`summary`** (required for wiki pages, recommended elsewhere) — the distilled answer/resolution, 2–3 sentences.
- **`tags`** — kebab-case, sparse (folder structure does most categorisation). Client slugs and domains (`geo`, `seo`, `content`, `ai`) are the common vocabulary.
- **`sources`** — workspace-relative paths or URLs this doc was compiled from.
- **`created` / `updated`** — ISO 8601. Bump `updated` on any substantive edit.
- **`status`** — `current` | `historical` | `superseded` (if superseded, add `superseded_by: "[[page-slug]]"`).

## Scope rules

- Applies to **new** docs in `knowledge/`, `agency/research/`, `clients/*/research/`, `clients/*/strategy/`. Skills that emit docs (rdg-wiki-ingest, pm-codify, pm-meeting-summariser, brief generators) should emit this block.
- Do **NOT** hand-backfill existing docs. The indexer auto-stubs `description` from the H1 + first paragraph and marks it `stub: true` in the catalog; stubs get upgraded opportunistically (when a doc is next edited) or via a targeted LLM pass.
- This block complements — does not replace — existing conventions: `YYYY-MM-DD-` filename prefixes for dated research, `**Date:**` in the body, wikilinks in content.
- Never put wikilinks inside frontmatter values other than `superseded_by`.

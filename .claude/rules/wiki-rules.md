---
paths:
  - "knowledge/raw/**"
  - "knowledge/wiki/**"
---

# Knowledge wiki rules

`knowledge/raw/` contains immutable, human-curated source material. `knowledge/wiki/` contains LLM-maintained synthesis.

On ingest, read the source, create or update focused entity/concept pages, add `[[wikilinks]]`, update the domain `_index.md`, and append an entry to `knowledge/wiki/_log.md`. On query, start with the relevant index. On lint, find contradictions, stale claims, orphans, and missing pages.

Use `## YYYY-MM-DD type | Description` log entries, where type is `ingest`, `query`, `lint`, or `update`. Never silently rewrite raw evidence.

All wiki pages carry the standard frontmatter from `.claude/rules/frontmatter.md` (`description` — the one-line question the page answers — is required). New pages must include it; existing pages are auto-stubbed by the indexer, do not hand-backfill.

Index stats (`pages`, `total_pages`, `last_updated` frontmatter) are maintained by `python3 .claude/lib/pm_index.py sync-indexes` — never hand-count. Curated index prose stays human/LLM-written; only stats and the Unfiled section are machine-managed.

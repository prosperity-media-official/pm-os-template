---
paths:
  - "knowledge/raw/**"
  - "knowledge/wiki/**"
---

# Knowledge wiki rules

`knowledge/raw/` contains immutable, human-curated source material. `knowledge/wiki/` contains LLM-maintained synthesis.

On ingest, read the source, create or update focused entity/concept pages, add `[[wikilinks]]`, update the domain `_index.md`, and append an entry to `knowledge/wiki/_log.md`. On query, start with the relevant index. On lint, find contradictions, stale claims, orphans, and missing pages.

Use `## YYYY-MM-DD type | Description` log entries, where type is `ingest`, `query`, `lint`, or `update`. Never silently rewrite raw evidence.

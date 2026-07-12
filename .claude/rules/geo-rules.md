---
paths:
  - "clients/*/geo/**"
---

# GEO rules

GEO is distinct from classic SEO. File work by its primary mechanism:

| Folder | Purpose |
|---|---|
| `schema/` | structured data and entity graphs |
| `content-audits/` | passage-level AI extractability |
| `technical-audits/` | AI crawler access, cache, headers, robots, and llms.txt |
| `prompt-tracking/` | prompt sets, share of voice, citations, and sentiment |
| `entity-research/` | entity mapping and knowledge-panel research |
| `citation-acquisition/` | third-party source and citation strategy |
| `ad-hoc/` | one-off GEO work |

- Prefix every file with `YYYY-MM-DD-`.
- Group multi-file deliverables in an undated kebab-case subfolder; keep dated filenames inside it.
- Describe proven, documented mechanisms separately from hypotheses. Do not promise unsupported visibility gains.
- Use stable canonical `@id` values for entities and full page-local declarations where validators/engines require them.
- For a single JSON-LD block, deliver a bare object rather than a single-element array.
- Dev-facing schema output is valid, comment-free, paste-ready JSON-LD.
- Validate schema before sign-off with Schema.org Validator and the relevant search-engine rich-results test.

---
domains: 5
total_pages: 0
last_updated: 2026-07-22
---

# Wiki — Master Index

LLM-compiled knowledge base using the Karpathy LLM Wiki pattern. Raw sources live in `raw/`, compiled knowledge lives here. The LLM writes and maintains all wiki content. Stats in this file and the domain indexes are maintained by `python3 .claude/lib/pm_index.py sync-indexes` — never hand-count.

## Domains

### [[seo/_index|SEO]] — 0 pages
Search engine optimisation frameworks, playbooks, algorithm updates, ranking factors, and technical SEO patterns.

### [[geo/_index|GEO]] — 0 pages
Generative Engine Optimisation — AI search visibility, citability signals, llms.txt, AI Overviews, and AI crawler accessibility.

### [[content/_index|Content]] — 0 pages
Content strategy, writing frameworks, brief methodologies, and content quality patterns.

### [[ai/_index|AI]] — 0 pages
LLM behaviour, model capabilities, AI-industry news, and AI tooling.

### [[industry/_index|Industry]] — 0 pages
Client industry knowledge across verticals.

## How This Works

| Layer | Location | Who owns it | Purpose |
|-------|----------|-------------|---------|
| **Raw sources** | `raw/` | Human (curates) | Immutable source documents — clipped articles, notes, PDFs |
| **Wiki** | `wiki/` | LLM (writes & maintains) | Compiled knowledge — entity pages, concept pages, synthesis |
| **Schema** | `.claude/rules/` | Co-evolved | Conventions, workflows, page formats (`frontmatter.md`, `wiki-rules.md`) |

## Workflows

- **Ingest:** Drop source into `raw/[domain]/` → LLM compiles into wiki pages → `sync-indexes` updates stats → append to `_log.md`
- **Query:** `python3 .claude/lib/pm_search.py query "<question>"` first; read the pages it surfaces
- **Lint:** Periodic health check → contradictions, stale claims, orphan pages, missing cross-refs

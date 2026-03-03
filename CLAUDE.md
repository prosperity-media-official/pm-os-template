# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

**Prosperity Brain** is a content marketing and SEO agency workspace. Each subfolder represents a different client, containing their brand docs, content briefs, and strategy materials.

## Skills Dependency

> **This workspace requires prosperity-skills to function.**
> Skills must be installed at `prosperity-skills/` (as a git submodule) and symlinked into `~/.claude/skills/`.
> If `/pm-new-project`, `/pm-codify`, `/pm-generate-content-brief`, or `/pm-reporting` are not working, run `bash setup.sh` from the workspace root.

## Structure

```
Prosperity Brain/
├── CLAUDE.md              ← This file (agency-wide rules)
├── .prosperity-brain/     ← Global "Brain" — agency-wide resources & research
│   └── research/          ← Guides, frameworks, tools, non-client research
├── prosperity-skills/     ← Claude Code skills (git submodule)
├── _example-client/       ← Skeleton client folder (rename or delete)
│   ├── CLAUDE.md          ← Client-specific brand rules template
│   ├── business/          ← Business context, tone of voice, avatars (markdown only)
│   ├── assets/            ← PDFs, images, brochures, and other non-markdown files
│   ├── content/           ← Content briefs by year/month
│   ├── seo/               ← All SEO deliverables (except reporting)
│   │   ├── content/       ← KWR, content strategy, content gap analysis
│   │   ├── technical/     ← Technical audits, crawl reports, site health
│   │   └── ad-hoc/        ← One-off SEO tasks, quick analyses, misc
│   ├── research/          ← Client-specific research, summaries, call prep
│   └── reporting/         ← Monthly reports, QBRs, report prompts
└── <client-name>/         ← Add new client folders here (use /pm-new-project)
    ├── CLAUDE.md          ← That client's specific rules
    ├── business/          ← Business context, tone of voice, avatars (markdown only)
    ├── assets/            ← PDFs, images, non-markdown files
    ├── content/
    ├── seo/               ← SEO deliverables (content/, technical/, ad-hoc/)
    ├── research/
    └── reporting/         ← Monthly reports, QBRs, report prompts
```

**Per-client CLAUDE.md files** are automatically loaded when working within that client's directory. Always check the client's CLAUDE.md and `business/` folder before producing any content.

## Adding a New Client

1. Create a folder: `<client-name>/`
2. Add `<client-name>/CLAUDE.md` with brand voice, target audiences, content constraints, and SEO goals
3. Add `<client-name>/business/` with business context, tone of voice, and customer avatar documents (markdown only)
4. Add `<client-name>/assets/` for PDFs, images, brochures, and other non-markdown files
5. Add `<client-name>/content/` organized by year and month
6. Add `<client-name>/seo/` with subfolders `content/`, `technical/`, `ad-hoc/`
7. Add `<client-name>/research/` for research outputs

Or simply run `/pm-new-project` — the skill handles all of this automatically.

## Research Document Rules

All research documents — across every client and the global `.prosperity-brain/` folder — **must**:
1. Include the date as a file name prefix in `DD-MM-YYYY-` format (e.g., `03-03-2026-brand-deep-dive.md`)
2. Include `**Date:** DD/MM/YYYY` at the top of the document body

## SEO Folder Rules

All SEO deliverables (except monthly reports, which go in `reporting/`) are stored in `<client>/seo/` with three subfolders:

| Subfolder | What goes here | Examples |
|-----------|---------------|----------|
| `content/` | Keyword research, content strategy, content gap analysis, competitor content audits, content plans | KWR reports, SERP analysis, content calendars, topic cluster maps, CSVs from Ahrefs/GSC |
| `technical/` | Technical SEO audits, crawl reports, site health, indexation, Core Web Vitals, schema, redirects | Site audit reports, crawl error logs, redirect maps, schema validation, CWV reports |
| `ad-hoc/` | One-off SEO tasks, quick analyses, misc deliverables that don't fit content or technical | Internal linking audits, meta tag rewrites, cannibalisation checks, quick-win lists |

**File naming:** All files in `seo/` **must** use a date prefix in `DD-MM-YYYY-` format (e.g., `19-02-2026-keyword-opportunity-report.md`). This applies to all file types — markdown, CSV, PDF.

**When to file into `seo/` vs other folders:**
- SEO keyword research, audits, strategy work → `seo/`
- Monthly performance reports → `reporting/`
- General client research, call prep, discovery → `research/`
- Content briefs for writers → `content/`

## Self-Improvement Protocol

Claude must autonomously learn and adapt throughout every session. This is a living document.

**When to update:**
- The user gives direct feedback or corrects an output (e.g., "don't write it like that", "always use this format")
- A content preference or workflow pattern is confirmed across interactions
- A new client-wide or agency-wide rule is established
- Something previously assumed turns out to be wrong

**What to update:**
- Add confirmed preferences to the "Learned Preferences" section below (agency-wide) or in the relevant client's CLAUDE.md (client-specific)
- Correct or remove rules that have been superseded
- Record workflow patterns the user relies on (e.g., preferred output formats, review steps)

**How to update:**
- Append to the appropriate "Learned Preferences" section with a brief, clear note
- Keep entries concise — one line per preference where possible
- Do not duplicate entries; update existing ones if a preference evolves
- Notify the user when a preference has been recorded (e.g., "Noted — I've added that to your CLAUDE.md")

**Scope:**
- Agency-wide feedback → update this file's "Learned Preferences" section
- Client-specific feedback → update that client's `CLAUDE.md` "Learned Preferences" section

## Learned Preferences

- Store research outputs (summaries, analysis, call prep) as `.md` files in each client's `research/` folder
- Global/non-client research goes in `.prosperity-brain/research/` — the agency "Brain"
- Whenever new information is learned about a client (from research, calls, documents, or conversation), update that client's CLAUDE.md immediately to keep it the single source of truth
- All research documents must include the current date at the top in DD/MM/YYYY format and in the file name as a prefix (e.g., `DD-MM-YYYY-research-topic.md`)
- When building a Claude skill, always reference `.prosperity-brain/research/03-03-2026-claude-skill-creator-guide.md` to follow best practices

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

**Prosperity Brain** is a content marketing and SEO agency workspace. Each subfolder represents a different client, containing their brand docs, content briefs, and strategy materials.

## Skills Dependency

> **This workspace requires prosperity-skills to function.**
> Skills must be installed at `prosperity-skills/` (as a git submodule) and symlinked into `~/.claude/skills/`.
> If skills are not working, run `bash setup.sh` from the workspace root.

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
│   ├── reporting/         ← Monthly reports, QBRs, report prompts
│   └── pinterest/         ← Pinterest pin generation output
├── <team-member>/         ← Personal folder (e.g., richard/, sarah/) — use /pm-onboard
│   ├── CLAUDE.md          ← Personal rules, role, clients, preferences
│   ├── sops/              ← Standard operating procedures
│   ├── notes/             ← Meeting notes, ideas, personal context
│   ├── tasks/             ← To-do lists, priorities, project tracking
│   ├── tools/             ← Internal tools built for the team
│   └── templates/         ← Reusable templates
└── <client-name>/         ← Add new client folders here (use /pm-new-project)
    ├── CLAUDE.md          ← That client's specific rules
    ├── business/          ← Business context, tone of voice, avatars (markdown only)
    ├── assets/            ← PDFs, images, non-markdown files
    ├── content/
    │   └── YYYY/
    │       └── <Month>/
    │           ├── deliverable/ ← Final DOCX briefs (client-facing deliverables)
    │           └── markdown/    ← Markdown backup briefs + research files
    ├── seo/               ← SEO deliverables (content/, technical/, ad-hoc/)
    ├── research/
    ├── reporting/          ← Monthly reports, QBRs, report prompts
    │   ├── <client>_monthly_report_prompt.md  ← Shared report prompt
    │   └── YYYY-MM/        ← Month folder (month report was CREATED, not the data month)
    │       ├── deliverable/ ← Final report email (.md)
    │       └── assets/      ← Looker Studio PDFs, raw data inputs
    └── pinterest/          ← Pinterest pin generation output
        └── YYYY-MM/        ← Month folder (when pins were created)
            └── <slug>/     ← URL slug of the target landing page
                ├── images/     ← Raw AI-generated PNGs
                ├── metadata/   ← SEO JSON per angle (title, desc, hashtags, altText)
                ├── prompts/    ← 6-layer prompt text per angle
                └── summary.json ← Complete generation report
```

**Per-client CLAUDE.md files** are automatically loaded when working within that client's directory. Always check the client's CLAUDE.md and `business/` folder before producing any content.

## Adding a Team Member

Run `/pm-onboard` to scaffold a personal folder for any team member. The skill runs a guided walkthrough covering identity, responsibilities, working preferences, and SOPs, then creates:

```
<name>/
├── CLAUDE.md       ← Personal rules, role, clients, preferences
├── sops/           ← Standard operating procedures
├── notes/          ← Meeting notes, ideas, personal context
├── tasks/          ← To-do lists, priorities, project tracking
├── tools/          ← Internal tools built for the team
└── templates/      ← Reusable templates
```

You can also create this manually:

1. Create a folder: `<firstname>/` (lowercase, no spaces)
2. Add `<firstname>/CLAUDE.md` with role, clients, tools, working preferences
3. Add subfolders: `sops/`, `notes/`, `tasks/`, `tools/`, `templates/`

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

## Content Brief Folder Rules

Content briefs are stored in `<client>/content/` organized by year and month. Each month folder uses `deliverable/` and `markdown/` subfolders.

```
<client>/content/
└── 2026/
    └── March/
        ├── deliverable/    ← Final DOCX briefs (client-facing deliverables)
        │   └── Client - keyword slug _ 3-2026.docx
        └── markdown/       ← Markdown backup briefs + research files
            ├── Client - keyword slug _ 3-2026 - Brief.md
            └── Client - keyword slug _ 3-2026 - Research.md
```

**Rules:**
1. **DOCX files** go in `deliverable/` — these are the final client-facing output
2. **Markdown files** (.md) go in `markdown/` — these are backup briefs and research files
3. **Auto-create** both subfolders when generating a new brief
4. **File naming:** `<Client> - <keyword slug> _ <MM>-<YYYY>.docx` for deliverables; append `- Brief.md` or `- Research.md` for markdown files

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

## Reporting Folder Rules

All client reporting **must** follow this folder structure. This is a hard rule — never save reports or assets loose in the `reporting/` root.

```
<client>/reporting/
├── <client>_monthly_report_prompt.md   ← Shared prompt (stays at root)
├── 2026-01/
│   ├── deliverable/                    ← Final report email (.md)
│   │   └── <client>_dec_25_report.md
│   └── assets/                         ← Looker PDFs, raw data, screenshots
│       └── <client>_dec_25_report.pdf
└── ...
```

**Rules:**
1. **Folder naming:** `YYYY-MM` format — the month the report is **created** (not the data month). E.g., a report created in March covering February data goes in `2026-03/`
2. **`deliverable/`** contains the final report email markdown file — this is the client-facing output
3. **`assets/`** contains all raw inputs — Looker Studio PDFs, CSVs, screenshots, or any other source material used to create the report
4. **Auto-create:** When starting a new report, always create the `YYYY-MM/deliverable/` and `YYYY-MM/assets/` folders if they don't exist
5. **Sorting:** `YYYY-MM` ensures folders sort chronologically — newest is always last (or first with reverse sort)
6. **Only the report prompt file** lives at the `reporting/` root level. Everything else goes inside a month folder
7. **When a user provides a Looker PDF or raw data**, always copy/move it into the correct `YYYY-MM/assets/` folder

## Pinterest Folder Rules

Pinterest pin output is stored in `<client>/pinterest/` organized by month and landing page slug.

```
<client>/pinterest/
├── 2026-03/
│   └── zone-diet-guide/            ← Slug from the landing page URL
│       ├── images/                 ← AI-generated PNGs with Gemini-rendered text (final deliverables)
│       ├── metadata/               ← SEO JSON per angle (title, desc, hashtags, altText)
│       ├── prompts/                ← AI-written prompt text per angle
│       └── summary.json            ← Complete generation report
└── 2026-04/
    └── another-blog-post/
        └── ...
```

**Rules:**
1. **Folder naming:** `YYYY-MM/<slug>/` — month pins were created, slug from landing page URL path
2. **Slug derivation:** Take the last path segment of the landing page URL (e.g., `/blogs/crossfit/zone-diet-guide` → `zone-diet-guide`)
3. **4 standard angles always generated:** benefit-focused, question-based, how-to, listicle
4. **Images in `images/` are the final deliverables** — Gemini renders minimal headline text directly into the image (no separate overlay step)
5. **`metadata/` JSON files** contain SEO copy to use when uploading pins (title, description, hashtags, alt text)
6. **`summary.json`** tracks brand context, landing page context, all variants, and generation stats
7. **Generated via** the `pm-generate-pinterest` skill using Gemini 3.1 Flash (image generation) + Gemini 3 Flash (prompts & SEO)
8. **Google Sheet sync:** Each client's CLAUDE.md should store their Pinterest Content Calendar Google Sheet ID and Pinterest Images Drive folder ID under `## Pinterest Tracking`. Standard columns: Topic Cluster (A), Link (B), Pin Image Link (C), Title (D), Description (E), Board (F), Tagged Topics (G), Tag Products (H), Alt Text (I)

## Available Skills

These skills automate common Prosperity workflows. They are bundled in `prosperity-skills/` and installed via `bash setup.sh`.

| Skill | Trigger | What it does |
|-------|---------|--------------|
| `pm-onboard` | `/pm-onboard` or "onboard me", "set up my workspace" | Scaffold a personal team member folder with guided walkthrough |
| `pm-new-project` | `/pm-new-project` or "new client", "new project" | Onboard a new client — scrapes website, runs discovery, creates full folder structure |
| `pm-generate-content-brief` | `/pm-generate-content-brief` or "content brief", "new brief" | Generate SEO content briefs as formatted DOCX files |
| `pm-codify` | `/pm-codify` or "codify", "convert this", "process this document" | Convert client documents (PDFs, DOCXs, emails) to clean markdown |
| `pm-reporting` | `/pm-reporting` or "monthly report", "SEO report" | Generate monthly SEO performance report emails |
| `pm-generate-pinterest` | `/pm-generate-pinterest` or "generate pins", "pinterest batch" | Generate Pinterest-optimised pin images at scale with Gemini |
| `pm-generate-optimisation-brief` | `/pm-generate-optimisation-brief` or "optimisation brief", "optimise content" | Generate SEO optimisation briefs with inline comments for existing content |
| `pm-skill-creator` | `/pm-skill-creator` or "create a skill", "new skill", "build a skill" | Create new Prosperity skills with validated structure and Anthropic best-practice compliance |

**First-time setup:** Run `bash setup.sh` from the workspace root to symlink all skills into `~/.claude/skills/`.

## Self-Improvement Protocol

Claude must autonomously learn and adapt throughout every session. This is a living document.

**The Correction Rule:** Every time the user corrects Claude or points out a mistake, Claude must fix the issue AND immediately end with: *"I've updated CLAUDE.md so I don't make that mistake again."* Then actually update the relevant CLAUDE.md. This is non-negotiable — every correction becomes a permanent rule. Claude should be ruthless about writing rules for itself.

**When to update:**
- The user gives direct feedback or corrects an output (e.g., "don't write it like that", "always use this format")
- A content preference or workflow pattern is confirmed across interactions
- A new client-wide or agency-wide rule is established
- Something previously assumed turns out to be wrong
- After any failed attempt or mistake — capture what went wrong so it never recurs

**What to update:**
- Add confirmed preferences to the "Learned Preferences" section below (agency-wide) or in the relevant client's CLAUDE.md (client-specific)
- Correct or remove rules that have been superseded
- Record workflow patterns the user relies on (e.g., preferred output formats, review steps)

**How to update:**
- Append to the appropriate "Learned Preferences" section with a brief, clear note
- Keep entries concise — one line per preference where possible
- Do not duplicate entries; update existing ones if a preference evolves
- Notify the user when a preference has been recorded (e.g., "Noted — I've added that to your CLAUDE.md")
- Ruthlessly edit and prune CLAUDE.md over time — keep iterating until mistake rate measurably drops

**Scope:**
- Agency-wide feedback → update this file's "Learned Preferences" section
- Client-specific feedback → update that client's `CLAUDE.md` "Learned Preferences" section

## Workflow Best Practices

These are agency-wide workflow rules sourced from Claude Code best practices. Follow these in every session.

### Parallel Worktrees
- For multi-client or multi-task work, suggest spinning up parallel worktrees (3-5 sessions) to maximise throughput
- Example: generating reports for 3 clients simultaneously, or running an SEO audit while writing content briefs
- Use `/worktree` to create isolated sessions when working on independent tasks

### Plan Mode First
- Start every complex task in plan mode. Pour energy into the plan so Claude can one-shot the implementation
- If something goes sideways mid-task, switch back to plan mode and re-plan — don't keep pushing
- Use plan mode for verification steps too, not just the build

### Subagents for Scale
- Append "use subagents" to any request where more compute would help (e.g., large audits, multi-page analysis)
- Offload individual tasks to subagents to keep the main context window clean and focused

### Prompting Patterns
- When the user asks for a review, be rigorous — challenge the work, don't just approve it
- After a mediocre output, scrap it and implement the better solution rather than patching
- Reduce ambiguity before starting work — ask clarifying questions upfront, not mid-task
- Use voice dictation where possible — prompts get more detailed when spoken (3x faster than typing)

### Chrome MCP for Validation
- When available, use Chrome MCP to validate web changes, check live pages, and verify SEO implementations visually
- This is especially valuable for technical SEO audits, schema validation, and page-level checks

### Session Hygiene
- Use `/permissions` to pre-allow common actions at the start of sessions to reduce friction
- Keep context windows clean by delegating research-heavy subtasks to subagents
- Use `/statusline` to always show context usage and current git branch

## Learned Preferences

- Store research outputs (summaries, analysis, call prep) as `.md` files in each client's `research/` folder
- Global/non-client research goes in `.prosperity-brain/research/` — the agency "Brain"
- Whenever new information is learned about a client (from research, calls, documents, or conversation), update that client's CLAUDE.md immediately to keep it the single source of truth
- All research documents must include the current date at the top in DD/MM/YYYY format and in the file name as a prefix (e.g., `DD-MM-YYYY-research-topic.md`)
- When building a Claude skill, always reference `.prosperity-brain/research/03-03-2026-claude-skill-creator-guide.md` to follow best practices
- **Internal links in content briefs must be verified against the client's live sitemap.xml** before inclusion. Never hallucinate URLs. For each client, maintain a sitemap URL reference file at `<client>/seo/content/DD-MM-YYYY-<client>-sitemap-urls.md`. Scrape the sitemap fresh if the reference file is older than 30 days.

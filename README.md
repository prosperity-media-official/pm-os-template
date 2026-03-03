# Prosperity Brain

A content marketing and SEO agency workspace powered by [Claude Code](https://claude.ai/code). Prosperity Brain gives you a structured, AI-native system for managing clients — from onboarding and brand docs to SEO deliverables, content briefs, and monthly reporting. Clone this template to bootstrap your own workspace and start onboarding clients immediately.

---

## Prerequisites

> **CRITICAL: This workspace requires [prosperity-skills](https://github.com/reapzyau/prosperity-skills) to function.**
>
> Without it, slash commands (`/pm-new-project`, `/pm-codify`, `/pm-generate-content-brief`, `/pm-reporting`) will not work and you'll lose the majority of the automation this system provides.
>
> The skills are included as a git submodule. Always clone with `--recurse-submodules` (see Quick Start below).

You also need:
- [Git](https://git-scm.com/) installed
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated

## Quick Start

```bash
# 1. Clone with submodules (critical — don't skip --recurse-submodules)
git clone --recurse-submodules https://github.com/reapzyau/prosperity-brain-template.git my-workspace

# 2. Run setup (installs skills into Claude Code)
cd my-workspace && bash setup.sh

# 3. Open Claude Code and onboard your first client
# Run /pm-new-project inside Claude Code
```

## Workspace Structure

```
my-workspace/
├── CLAUDE.md                  ← Agency-wide rules & conventions (auto-loaded by Claude Code)
├── README.md                  ← This file
├── setup.sh                   ← One-time setup script
├── .prosperity-brain/         ← Global "Brain" — agency-wide resources & research
│   └── research/              ← Guides, frameworks, non-client research
├── prosperity-skills/         ← Claude Code skills (git submodule)
├── _example-client/           ← Skeleton client folder (rename or delete after first real client)
│   ├── CLAUDE.md              ← Client-specific brand rules template
│   ├── business/              ← Business context, tone of voice, avatars
│   ├── assets/                ← PDFs, images, brochures
│   ├── content/               ← Content briefs by year/month
│   ├── seo/                   ← SEO deliverables (content/, technical/, ad-hoc/)
│   ├── research/              ← Client-specific research
│   └── reporting/             ← Monthly reports, QBRs
└── <your-clients>/            ← Created by /pm-new-project
```

## Skills

Custom Claude Code skills included via the `prosperity-skills/` submodule.

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `pm-new-project` | `/pm-new-project` | Onboard a new client — guided walkthrough, website scrape, generates full folder structure and docs |
| `pm-generate-content-brief` | `/pm-generate-content-brief` | Generate SEO content briefs as DOCX files |
| `pm-codify` | `/pm-codify` | Convert client documents (PDF, DOCX, etc.) to markdown and file them |
| `pm-reporting` | `/pm-reporting` | Generate monthly SEO performance report emails |

## Adding a New Client

Run `/pm-new-project` inside Claude Code — the skill handles everything automatically (folder structure, CLAUDE.md, business docs).

Or manually: create a folder following the `_example-client/` structure and add your own `CLAUDE.md` and `business/` docs.

## Updating Skills

To pull the latest version of prosperity-skills:

```bash
git submodule update --remote prosperity-skills
git add prosperity-skills
git commit -m "Update prosperity-skills to latest"
```

## Conventions

- **File naming:** All research and SEO files use a `DD-MM-YYYY-` date prefix (e.g., `03-03-2026-keyword-report.md`)
- **Client CLAUDE.md:** Each client folder has its own `CLAUDE.md` — Claude Code auto-loads it when working in that directory
- **Self-improvement:** Claude autonomously records learned preferences in CLAUDE.md files
- See the root `CLAUDE.md` for full rules

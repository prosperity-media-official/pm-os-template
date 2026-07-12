# Prosperity OS — Agency Workspace

## Purpose

This is a private content marketing, SEO, and GEO workspace. It contains reusable agency knowledge plus confidential client and team-member context. Codex reads `AGENTS.md`; Claude Code reads `CLAUDE.md`. Keep their instructions aligned.

## Skills dependency

This workspace requires the separate sibling `pm-skills` repository. Run `./setup.ps1` on native Windows or `bash setup.sh` on macOS/Linux/WSL. Setup clones the current shared repository when needed and installs every `pm-*` skill plus `_shared` into both `~/.codex/skills/` and `~/.claude/skills/`.

Never add `pm-skills` as a submodule or nested repository. Rerun setup after either sibling moves.

## Structure

```text
pm-os/
├── clients/       one folder per client
├── team/          team-member workspaces and pre-engagement sales
├── agency/        shared research, SEO/GEO playbooks, plans, outputs, YouTube
├── knowledge/     immutable raw sources and LLM-maintained wiki
├── .claude/rules/ path-scoped domain rules
└── .obsidian/     portable vault configuration
```

Each client lives under `clients/<client>/` and should contain `AGENTS.md`, `CLAUDE.md`, `business/`, `assets/`, `content/`, `seo/`, `geo/`, `strategy/`, `research/`, `meetings/`, `reporting/`, and `tasks/`.

## Context loading

Before producing client work:

1. Read the client's `AGENTS.md` and/or `CLAUDE.md`.
2. Read all four living business documents: `business/business-context.md`, `business/offer.md`, `business/customer-avatar.md`, and `business/tone-of-voice.md`.
3. Read the relevant path-scoped rule in `.claude/rules/`.
4. Use current source material; never infer confidential facts from another client.

Whenever durable new client information is confirmed, update the most-local client instruction or living business document. Never put volatile metrics, deadlines, or task lists into instruction files.

## Folder routing

State the proposed destination before creating a substantial file.

| Purpose | Destination |
|---|---|
| Client work | `clients/<client>/<most-specific-subfolder>/` |
| Team-member SOP, note, task, template, or tool | `team/<name>/<subfolder>/` |
| Pre-engagement sales work | `team/sales/` |
| Agency-wide research or framework | `agency/research/` |
| Agency implementation plan | `agency/plans/` |
| Reusable agency artifact or design template | `agency/templates/` |
| Raw knowledge source | `knowledge/raw/<domain>/` |
| Compiled knowledge | `knowledge/wiki/<domain>/` |
| Nothing else fits | `misc/` inside the most-specific parent; never top-level `_misc/` |

## Naming and dates

- Use ISO 8601 everywhere: `YYYY-MM-DD` in filenames and document bodies.
- Research and SEO/GEO deliverables use a `YYYY-MM-DD-` filename prefix.
- Research documents include `**Date:** YYYY-MM-DD` near the top.
- Living business documents do not use date prefixes.
- Use lowercase kebab-case for slugs.

## Core client rules

- Never mention another client in client-facing work.
- All brief URLs must be absolute.
- Verify internal links against the client's live sitemap. Maintain a dated sitemap reference under `seo/content/` and refresh it when older than 30 days.
- Verify suspected redirects with `curl -sIL` before recommending a redirect implementation.
- Keep API keys only in the gitignored root `.env`.
- Use Australian English unless the client's rules explicitly require otherwise.

## Content pipeline

Content uses one folder per keyword and numbered stages:

```text
clients/<client>/content/YYYY/NN-Month/<keyword-slug>/
├── 1-brief/{md,docx}/
├── 2-article/{md,docx}/
├── 3-qa/{md,docx}/
├── 4-final/{md,docx}/
└── source/{md,docx}/
```

Never leave files loose at the keyword root. QA creates a new artifact and never overwrites the article. Keep matching Markdown and DOCX outputs in sync. HTML and Google uploads are opt-in, not default outputs. See `.claude/rules/content-rules.md`.

## Obsidian and knowledge

This repository is an Obsidian vault. Prefer `[[wikilinks]]`, `![[embeds]]`, and sparse YAML tags. Do not commit machine-specific workspace state. Treat `knowledge/raw/` as immutable human-curated evidence; maintain compiled pages and indexes under `knowledge/wiki/`.

## Self-correction protocol

When corrected or when a non-obvious failure is discovered, fix the current output and strengthen the harness so the class of error is less likely to recur.

Enforcement order: automated sensor or validator > most-local scoped guide > memory/context. Agency-wide rules belong here only when truly cross-cutting; client rules belong in that client's instruction file; workflow behavior belongs in the relevant skill or scoped rule. Keep instruction files lean, deduplicate entries, and prefer updating an existing rule over appending a near-duplicate.

When the user directly corrects the system, report where the correction was recorded and end with: "I've updated AGENTS.md so I don't make that mistake again."

## Adding teammates and clients

- Run `/pm-onboard` to scaffold `team/<name>/`.
- Run `/pm-new-project` to scaffold `clients/<client>/`.
- Use the `_example-*` folders only as references; do not put real information into them.

## Learned preferences

<!-- Add only confirmed agency-wide preferences. Keep one concise line per preference. -->

- `/pm-start` must treat `pm-skills` as a separate sibling repository and explicitly prompt first-time users to download it and install all skill links for Claude Code, ChatGPT/Codex, or both.
- The canonical workspace and product name is `pm-os` / **Prosperity OS**. Use `pm-brain` only when documenting or detecting a legacy installation.
- Present a copy-paste AI prompt as the primary `pm-skills` installation method in onboarding documentation; keep direct setup commands as a manual fallback.
- First-time setup must automatically bootstrap supported runtimes and package dependencies, then report only credentials or interactive authentication that still require the user.

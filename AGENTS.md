# Prosperity OS — Agency Workspace

## Purpose

This is a private content marketing, SEO, and GEO workspace. It contains reusable agency knowledge plus confidential client and team-member context. Codex reads `AGENTS.md`; Claude Code reads `CLAUDE.md`. Keep their instructions aligned.

## Skills dependency

This workspace requires the separate sibling `pm-skills` repository. Run `./setup.ps1` on native Windows or `bash setup.sh` on macOS/Linux/WSL. Setup clones the current shared repository when needed and installs every `pm-*` skill plus `_shared` into both `~/.codex/skills/` and `~/.claude/skills/`.

Never add `pm-skills` as a submodule or nested repository. Rerun setup after either sibling moves.

## Structure

```text
Prosperity Workspace/
├── pm-os/                    this repository — your private workspace
│   ├── .pm/clients.json      client registry: pointers only, never client work
│   ├── team/                 team-member workspaces and pre-engagement sales
│   ├── agency/               shared research, SEO/GEO playbooks, plans, outputs, YouTube
│   ├── knowledge/            immutable raw sources and LLM-maintained wiki
│   ├── .claude/rules/        path-scoped domain rules
│   └── .obsidian/            portable vault configuration
├── pm-skills/                shared team automation
└── pm-client-<slug>/         one repository per client
```

**Client work never lives in this repository.** Each client has its own repository, a flat sibling of `pm-os`, containing `AGENTS.md`, `CLAUDE.md`, its own `.claude/rules/`, `business/`, `assets/`, `content/`, `seo/`, `geo/`, `strategy/`, `research/`, `meetings/`, `reporting/`, `pinterest/`, `dashboard/`, and `tasks/`.

The repo is the access boundary. Separating clients this way lets a client be shared with a teammate, a contractor, or the client themselves without exposing anything else. `pm-os` records only where each one is.

## Client repositories

`.pm/clients.json` maps each client slug to a path relative to this workspace. Each client repo identifies itself with `.pm/client.json`, which is what lets `/pm-start` discover repos the registry has not caught up with.

```bash
python3 "<pm-skills>/_shared/scripts/pm_paths.py" list            # registered clients
python3 "<pm-skills>/_shared/scripts/pm_paths.py" resolve <slug>  # slug -> real path
python3 "<pm-skills>/_shared/scripts/pm_paths.py" reconcile       # registry vs disk
```

- Add a client with `/pm-new-project` — it checks the organisation for an existing repo first, scaffolds, commits, and registers.
- `/pm-start` reports anything unregistered, missing, or still legacy.
- If a `clients/` folder still exists here, this workspace predates v2. Run `/pm-migrate-clients`.

Never resolve a client path by hand or assume a folder location; always go through the resolver.

## Context loading

Before producing client work:

1. Resolve the client repo, then read its `AGENTS.md`.
2. Read all four living business documents in that repo: `business/business-context.md`, `business/offer.md`, `business/customer-avatar.md`, and `business/tone-of-voice.md`.
3. The client repo's own `.claude/rules/` auto-load by path once you open a file there.
4. Use current source material; never infer confidential facts from another client.

Whenever durable new client information is confirmed, update the most-local instruction or living business document **in that client's repository**. Never put volatile metrics, deadlines, or task lists into instruction files. Never copy one client's material into another's repo or into `pm-os`.

## Finding information

The workspace has a local search layer. Before speculatively reading folders to orient, query it:

```bash
python3 .claude/lib/pm_search.py query "<question>" --scope clients/<client>  # hybrid ranked search (RRF-fused)
python3 .claude/lib/pm_search.py grep "<exact string>"                        # literal match (URLs, names, errors)
python3 .claude/lib/pm_search.py recent --scope <scope> --days 14             # what changed lately
python3 .claude/lib/pm_search.py who-knows "<topic>"                          # people signals (heuristic)
python3 .claude/lib/pm_search.py scopes                                       # list available scopes
```

Pass `--scope` whenever the client or domain is known. `--scope clients/<slug>` still works even though clients live in separate repositories — the indexer walks every linked client repo and files it under that scope, so the vocabulary is unchanged. Client documents are searchable locally but are deliberately kept out of the committed `knowledge/.index/catalog.jsonl`, so this workspace never mirrors client content.

The index behind it: `python3 .claude/lib/pm_index.py build` (incremental — run it when `pm_index.py status` reports stale, and at session end). `pm_index.py sync-indexes` maintains wiki `_index.md` stats and root `MEMORY.md` — never hand-count index stats. New knowledge docs carry the standard frontmatter in `.claude/rules/frontmatter.md`; `description` (the one-line question the doc answers) is what makes search work.

## Folder routing

State the proposed destination before creating a substantial file.

| Purpose | Destination |
|---|---|
| Client work | the client's own repository — resolve it, never guess a path |
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

Content is produced inside the client's own repository, one folder per keyword with numbered stages:

```text
<client-repo>/content/YYYY/NN-Month/<keyword-slug>/
├── 1-brief/{md,docx}/
├── 2-article/{md,docx}/
├── 3-qa/{md,docx}/
├── 4-final/{md,docx}/
└── source/{md,docx}/
```

Never leave files loose at the keyword root. QA creates a new artifact and never overwrites the article. Keep matching Markdown and DOCX outputs in sync. HTML and Google uploads are opt-in, not default outputs. The full rule ships inside each client repo at `.claude/rules/content-rules.md` and auto-loads when you open a file under `content/`.

## Obsidian and knowledge

This repository is an Obsidian vault. Prefer `[[wikilinks]]`, `![[embeds]]`, and sparse YAML tags. Do not commit machine-specific workspace state. Treat `knowledge/raw/` as immutable human-curated evidence; maintain compiled pages and indexes under `knowledge/wiki/`.

## Self-correction protocol

When corrected or when a non-obvious failure is discovered, fix the current output and strengthen the harness so the class of error is less likely to recur.

Enforcement order: automated sensor or validator > most-local scoped guide > memory/context. Agency-wide rules belong here only when truly cross-cutting; client rules belong in that client's instruction file; workflow behavior belongs in the relevant skill or scoped rule. Keep instruction files lean, deduplicate entries, and prefer updating an existing rule over appending a near-duplicate.

When the user directly corrects the system, report where the correction was recorded and end with: "I've updated AGENTS.md so I don't make that mistake again."

## Adding teammates and clients

- Run `/pm-onboard` to scaffold `team/<name>/`.
- Run `/pm-new-project` to create a client's own repository and link it here. It checks the `prosperity-media-official` organisation first — if a teammate already onboarded that client, you join their repo rather than creating a second one.
- Run `/pm-migrate-clients` once if this workspace still has a legacy `clients/` folder.
- Use the `_example-*` folders only as references; do not put real information into them.

## Learned preferences

<!-- Add only confirmed agency-wide preferences. Keep one concise line per preference. -->

- `/pm-start` must treat `pm-skills` as a separate sibling repository and explicitly prompt first-time users to download it and install all skill links for Claude Code, ChatGPT/Codex, or both.
- The canonical workspace and product name is `pm-os` / **Prosperity OS**. Use `pm-brain` only when documenting or detecting a legacy installation.
- Present a copy-paste AI prompt as the primary `pm-skills` installation method in onboarding documentation; keep direct setup commands as a manual fallback.
- First-time setup must automatically bootstrap supported runtimes and package dependencies, then report only credentials or interactive authentication that still require the user.

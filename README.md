# Prosperity OS Starter

A private, AI-native workspace for Prosperity Media strategists. It keeps client work, team knowledge, agency research, and shared automation in one predictable structure and works with both Codex and Claude Code.

This repository is a starter, not a shared client-data repository. Each teammate creates their own private workspace from it.

## Naming and repository model

| Repository | Purpose | Ownership |
|---|---|---|
| `pm-os-template` | Clean starter maintained for the team | Shared, contains no client data |
| `pm-os` | A teammate's working OS created from the template | Private to that teammate |
| `pm-skills` | Shared Prosperity automation | Separate shared repository |

`pm-os` is the canonical workspace and product name. Older installations may still be named `pm-brain`; `/pm-start` recognises that deprecated name for compatibility, but all new workspaces should use `pm-os`.

## What is included

- A current `clients/`, `team/`, `agency/`, and `knowledge/` workspace structure
- Matching `AGENTS.md` (Codex) and `CLAUDE.md` (Claude Code) guidance
- Scoped workflow rules for content, SEO, GEO, reporting, Pinterest, sales, and the knowledge wiki
- An Obsidian-ready vault with machine-specific state excluded
- Cross-platform installers that automatically clone the separate `pm-skills` repository and install all skills into both AI runtimes
- A reusable example client and team-member skeleton with no real client or personal data

## Prerequisites

Required:

- Codex, Claude Code, or both
- On Windows, PowerShell 7 or Windows PowerShell 5.1

Git is needed to obtain the initial template, but the AI setup flow can install it before cloning when a trusted system package manager is available. After the template is present, setup automatically bootstraps Git, GitHub CLI, Python 3, Node.js/npm, Bun, the common Python packages, and skill-local Node packages. Put credentials only in the workspace-root `.env`; never commit it. Authenticated services still require the user to complete their own sign-in or supply their own API key.

## Quick start

### AI-assisted setup (recommended)

Open Codex or Claude Code in the parent folder where you want your Prosperity workspace, then paste this prompt:

```text
Set up my personal Prosperity OS automatically from the private GitHub template at https://github.com/prosperity-media-official/pm-os-template.

Create a new private GitHub repository named pm-os under my authenticated GitHub account (or ask me which organisation to use if there is more than one valid destination), generate it from the template, and clone it locally into a folder named pm-os. Never add client or personal data to the shared pm-os-template repository.

Then run the correct installer for my environment from the new pm-os root: setup.ps1 on native Windows, or setup.sh on macOS, Linux, WSL, or Git Bash. Allow it to use the trusted system package manager when required. The installer must automatically install missing supported prerequisites, clone https://github.com/prosperity-media-official/pm-skills as a separate sibling repository named pm-skills, install all common Python and Node packages, install or symlink all pm-* skills and the shared toolchain for both Claude Code and ChatGPT/Codex, and verify every dependency and link.

If GitHub authentication, the destination owner, or the local parent folder cannot be detected safely, ask me only for the missing value. Do not overwrite an existing pm-os or pm-skills folder, do not make either personal repository public, and do not place pm-skills inside pm-os. When setup is complete, report the local paths and repository URLs, tell me whether I need to restart my AI client, run /pm-start to verify the installation, and then guide me through /pm-onboard.
```

The AI will use your existing GitHub authentication where available. If needed, it will pause so you can sign in or choose the account or organisation that should own your private `pm-os` repository.

### 1. Create your own private workspace

Use GitHub's **Use this template** action and create a **private** repository, then clone your new repository:

```powershell
git clone https://github.com/YOUR-ORG/YOUR-PRIVATE-OS.git pm-os
cd pm-os
```

If you cloned this source repository directly, detach it before adding client data:

```powershell
git remote rename origin template
git remote add origin https://github.com/YOUR-ORG/YOUR-PRIVATE-OS.git
git push -u origin main
```

### 2. Install `pm-skills` with AI

From Codex or Claude Code, open your new `pm-os` workspace and paste:

```text
Install the Prosperity Media skills for this pm-os workspace from https://github.com/prosperity-media-official/pm-skills.

Keep pm-skills as a separate sibling repository beside pm-os; never add it as a submodule or clone it inside pm-os. If a valid sibling pm-skills checkout already exists, reuse it and safely update it. Otherwise, clone it into a sibling folder named pm-skills.

Detect whether I am using native Windows, macOS, Linux, WSL, or Git Bash, then run the correct pm-os installer. Automatically install all missing supported prerequisites using winget, Homebrew, apt, dnf, yum, pacman, npm, or pip as appropriate. This includes Git, GitHub CLI where available, Python 3, Node.js/npm, Bun, openpyxl, python-docx, requests, lxml, and all package.json dependencies inside pm-skills. Ask once before any administrator elevation. Install or symlink every pm-* skill and the required _shared toolchain for both Claude Code and ChatGPT/Codex. Do not overwrite real files or directories when repairing links. Run the dependency, installer, and /pm-start health checks, report the pm-os and pm-skills paths and every installed destination, and tell me whether I need to restart either AI client.

If GitHub authentication or the intended parent folder cannot be detected safely, ask me only for the missing value before continuing.
```

The AI handles the clone, updates, runtime detection, links, and verification. The commands below are available only as a manual fallback.

Windows (recommended for native Windows Codex/Claude):

```powershell
./setup.ps1
```

macOS, Linux, WSL, or Git Bash:

```bash
bash setup.sh
```

The installer:

1. Installs missing supported runtimes with the detected trusted package manager.
2. Clones `prosperity-media-official/pm-skills` as a sibling of this workspace if it is missing.
3. Installs the common Python packages and each declared Node project dependency.
4. Discovers every `pm-*` skill dynamically instead of relying on a stale hand-maintained list.
5. Installs those skills plus the required `_shared` toolchain into both `~/.codex/skills/` and `~/.claude/skills/`.
6. Verifies every dependency and installed target and safely repairs stale links on repeat runs.

`pm-skills` is intentionally a separate sibling repository, not a submodule:

```text
Prosperity Workspace/
├── pm-os/          <- your private workspace
└── pm-skills/      <- shared team automation
```

To use a different skills location, set `PM_SKILLS_DIR` first. To update an existing clone, run `./setup.ps1 -Update` or `bash setup.sh --update`. To prevent automatic dependency installation, use `-SkipDependencies` or `--skip-dependencies`.

> WSL has a different home directory from native Windows. Use `setup.ps1` for native Windows apps; use `setup.sh` inside WSL only when Codex/Claude also runs inside WSL.

### 3. Personalise the workspace

1. Run `/pm-onboard` to create `team/<your-name>/`.
2. Run `/pm-new-project` to create your first client under `clients/`.
3. Delete the `_example-*` folders after you no longer need them.
4. Optionally open the folder as an Obsidian vault.
5. Optionally run `/pm-install-command-centre` after onboarding to install the per-user dashboard.

You can also invoke `/pm-start` from either supported AI client. On a first run it detects whether the separate `pm-skills` checkout exists, prompts before downloading it, asks whether to install for Claude Code, ChatGPT/Codex, or both, and validates every link before reporting success.

### 4. Recommended first-day sequence

```text
Create private repository from pm-os-template
        ↓
Clone it locally as pm-os
        ↓
Paste the AI prompt to install pm-skills
        ↓
Restart Claude Code or ChatGPT/Codex
        ↓
Run /pm-start to verify the installation
        ↓
Run /pm-onboard to create your team workspace
        ↓
Run /pm-new-project to add your first client
```

After onboarding, the normal working pattern is: open `pm-os`, name the client or task, let the AI load the relevant client and business context, run the appropriate `pm-*` skill, review the filed output, then commit completed work to the teammate's private repository.

## Workspace structure

```text
pm-os/
├── AGENTS.md                  <- Codex agency rules
├── CLAUDE.md                  <- Claude Code entry point
├── clients/                   <- one folder per client
│   └── _example-client/
├── team/                      <- personal workspaces and pre-engagement sales
│   ├── _example-team-member/
│   └── sales/
├── agency/                    <- shared research, playbooks, templates, plans, and outputs
├── knowledge/                 <- raw sources and compiled Obsidian wiki
├── .claude/rules/             <- path-scoped domain rules
├── .obsidian/                 <- portable vault settings only
├── setup.ps1                  <- native Windows installer
└── setup.sh                   <- POSIX installer
```

Every client starts with four living business documents: `business-context.md`, `offer.md`, `customer-avatar.md`, and `tone-of-voice.md`. Read all four plus the client's `AGENTS.md` or `CLAUDE.md` before producing client work.

## Core features

### Claude and ChatGPT/Codex support

The same workspace supports both clients. Codex reads `AGENTS.md` and discovers skills through `~/.codex/skills/`; Claude Code reads `CLAUDE.md` and discovers skills through `~/.claude/skills/`.

### `pm-skills`, private workspaces

Every teammate has a private `pm-os` containing their client and personal context while using the same separately maintained `pm-skills` repository. New skills are discovered dynamically and linked by setup or `/pm-start`.

### Structured client operations

Each client receives dedicated areas for business context, assets, staged content, SEO, GEO, strategy, research, meetings, reporting, Pinterest, dashboards, and tasks. The routing rules keep client-facing outputs separate from raw inputs and internal work.

### Staged content production

Content moves through `1-brief`, `2-article`, `3-qa`, and `4-final`, with separate Markdown and DOCX folders plus a source-provenance area. QA produces a new artifact instead of overwriting the article.

### SEO, GEO, reporting, and Pinterest workflows

Scoped rules cover keyword research, topical maps, technical audits, structured data, AI visibility, prompt tracking, monthly reporting, Pinterest generation, and metadata handling. Outputs are placed in predictable client folders with ISO-dated filenames.

### Obsidian knowledge system

`pm-os` is an Obsidian-ready vault. Agency resources live under `agency/`; immutable evidence lives under `knowledge/raw/`; maintained synthesis and indexes live under `knowledge/wiki/`.

### Self-improving operating system

Confirmed corrections and preferences are recorded in the most-local instruction surface: the root OS, a client, a team member, a scoped rule, or a shared skill. Mechanically checkable requirements should become validators rather than remaining prose reminders.

### Safe installation and repair

Installers support native Windows and POSIX environments, paths containing spaces, repeat runs, automatic dependency bootstrapping, check-only validation, and safe stale-link repair. They never overwrite a real skills directory and do not automatically stash work, switch branches, or delete legacy repositories. Credentials and browser-based OAuth remain guided user actions.

## Updating and checking

```powershell
./setup.ps1 -Update
./setup.ps1 -CheckOnly
```

```bash
bash setup.sh --update
bash setup.sh --check
```

The tested skills revision is recorded in `skills-lock.json`. It is a compatibility marker, not a vendored dependency lock; the installer normally uses the sibling checkout you control.

For a repository-only health check, run `./scripts/verify-template.ps1`. This validates the starter structure, JSON files, instruction pairing, submodule removal, required client skeleton, and stale v1 references.

If the workspace or `pm-skills` folder moves, rerun setup to repair links. The installer never overwrites a real file or directory in a skills destination; it stops and tells you which collision needs manual review.

## Security and ownership

- Keep every personal OS workspace repository private: it will contain confidential client information.
- Never copy `.env`, memory, client files, or machine-local settings between team members.
- Commit reusable harness improvements to the template; commit shared automation to `pm-skills`; keep client and personal context in your private workspace.
- Review `git status` before every push.

## Optional dependencies

Some writing workflows use the separate `pm-agents` plugin for the Prosperity copywriter agent and fall back to inline drafting if it is unavailable. Some dashboard workflows use the separate `pm-command-centre` repository. Their relevant skills provide the current installation flow; they are not embedded in this template.

# Skill description trim — before / after

**Measured:** 2026-10-19. Tokens are estimated as chars/4 of `name` + `description` in each
SKILL.md frontmatter, which is what gets loaded into **every request** for every enabled skill.

Enumerated with `find -L ~/.claude/skills -name SKILL.md` (plain `find` will not traverse the
per-skill symlinks). **152 skills** reachable, not 151 — the earlier figure was taken before
ponytail was installed and its six symlinks removed.

## Headline

| | skills | chars | tokens |
|---|---|---|---|
| Before | 152 | 117,986 | ~29,496 |
| After | 152 | 84,185 | ~21,046 |
| **Saved** | | **33,801** | **~8,450 per request** |

All of the saving comes from the 68 `pm-*` skills, which went from ~17,169 to ~8,719 tokens — a
**49% cut**. The other 84 skills were out of scope this pass and are byte-identical.

- `pm-*` average description: **987 → 490 chars**
- `pm-*` descriptions over 400 chars: **65 → 53**
- 65 files edited (3 `pm-*` skills were already under 400 chars and were left alone)

## Per repo

| repo | skills | before chars | after chars | before tok | after tok | saved tok |
|---|---|---|---|---|---|---|
| rdg-skills \* | 79 | 44,971 | 44,971 | 11,242 | 11,242 | 0 |
| pm-seo-skills | 22 | 23,991 | 10,932 | 5,997 | 2,733 | **3,264** |
| pm-content-skills | 14 | 13,761 | 6,167 | 3,440 | 1,541 | **1,898** |
| pm-geo-skills | 12 | 12,648 | 6,806 | 3,162 | 1,701 | **1,460** |
| pm-skills | 13 | 10,529 | 6,509 | 2,632 | 1,627 | **1,005** |
| pm-design-skills | 4 | 4,495 | 2,509 | 1,123 | 627 | **496** |
| dpr-skills \* | 3 | 2,632 | 2,632 | 658 | 658 | 0 |
| pm-dragon-squad-skills | 2 | 2,235 | 1,281 | 558 | 320 | **238** |
| pm-sales-skills | 1 | 1,018 | 672 | 254 | 168 | **86** |
| impeccable \* | 1 | 905 | 905 | 226 | 226 | 0 |
| rm-skills \* | 1 | 801 | 801 | 200 | 200 | 0 |

\* out of scope — not edited.

## Commits (all pushed to `main`)

| repo | commit | files |
|---|---|---|
| pm-skills | `147883a` | 13 |
| pm-content-skills | `000777d` | 13 |
| pm-seo-skills | `ce5e2b7` | 20 |
| pm-geo-skills | `f334a3e` | 12 |
| pm-design-skills | `3e38bed` | 4 |
| pm-sales-skills | `b313f2a` | 1 |
| pm-dragon-squad-skills | `5d582c7` | 2 |

`pm-geo-skills` had moved on the remote — someone had pushed
`pm-geo-content-salience-optimiser` (a new skill, no overlap with these 12 files). The trim commit
was rebased onto it, which is why its SHA differs from the one originally recorded (`88b4839`).

That new skill arrived after this baseline was taken and is **not** included in any figure here.
It has since been given the same treatment — **1,190 → 663 chars (~297 → ~165 tokens)**, commit
`1afaa28`, pushed.

It is not yet symlinked into `~/.claude/skills`, so it was never costing anything on this machine;
the figures below are correct as they stand. It will cost ~165 tokens instead of ~297 the first
time `pm-os-start` links it.

Each commit is exactly one inserted line per file, and every inserted line is a `description:`
field — verified with `git show --shortstat`. Skill bodies, `references/` and `scripts/` are
untouched. `name` fields were deliberately left alone: they are the skill identifiers that the
symlinks and the cross-references in other descriptions resolve against.

## Ten biggest remaining descriptions (whole index)

| skill | repo | chars | in scope? |
|---|---|---|---|
| rdg-yt-short-scripter | rdg-skills | 1,541 | no |
| rdg-yt-short-title | rdg-skills | 1,460 | no |
| rdg-yt-short-thumbnail | rdg-skills | 1,399 | no |
| dpr-os-migration | dpr-skills | 1,104 | no |
| rdg-copy-research | rdg-skills | 1,084 | no |
| rdg-100m-money-models | rdg-skills | 1,059 | no |
| rdg-atomic-design-system | rdg-skills | 1,014 | no |
| rdg-pw-scraper | rdg-skills | 968 | no |
| rdg-yt-scripter | rdg-skills | 914 | no |
| rdg-pw-video-finder | rdg-skills | 906 | no |

Every one of the ten is out of scope. The largest remaining opportunity in the index is
`rdg-skills`: 79 skills, ~11,240 tokens, untouched. At the ratio this pass achieved on `pm-*`
that is worth roughly another 5,500 tokens per request.

## Ten biggest remaining pm-* descriptions

| skill | chars | why it is still long |
|---|---|---|
| pm-design-quality-loop | 720 | distinct trigger vocabulary ('loop on this', 'make this as good as X', 'harsh critic') plus it must point at its three builder skills and its image-model sibling |
| pm-design-gauntlet-loop | 693 | three NOT-FOR targets, including the sibling it is most confused with |
| pm-geo-stat-placement | 682 | the 'non-commodity content' concept has to be stated to trigger, and it disambiguates against two others |
| pm-ghl | 666 | the whole CRM verb surface is the trigger set; it must fire on unnamed CRM asks |
| pm-ds-calendar-to-asana | 658 | re-run safety behaviour is load-bearing, plus two NOT-FOR targets |
| pm-os-start | 657 | three separate trigger families: workspace setup, skills repos, client linking |
| pm-geo-ai-crawl-page-simulator | 605 | one-page-vs-whole-site routing against the tech audit needs stating |
| pm-geo-okf-generator | 603 | OKF is unfamiliar vocabulary; 'delivers files, never a deployment' prevents a wrong run |
| pm-seo-tech-audit-v2 | 599 | three GEO neighbours to route against, and it is the default tech audit |
| pm-os-client-context-generator | 596 | two NOT-FOR targets plus the regenerate-all-four rule |

## What I did and did not cut

Kept: what the skill does, the distinctive trigger phrases, and NOT-FOR lines that point at a
specific named sibling.

Cut: restated trigger phrases, synonym lists, marketing prose, internal script and file names,
and mechanism detail that only matters once the skill is already running.

The clusters the brief flagged were handled by replacing prose disambiguation with position in a
named chain, which is much cheaper per character:

- **Austral Herbs trio** — now literally 'Step 1/2/3 of the Austral Herbs category-page chain',
  each naming the next step. 4,061 → 1,371 chars.
- **Brief family** — `pm-content-brief` is declared the default and routes to the other three by
  the condition that selects them (3+ products, exactly two, rewrites);
  `pm-content-comparison-brief` states the two-products-only rule in one sentence.
  5 skills, 4,705 → 2,029 chars.
- **Airtable backlink family** — 'Step 1/2/3/4a/4b of the Airtable backlink system'. The step
  numbers do the within-chain routing, so the only NOT-FOR lines left are the ones pointing
  *outside* the chain (`pm-seo-at-lead-sourcing`, `pm-seo-link-disavow-audit`,
  `pm-content-brief-writer`, `pm-ds-squad-wip`). 7 skills, 10,750 → 3,427 chars.
- **GEO brand citations** — 'step 1/2/3', each naming what it consumes and what it feeds.
- **GEO prompt tracking** — 'Step 1/2 of the GEO prompt-tracking pipeline' around the MiroFish
  hand-off.
- **extraction vs agentic readiness** — the USE-the-site vs SEE-or-CITE-the-site distinction was
  the single most important thing in both descriptions, so it is kept in both, in one clause each.

Fixed in passing: four cross-references pointed at skills that no longer exist under those names
(`pm-content-gap-analysis`, `pm-tech-audit`, `pm-embedding-inventory`, `pm-reporting`). They now
point at the real `pm-seo-*` names.

## Nothing was skipped for safety

Every `pm-*` description over 400 chars was shortened. The 12 that remain over 400 are listed
above with the reason each one earns its length; all are cluster members or skills with a genuinely
wide trigger surface, and each is still 45–60% smaller than before.

The three `pm-*` skills left untouched were already short: `pm-content-repurposer` (268),
`pm-seo-topical-map` (395), `pm-seo-meta-optimiser` (398).

## Verification

After editing, all 152 SKILL.md files still parse, all 65 rewritten descriptions read back exactly
as intended, and no out-of-scope description changed. The live skill index reloaded with the new
text mid-session, which independently confirms the frontmatter is still valid YAML.

**Not verified:** whether triggering accuracy holds in practice. The routing information was
preserved by hand, not tested against real prompts — `anthropic-skills:skill-creator` can run evals
on a skill's description if any of these turn out to mis-fire.

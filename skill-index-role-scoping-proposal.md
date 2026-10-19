# Role-scoping the skill index — proposal

**Status:** proposal only. Nothing in here is implemented.
**Measured:** 2026-10-19, after the description trim described in `skill-description-trim-measurement.md`.

## Why this is the next lever

Every enabled skill puts its `name` + `description` into **every single request**, whether or not
it is used. It is the one cost in the workspace that scales with how many skills exist rather than
with what anyone does.

Two levers exist, and they stack:

1. **Shorten each description** — done. 152 skills: ~29,500 → ~21,050 tokens per request.
2. **Show fewer descriptions per person** — this proposal. A content writer currently pays for
   79 rdg-* skills, the GEO citation pipeline and the GoHighLevel CRM on every message.

Lever 2 is worth considerably more than lever 1, because most people need well under a fifth of
the index.

## What each role actually needs

Costs are `name + description` chars / 4, measured against the trimmed descriptions now in the
repos. "Pre-trim" shows what the same basket would have cost before this pass, so the two levers
are separable.

| role index | skills | chars | tokens now | tokens pre-trim | trim saving |
|---|---|---|---|---|---|
| Core (everyone) | 4 | 1,912 | ~478 | ~810 | ~332 |
| Content | 18 | 8,232 | ~2,058 | ~4,309 | ~2,251 |
| SEO | 30 | 14,920 | ~3,730 | ~7,897 | ~4,167 |
| GEO | 22 | 11,866 | ~2,966 | ~5,451 | ~2,485 |
| Link building (optional split) | 12 | 6,027 | ~1,506 | ~3,800 | ~2,293 |
| Richard — all pm-* | 68 | 34,876 | ~8,719 | ~17,169 | ~8,450 |
| Richard — everything installed today | 152 | 84,185 | ~21,046 | ~29,496 | ~8,450 |

Against today's full index (~21,050 tokens per request):

| role | share of the index they need | saving per request |
|---|---|---|
| Content | 10% | ~18,990 tokens |
| SEO | 18% | ~17,320 tokens |
| GEO | 14% | ~18,080 tokens |

A teammate on one discipline is carrying roughly **17–19k tokens of irrelevant skill index on
every message they send**. That is the finding.

## The baskets

**Core — everyone, 4 skills (~478 tok)**
`pm-os-start`, `pm-os-end`, `pm-os-search`, `pm-os-codify`

The workspace spine: open a session on a client, find internal knowledge, file a document, close
out. Nobody can work without these.

**Content — 18 skills (~2,058 tok)**
Core, plus the brief family (`pm-content-brief`, `-brief-writer`, `-comparison-brief`,
`-listicle-brief`, `-optimise-brief`), `pm-content-qa`, `pm-content-copywriter`,
`pm-content-gdoc-brief-formatter`, `pm-content-repurposer`, the Austral Herbs trio
(`pm-ah-generate-brief`, `pm-ah-write-content`, `pm-ah-qa-content`), `pm-seo-meta-optimiser`,
`pm-os-client-context-generator`.

`pm-seo-meta-optimiser` is in the content basket on purpose — titles, H1s and meta descriptions
are written by whoever writes the page.

**SEO — 30 skills (~3,730 tok)**
Core, all 22 `pm-seo-*`, plus `pm-content-brief`, `pm-content-brief-writer` and `pm-content-qa`
(an SEO lead commissions and checks content), plus `pm-geo-ai-extraction-audit` (routinely paired
with the tech audit).

This is the biggest basket, and the 7-skill Airtable backlink chain is most of the excess — see
the optional split below.

**GEO — 22 skills (~2,966 tok)**
Core, all 12 `pm-geo-*`, plus the technical skills GEO work leans on —
`pm-seo-tech-audit-v2`, `pm-seo-schema-optimisation`, `pm-seo-schema-scraper`,
`pm-seo-metehan-query-fan-out`, `pm-seo-embedding-inventory` — and `pm-content-optimise-brief`,
since GEO findings usually land as a page rewrite.

**Link building — optional 12-skill split (~1,506 tok)**
Core, the six `pm-seo-at-*` pipeline skills, `pm-seo-at-update-links-live` and
`pm-seo-link-disavow-audit`. If outreach is a distinct seat, this is the cheapest basket in the
workspace and pulling it out of the SEO basket takes SEO from ~3,730 to roughly ~2,400 tokens.

**Richard — 68 pm-* skills (~8,719 tok)**
He runs the agency and the ops skills (`pm-ds-*`, `pm-ghl`, `pm-os-ai-team-memo`,
`pm-os-onboard*`, `pm-os-new-project`, `pm-os-install-command-centre`) that nobody else triggers.
Scoping buys him the least — but he is also the one person for whom "everything" is the right
answer, so he should be the exception, not the template.

## What the other families cost

The untouched families — 84 skills across `rdg-*` (79), `dpr-*` (3), `rm-*` (1) and `impeccable`
(1) — are **49,309 chars, ~12,327 tokens per request**, 59% of today's index.

Not one of them is in any agency role basket. They are Richard's personal and Digital-PR surfaces.
For a content, SEO or GEO teammate this is pure overhead, and it is the single largest line item
in the whole measurement. Two things follow:

- Role scoping removes all of it for everyone except Richard and the DPR team, with no editing at
  all. That is most of the 17–19k saving above.
- `rdg-skills` is also where the longest surviving descriptions live (the top nine remaining are
  all `rdg-*`). If those 79 descriptions were trimmed at the same ratio this pass achieved on
  `pm-*` (49%), it would take ~11,240 tokens down to roughly ~5,700 — worth about **5,500 tokens
  per request to Richard himself**, who carries the full index. That is a separate, self-contained
  piece of work.

## How it could be done (not implemented)

The mechanism mostly exists. Skills are per-skill symlinks in `~/.claude/skills`, so a role index
is just a different set of symlinks — nothing needs to move or be copied.

1. **Role manifests in `pm-skills/_shared/`** — one small file per role listing its skill names,
   so the baskets are reviewable and version-controlled rather than living in someone's head.
2. **`pm-os-onboard` already asks for discipline** (SEO/GEO, Content or DPR) and offers to install
   what that discipline needs. Today that choice selects *repositories*; it would select the
   *manifest* instead. One question, already being asked.
3. **`pm-os-start` reconciles** — link what the role manifest lists, remove symlinks that are not
   in it. This is the same install-and-repair loop it already runs, and it makes the index
   self-correcting after a skills-repo update.
4. **An escape hatch** — `pm-os-start --all` or an explicit "I need the GEO skills too" for the
   person who crosses disciplines for a week. The cost of a wrong basket should be one command,
   not a support request.

Worth deciding before building: whether a role is a property of the **person** (set once at
onboarding) or of the **workspace folder** (so opening a client repo brings that client's skills).
Per-person is simpler and matches how `~/.claude/skills` already works. Per-folder is more precise
and would let, say, Austral Herbs load its trio only when someone is actually in that repo — but
nothing in the current setup supports it, so it would be new machinery.

## Recommendation

Do the role manifests. Content, SEO and GEO each need 10–18% of the index, the saving is
17–19k tokens per request per person, the symlink mechanism and the onboarding question both
already exist, and no skill content has to change for it to work.

Then trim the `rdg-*` descriptions — a second ~5,500 tokens per request, for Richard specifically.

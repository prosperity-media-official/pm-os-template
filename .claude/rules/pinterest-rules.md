---
paths:
  - "clients/*/pinterest/**"
---

# Pinterest rules

Use `pinterest/<YYYY-MM>/<landing-page-slug>/` with `images/`, `metadata/`, `prompts/`, and `summary.json`.

- Derive the slug from the landing page URL's final path segment.
- Generate the standard benefit, question, how-to, and listicle angles unless a client rule overrides the campaign.
- Store upload copy in metadata JSON: title, description, hashtags, and alt text.
- Store brand context, landing-page context, variants, and generation stats in `summary.json`.
- Strip embedded metadata with the current `pm-generate-pinterest` utility before an image leaves the workspace. This removes metadata triggers but does not guarantee an AI classifier will not identify generated imagery.
- Store Google Sheet and Drive IDs only in the relevant client's instructions or private configuration, never in this template.

---
paths:
  - "clients/*/seo/**"
---

# SEO rules

File keyword research, content strategy, gaps, and content plans in `seo/content/`; technical audits, indexation, crawls, Core Web Vitals, redirects, and classic search schema work in `seo/technical/`; one-off work in `seo/ad-hoc/`.

- Prefix every deliverable with `YYYY-MM-DD-`.
- Monthly performance reporting belongs in `reporting/`, not `seo/`.
- General discovery and call preparation belong in `research/`.
- Content briefs for writers belong in `content/`.
- Measure title-tag fit by rendered pixel width, not a fixed character count.
- Verify suspected redirects with `curl -sIL` before recommending a redirect.
- Maintain a dated live-sitemap URL reference in `seo/content/`; refresh after 30 days.
- For sitemap audits, cross-reference the live sitemap with a current crawl and check errors, redirects, duplicates, overlap, and missing indexable pages.

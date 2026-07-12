---
paths:
  - "clients/*/content/**"
---

# Content rules

Use `<YYYY>/<NN-Month>/<keyword-slug>/` and the numbered stages `1-brief/`, `2-article/`, `3-qa/`, and `4-final/`. Each stage separates `md/` and `docx/`; raw handover material stays under `source/md/` or `source/docx/`.

- Never leave a file at the keyword-folder root.
- Name files `<YYYY-MM-DD>-<keyword-slug>-<artifact>.{md,docx}`.
- Final default outputs are Markdown and DOCX. HTML and Google upload are opt-in.
- QA writes a new `3-qa` artifact and never overwrites `2-article`.
- Approved or codified work goes to `4-final`; keep earlier stages as provenance.
- Keep paired Markdown and DOCX files synchronized.
- Never name a competitor or another client in ordinary client content. Comparison/listicle work is the explicit exception when the brief requires named comparison.
- Never disclose competitor-research mechanics in published copy.
- Every article ends with a clear, actionable CTA before any FAQ.
- Strip leaked editorial notes, TODOs, and verification instructions from client-facing output.
- Avoid horizontal rules and excessive em dashes in published body copy.
- All brief URLs are absolute. Verify internal links against a live sitemap refreshed within 30 days.

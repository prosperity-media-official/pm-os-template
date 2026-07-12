---
paths:
  - "clients/*/reporting/**"
---

# Reporting rules

Only the shared `<client>_monthly_report_prompt.md` may stay at the reporting root. Each report uses the month it was created:

```text
reporting/YYYY-MM/
├── deliverable/  <- final client-facing report email (.md)
└── assets/       <- Looker PDFs, CSVs, screenshots, and raw inputs
```

Create both subfolders at the start of a report. Move supplied raw data into `assets/`. Never leave report deliverables or assets loose in `reporting/`.

# Output folder rule

Applies to every custom output that no other rule or skill already gives a fixed layout: reports, analyses, audits, exports, data pulls, one-off builds. Where a skill or a domain rule in this folder dictates the shape, follow that instead.

1. **One folder per output**, named for the job: `YYYY-MM-DD-<slug>/`, inside the folder routing already sends it to (eg `reporting/2026-10/`). Never drop files into another output's folder.
2. **One front-door file at the folder root**, named after the folder: `YYYY-MM-DD-<slug>.md`. It says exactly what was done: the ask, the answer or findings, sources, method, caveats, and a `## Files` list naming every subfolder and what is in it. It is the only file at the root.
3. **Everything else goes in a named subfolder:**
   - `raw/`: untouched inputs (exports, CSVs, scrapes), copied in so the work can be rerun
   - `data/`: intermediate or machine output (JSON, model judgments, cleaned tables)
   - `scripts/`: code that produced it, with paths relative to the output folder
   - `assets/`: images, charts, rendered HTML, PDFs, decks
4. **Name the front-door file in the reply**, so the reader knows exactly which file to open.

Example:

```text
reporting/2026-10/2026-10-21-1300-cluster-targets/
├── 2026-10-21-1300-cluster-targets.md   <- open this
├── raw/gsc-content-decay-clicks.csv
├── data/jev-decay-classification.json
└── scripts/jev-decay.py
```

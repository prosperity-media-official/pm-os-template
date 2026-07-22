#!/usr/bin/env python3
"""Shim — canonical pm_search lives in pm-skills/_shared/scripts/ (installed via /pm-start)."""
import os
import runpy
import sys
from pathlib import Path

os.environ.setdefault("PM_WS_ROOT", str(Path(__file__).resolve().parents[2]))
_here = Path(__file__).resolve()
for cand in (Path.home() / ".claude/skills/_shared/scripts" / _here.name,
             _here.parents[3] / "pm-skills/_shared/scripts" / _here.name):
    if cand.exists():
        sys.argv[0] = str(cand)
        runpy.run_path(str(cand), run_name="__main__")
        break
else:
    sys.exit(f"{_here.name}: canonical script not found — run /pm-start to install pm-skills")

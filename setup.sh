#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SKILLS_DIR="${PM_SKILLS_DIR:-$(dirname "$WORKSPACE_ROOT")/pm-skills}"
SKILLS_REPO="${PM_SKILLS_REPO:-https://github.com/prosperity-media-official/pm-skills.git}"
UPDATE=0
CHECK_ONLY=0
SKIP_DEPENDENCIES=0

usage() {
  printf 'Usage: bash setup.sh [--update] [--check] [--skip-dependencies] [--skills-dir PATH]\n'
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --update) UPDATE=1; shift ;;
    --check) CHECK_ONLY=1; shift ;;
    --skip-dependencies) SKIP_DEPENDENCIES=1; shift ;;
    --skills-dir) SKILLS_DIR="${2:?--skills-dir requires a path}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
done

if ! command -v git >/dev/null 2>&1; then
  [[ "$SKIP_DEPENDENCIES" -eq 1 ]] && { printf 'ERROR: Git is required. Rerun without --skip-dependencies to install it automatically.\n' >&2; exit 1; }
  if [[ "$CHECK_ONLY" -eq 1 ]]; then bash "$WORKSPACE_ROOT/scripts/bootstrap-dependencies.sh" "$SKILLS_DIR" --check
  else bash "$WORKSPACE_ROOT/scripts/bootstrap-dependencies.sh" "$SKILLS_DIR"; fi
fi

for required in AGENTS.md CLAUDE.md .pm/config.json team agency knowledge; do
  [[ -e "$WORKSPACE_ROOT/$required" ]] || { printf 'ERROR: Workspace is missing required path: %s\n' "$required" >&2; exit 1; }
done

if [[ ! -d "$SKILLS_DIR/.git" ]]; then
  if [[ "$CHECK_ONLY" -eq 1 ]]; then
    printf 'ERROR: pm-skills is missing at %s\n' "$SKILLS_DIR" >&2
    exit 1
  fi
  printf 'Cloning pm-skills to %s\n' "$SKILLS_DIR"
  git clone "$SKILLS_REPO" "$SKILLS_DIR"
elif [[ "$UPDATE" -eq 1 ]]; then
  if [[ -n "$(git -C "$SKILLS_DIR" status --porcelain)" ]]; then
    printf 'WARNING: pm-skills has local changes; skipping update to preserve them.\n' >&2
  else
    git -C "$SKILLS_DIR" pull --ff-only
  fi
fi

if [[ "$SKIP_DEPENDENCIES" -eq 0 ]]; then
  if [[ "$CHECK_ONLY" -eq 1 ]]; then bash "$WORKSPACE_ROOT/scripts/bootstrap-dependencies.sh" "$SKILLS_DIR" --check
  else bash "$WORKSPACE_ROOT/scripts/bootstrap-dependencies.sh" "$SKILLS_DIR"; fi
fi

SKILLS_DIR="$(cd "$SKILLS_DIR" && pwd -P)"
SKILL_SOURCES=()
while IFS= read -r source; do
  SKILL_SOURCES+=("$source")
done < <(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d -name 'pm-*' -exec test -f '{}/SKILL.md' ';' -print | sort)
[[ ${#SKILL_SOURCES[@]} -gt 0 ]] || { printf 'ERROR: No valid pm-* skills found in %s\n' "$SKILLS_DIR" >&2; exit 1; }
[[ -d "$SKILLS_DIR/_shared" ]] || { printf 'ERROR: Required _shared directory is missing.\n' >&2; exit 1; }
SKILL_SOURCES+=("$SKILLS_DIR/_shared")

install_link() {
  local source="$1" destination="$2"
  if [[ -L "$destination" ]]; then
    if [[ "$CHECK_ONLY" -eq 0 ]]; then rm "$destination"; fi
  elif [[ -e "$destination" ]]; then
    printf 'ERROR: Refusing to overwrite real path: %s\n' "$destination" >&2
    return 1
  fi
  if [[ "$CHECK_ONLY" -eq 0 ]]; then
    ln -s "$source" "$destination"
  fi
}

for runtime in .claude .codex; do
  target_root="$HOME/$runtime/skills"
  if [[ "$CHECK_ONLY" -eq 1 ]]; then
    [[ -d "$target_root" ]] || { printf 'ERROR: Missing skills directory: %s\n' "$target_root" >&2; exit 1; }
  else
    mkdir -p "$target_root"
  fi
  for source in "${SKILL_SOURCES[@]}"; do
    name="$(basename "$source")"
    destination="$target_root/$name"
    if [[ "$CHECK_ONLY" -eq 1 ]]; then
      [[ -L "$destination" ]] || { printf 'ERROR: Installed target is missing or not a symlink: %s\n' "$destination" >&2; exit 1; }
      [[ "$(readlink "$destination")" == "$source" ]] || { printf 'ERROR: Installed target points elsewhere: %s\n' "$destination" >&2; exit 1; }
      [[ -e "$destination/SKILL.md" || "$name" == '_shared' ]] || { printf 'ERROR: Invalid installed skill: %s\n' "$destination" >&2; exit 1; }
    else
      install_link "$source" "$destination"
    fi
  done
done

if [[ "$CHECK_ONLY" -eq 0 ]]; then
  printf '\nInstalled %s entries into both ~/.claude/skills and ~/.codex/skills.\n' "${#SKILL_SOURCES[@]}"
  printf 'Workspace: %s\nSkills:    %s\n' "$WORKSPACE_ROOT" "$SKILLS_DIR"
  printf 'Restart Codex/Claude Code, then run /pm-start and /pm-onboard.\n'
else
  printf 'OK: %s skill entries verified in both runtimes.\n' "${#SKILL_SOURCES[@]}"
fi

for runtime in git gh python3 node npm bun bash; do
  if command -v "$runtime" >/dev/null 2>&1; then
    printf '  optional runtime: %-7s found\n' "$runtime"
  else
    printf '  optional runtime: %-7s not found (some skills may need it)\n' "$runtime"
  fi
done

# Build the knowledge index (Phase 0+1 default — catalog + local search db).
if [[ "$CHECK_ONLY" -eq 0 ]] && command -v python3 >/dev/null 2>&1 && [[ -f "$WORKSPACE_ROOT/.claude/lib/pm_index.py" ]]; then
  printf '\nBuilding knowledge index (incremental; first run can take a few minutes)...\n'
  ( cd "$WORKSPACE_ROOT" \
      && python3 .claude/lib/pm_index.py build \
      && python3 .claude/lib/pm_index.py sync-indexes ) \
    || printf 'WARN: knowledge index build failed — run manually: python3 .claude/lib/pm_index.py build\n'
fi

# Knowledge graph (graphify via pm_graph.py): report only. The first build takes 5-60 min and
# bills the Claude plan (claude -p, Haiku), so it is a deliberate step, not part of setup.
if [[ "$CHECK_ONLY" -eq 0 ]] && command -v python3 >/dev/null 2>&1 && [[ -f "$WORKSPACE_ROOT/.claude/lib/pm_graph.py" ]]; then
  printf '\nKnowledge graph status (build later with: python3 .claude/lib/pm_graph.py build):\n'
  ( cd "$WORKSPACE_ROOT" && python3 .claude/lib/pm_graph.py status ) \
    || printf 'WARN: pm_graph status failed — graphs are optional; see AGENTS.md "Finding information"\n'
fi

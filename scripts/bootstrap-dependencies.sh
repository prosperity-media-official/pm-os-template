#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="${1:?Usage: bootstrap-dependencies.sh SKILLS_DIR [--check]}"
CHECK_ONLY="${2:-}"

as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

install_system_tools() {
  if command -v brew >/dev/null 2>&1; then
    brew install git python node gh
  elif command -v apt-get >/dev/null 2>&1; then
    as_root apt-get update
    as_root apt-get install -y git python3 python3-pip nodejs npm
  elif command -v dnf >/dev/null 2>&1; then
    as_root dnf install -y git python3 python3-pip nodejs npm
  elif command -v yum >/dev/null 2>&1; then
    as_root yum install -y git python3 python3-pip nodejs npm
  elif command -v pacman >/dev/null 2>&1; then
    as_root pacman -Sy --needed --noconfirm git python python-pip nodejs npm
  else
    printf 'ERROR: No supported package manager found. Ask the AI assistant to install Git, Python 3, Node.js LTS and npm.\n' >&2
    exit 1
  fi
}

missing_core=0
for tool in git python3 node npm; do
  command -v "$tool" >/dev/null 2>&1 || missing_core=1
done
if [[ "$missing_core" -eq 1 ]]; then
  [[ "$CHECK_ONLY" == '--check' ]] && { printf 'ERROR: Missing one or more core tools: git, python3, node, npm.\n' >&2; exit 1; }
  install_system_tools
fi

if ! command -v bun >/dev/null 2>&1; then
  [[ "$CHECK_ONLY" == '--check' ]] && { printf 'ERROR: Bun is missing.\n' >&2; exit 1; }
  printf 'Installing Bun with npm...\n'
  npm install --global bun || as_root npm install --global bun
fi

if ! command -v gh >/dev/null 2>&1; then
  if [[ "$CHECK_ONLY" == '--check' ]]; then
    printf 'WARNING: GitHub CLI is not installed; Git authentication may require a browser or credential helper.\n' >&2
  elif command -v brew >/dev/null 2>&1; then
    brew install gh
  else
    printf 'WARNING: GitHub CLI was not available from the detected package manager. Git can still use its credential helper.\n' >&2
  fi
fi

python_packages=(openpyxl python-docx requests lxml)
python_imports=(openpyxl docx requests lxml)
for i in "${!python_packages[@]}"; do
  if ! python3 -c "import ${python_imports[$i]}" >/dev/null 2>&1; then
    [[ "$CHECK_ONLY" == '--check' ]] && { printf 'ERROR: Missing Python package: %s\n' "${python_packages[$i]}" >&2; exit 1; }
    printf 'Installing Python package %s...\n' "${python_packages[$i]}"
    python3 -m pip install --user --disable-pip-version-check "${python_packages[$i]}" || \
      python3 -m pip install --user --break-system-packages --disable-pip-version-check "${python_packages[$i]}"
  fi
done

if [[ -d "$SKILLS_DIR" ]]; then
  node_projects=(pm-aimode-journey/Tools pm-schema-optimisation/scripts)
  for relative in "${node_projects[@]}"; do
    project="$SKILLS_DIR/$relative"
    [[ -f "$project/package.json" ]] || continue
    if ! (cd "$project" && npm ls --depth=0 --silent >/dev/null 2>&1); then
      [[ "$CHECK_ONLY" == '--check' ]] && { printf 'ERROR: Missing Node dependencies in %s.\n' "$relative" >&2; exit 1; }
      printf 'Installing Node dependencies in %s...\n' "$relative"
      if [[ -f "$project/package-lock.json" ]]; then (cd "$project" && npm ci --no-audit --no-fund)
      else (cd "$project" && npm install --no-audit --no-fund); fi
    fi
  done
fi

credential_keys=(AHREFS_API_KEY APIFY_API_TOKEN DATAFORSEO_LOGIN DATAFORSEO_PASSWORD FIRECRAWL_API_KEY GEMINI_API_KEY GOOGLE_API_KEY HARVEST_PERSONAL_ACCESS_TOKEN OPENAI_API_KEY SEOGETS_API_KEY THRUUU_API_KEY)
credential_gaps=()
env_file="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/.env"
for key in "${credential_keys[@]}"; do
  [[ -n "${!key:-}" ]] && continue
  [[ -f "$env_file" ]] && grep -Eq "^${key}=.+$" "$env_file" && continue
  credential_gaps+=("$key")
done
if [[ ${#credential_gaps[@]} -gt 0 ]]; then
  printf 'Optional service credentials not configured (only needed by related skills): %s\n' "${credential_gaps[*]}"
  if [[ ! -f "$env_file" && "$CHECK_ONLY" != '--check' ]]; then
    cp "$(dirname "$env_file")/.env.example" "$env_file"
    printf 'Created %s from .env.example; add credentials only when a workflow needs them.\n' "$env_file"
  fi
fi

printf 'Dependency bootstrap: core runtimes and package dependencies are ready.\n'

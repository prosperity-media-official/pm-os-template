[CmdletBinding()]
param(
    [string]$SkillsDir = $env:PM_SKILLS_DIR,
    [switch]$Update,
    [switch]$CheckOnly,
    [switch]$SkipDependencies
)

$ErrorActionPreference = 'Stop'
$WorkspaceRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
if (-not $SkillsDir) {
    $SkillsDir = Join-Path (Split-Path -Parent $WorkspaceRoot) 'pm-skills'
}
$SkillsDir = [System.IO.Path]::GetFullPath($SkillsDir)
$SkillsRepo = if ($env:PM_SKILLS_REPO) { $env:PM_SKILLS_REPO } else { 'https://github.com/prosperity-media-official/pm-skills.git' }

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if ($SkipDependencies) { throw 'Git is required. Rerun without -SkipDependencies to install it automatically.' }
    & (Join-Path $WorkspaceRoot 'scripts\bootstrap-dependencies.ps1') -SkillsDir $SkillsDir -CheckOnly:$CheckOnly
}

foreach ($required in @('AGENTS.md', 'CLAUDE.md', 'clients', 'team', 'agency', 'knowledge')) {
    if (-not (Test-Path -LiteralPath (Join-Path $WorkspaceRoot $required))) {
        throw "Workspace is missing required path: $required"
    }
}

if (-not (Test-Path -LiteralPath (Join-Path $SkillsDir '.git'))) {
    if ($CheckOnly) { throw "pm-skills is missing at $SkillsDir" }
    Write-Host "Cloning pm-skills to $SkillsDir"
    & git clone $SkillsRepo $SkillsDir
    if ($LASTEXITCODE -ne 0) { throw 'Unable to clone pm-skills. Confirm repository access and Git authentication.' }
} elseif ($Update) {
    $dirty = & git -C $SkillsDir status --porcelain
    if ($dirty) {
        Write-Warning 'pm-skills has local changes; skipping update to preserve them.'
    } else {
        & git -C $SkillsDir pull --ff-only
        if ($LASTEXITCODE -ne 0) { throw 'Unable to update pm-skills with a fast-forward pull.' }
    }
}

if (-not $SkipDependencies) {
    & (Join-Path $WorkspaceRoot 'scripts\bootstrap-dependencies.ps1') -SkillsDir $SkillsDir -CheckOnly:$CheckOnly
}

$skillSources = @(
    Get-ChildItem -LiteralPath $SkillsDir -Directory |
        Where-Object { $_.Name -like 'pm-*' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md')) } |
        Sort-Object Name
)
if ($skillSources.Count -eq 0) { throw "No valid pm-* skills found in $SkillsDir" }
$shared = Get-Item -LiteralPath (Join-Path $SkillsDir '_shared') -ErrorAction SilentlyContinue
if (-not $shared) { throw 'Required pm-skills/_shared directory is missing.' }
$sources = @($skillSources) + @($shared)

function Install-SkillJunction {
    param([System.IO.DirectoryInfo]$Source, [string]$Destination)

    $existing = Get-Item -LiteralPath $Destination -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
            if (-not $CheckOnly) { [System.IO.Directory]::Delete($Destination) }
        } else {
            throw "Refusing to overwrite real path: $Destination"
        }
    }
    if (-not $CheckOnly) {
        New-Item -ItemType Junction -Path $Destination -Target $Source.FullName | Out-Null
    }
}

foreach ($runtime in @('.claude', '.codex')) {
    $targetRoot = Join-Path $HOME "$runtime\skills"
    if ($CheckOnly) {
        if (-not (Test-Path -LiteralPath $targetRoot)) { throw "Missing skills directory: $targetRoot" }
    } else {
        New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
    }
    foreach ($source in $sources) {
        $destination = Join-Path $targetRoot $source.Name
        if ($CheckOnly) {
            $installed = Get-Item -LiteralPath $destination -Force -ErrorAction SilentlyContinue
            if (-not $installed -or -not ($installed.Attributes -band [System.IO.FileAttributes]::ReparsePoint)) {
                throw "Installed target is missing or not a junction/symlink: $destination"
            }
            $actualTarget = [System.IO.Path]::GetFullPath([string]$installed.Target)
            if ($actualTarget.TrimEnd('\') -ne $source.FullName.TrimEnd('\')) {
                throw "Installed target points elsewhere: $destination"
            }
            if ($source.Name -ne '_shared' -and -not (Test-Path -LiteralPath (Join-Path $destination 'SKILL.md'))) {
                throw "Invalid installed skill: $destination"
            }
        } else {
            Install-SkillJunction -Source $source -Destination $destination
        }
    }
}

if ($CheckOnly) {
    Write-Host "OK: $($sources.Count) skill entries verified in both runtimes."
} else {
    Write-Host "`nInstalled $($sources.Count) entries into both ~/.claude/skills and ~/.codex/skills."
    Write-Host "Workspace: $WorkspaceRoot"
    Write-Host "Skills:    $SkillsDir"
    Write-Host 'Restart Codex/Claude Code, then run /pm-start and /pm-onboard.'
}

foreach ($runtime in @('git', 'gh', 'python', 'python3', 'node', 'npm', 'bun', 'bash')) {
    $state = if (Get-Command $runtime -ErrorAction SilentlyContinue) { 'found' } else { 'not found (some skills may need it)' }
    Write-Host ("  optional runtime: {0,-7} {1}" -f $runtime, $state)
}

# Build the knowledge index (Phase 0+1 default — catalog + local search db).
if (-not $CheckOnly) {
    $python = Get-Command python3 -ErrorAction SilentlyContinue
    if (-not $python) { $python = Get-Command python -ErrorAction SilentlyContinue }
    $indexer = Join-Path $WorkspaceRoot '.claude\lib\pm_index.py'
    if ($python -and (Test-Path -LiteralPath $indexer)) {
        Write-Host "`nBuilding knowledge index (incremental; first run can take a few minutes)..."
        Push-Location $WorkspaceRoot
        try {
            & $python.Source $indexer build
            & $python.Source $indexer sync-indexes
        } catch {
            Write-Warning "Knowledge index build failed - run manually: python .claude\lib\pm_index.py build"
        } finally {
            Pop-Location
        }
    }
}

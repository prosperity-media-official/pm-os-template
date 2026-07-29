[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$Self = $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$failures = [System.Collections.Generic.List[string]]::new()

$required = @(
    'AGENTS.md',
    'CLAUDE.md',
    'README.md',
    'setup.ps1',
    'setup.sh',
    'dependencies.json',
    'skills-lock.json',
    'scripts/bootstrap-dependencies.ps1',
    'scripts/bootstrap-dependencies.sh',
    '.claude/rules/frontmatter.md',
    '.claude/rules/sales-rules.md',
    '.pm/config.json',
    '.pm/clients.json',
    'team/_example-team-member/AGENTS.md',
    'knowledge/wiki/_log.md'
)

foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $failures.Add("Missing required path: $path")
    }
}

# v2: client work lives in sibling repositories, never inside this workspace.
if (Test-Path -LiteralPath (Join-Path $Root 'clients')) {
    $failures.Add('A clients/ folder exists. v2 keeps client work in sibling repositories; run /pm-migrate-clients.')
}

$jsonFiles = @('dependencies.json', 'skills-lock.json', '.pm/config.json', '.pm/clients.json', '.obsidian/app.json', '.obsidian/appearance.json', '.obsidian/core-plugins.json', '.obsidian/community-plugins.json')
foreach ($json in $jsonFiles) {
    try { Get-Content -LiteralPath (Join-Path $Root $json) -Raw | ConvertFrom-Json | Out-Null }
    catch { $failures.Add("Invalid JSON: $json") }
}

if (Test-Path -LiteralPath (Join-Path $Root '.gitmodules')) {
    $failures.Add('Legacy .gitmodules still exists; pm-skills must be a sibling repository.')
}

$tracked = & git -C $Root ls-files 2>$null
if ($LASTEXITCODE -eq 0) {
    if ($tracked -contains 'prosperity-skills') { $failures.Add('Legacy prosperity-skills gitlink is still tracked.') }
}

$scanFiles = Get-ChildItem -LiteralPath $Root -Recurse -File -Include *.md,*.ps1,*.sh,*.json |
    Where-Object {
        $_.FullName -ne $Self -and
        $_.FullName -notlike (Join-Path $Root 'prosperity-skills*') -and
        $_.FullName -notlike (Join-Path $Root '.git*')
    }
$stalePattern = 'reapzyau/pm-skills|--recurse-submodules|DD-MM-YYYY|\.prosperity-brain/|pm-brain|Prosperity Brain'
foreach ($file in $scanFiles) {
    $unapproved = Select-String -LiteralPath $file.FullName -Pattern $stalePattern |
        Where-Object { $_.Line -notmatch '(?i)legacy|deprecated|stale' }
    if ($unapproved) {
        $failures.Add("Stale v1 reference: $($file.FullName.Substring($Root.Length + 1))")
    }
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { Write-Error $_ }
    exit 1
}

Write-Host "Template verification passed ($($required.Count) required paths, $($jsonFiles.Count) JSON files, no legacy submodule references)."

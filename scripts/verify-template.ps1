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
    'skills-lock.json',
    '.claude/rules/content-rules.md',
    '.claude/rules/geo-rules.md',
    'clients/_example-client/AGENTS.md',
    'clients/_example-client/CLAUDE.md',
    'clients/_example-client/business/business-context.md',
    'clients/_example-client/business/offer.md',
    'clients/_example-client/business/customer-avatar.md',
    'clients/_example-client/business/tone-of-voice.md',
    'team/_example-team-member/AGENTS.md',
    'knowledge/wiki/_log.md'
)

foreach ($path in $required) {
    if (-not (Test-Path -LiteralPath (Join-Path $Root $path))) {
        $failures.Add("Missing required path: $path")
    }
}

foreach ($json in @('skills-lock.json', '.obsidian/app.json', '.obsidian/appearance.json', '.obsidian/core-plugins.json', '.obsidian/community-plugins.json')) {
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

Write-Host "Template verification passed ($($required.Count) required paths, 5 JSON files, no legacy submodule references)."

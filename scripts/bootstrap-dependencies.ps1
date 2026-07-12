[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$SkillsDir,
    [switch]$CheckOnly
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Manifest = Get-Content -LiteralPath (Join-Path $Root 'dependencies.json') -Raw | ConvertFrom-Json
$missing = [System.Collections.Generic.List[string]]::new()

function Invoke-Probe {
    param([scriptblock]$Command)
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $Command *> $null
        return ($LASTEXITCODE -eq 0)
    } finally {
        $ErrorActionPreference = $previous
    }
}

function Invoke-NativeStep {
    param([scriptblock]$Command, [string]$Label)
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $Command
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $previous
    }
    if ($code -ne 0) { throw "$Label failed with exit code $code." }
}

function Refresh-ProcessPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = @($env:Path, $machine, $user) -join ';'
}

function Install-WingetPackage {
    param([string]$Id, [string]$Label)
    if ($CheckOnly) { $missing.Add($Label); return }
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $winget) { throw "Missing $Label and winget is unavailable. Ask the AI assistant to install $Label, then rerun setup." }
    Write-Host "Installing $Label with winget..."
    Invoke-NativeStep -Label "winget install $Label" -Command {
        & winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity
    }
    Refresh-ProcessPath
}

$toolPackages = [ordered]@{
    git = @('Git.Git', 'Git')
    python = @('Python.Python.3.12', 'Python 3')
    node = @('OpenJS.NodeJS.LTS', 'Node.js LTS')
    bun = @('Oven-sh.Bun', 'Bun')
    gh = @('GitHub.cli', 'GitHub CLI')
}

foreach ($tool in $toolPackages.Keys) {
    $commands = if ($tool -eq 'python') { @('python', 'python3', 'py') } else { @($tool) }
    $found = $commands | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
    if (-not $found) { Install-WingetPackage -Id $toolPackages[$tool][0] -Label $toolPackages[$tool][1] }
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    if ($CheckOnly) { $missing.Add('npm') }
    else { throw 'Node.js was installed but npm is not available. Restart the terminal and rerun setup.' }
}

$python = @('python', 'python3', 'py') | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
if ($python -and -not $CheckOnly) {
    if ($python -eq 'py') { Invoke-Probe { & py -3 -m ensurepip --upgrade } | Out-Null }
    else { Invoke-Probe { & $python -m ensurepip --upgrade } | Out-Null }
}

foreach ($entry in $Manifest.pythonPackages) {
    if (-not $python) { $missing.Add("Python package $($entry.package)"); continue }
    $importName = [string]$entry.import
    $available = if ($python -eq 'py') { Invoke-Probe { & py -3 -c "import $importName" } }
        else { Invoke-Probe { & $python -c "import $importName" } }
    if (-not $available) {
        if ($CheckOnly) { $missing.Add("Python package $($entry.package)"); continue }
        Write-Host "Installing Python package $($entry.package)..."
        if ($python -eq 'py') {
            Invoke-NativeStep -Label "pip install $($entry.package)" -Command { & py -3 -m pip install --user --disable-pip-version-check $entry.package }
        } else {
            Invoke-NativeStep -Label "pip install $($entry.package)" -Command { & $python -m pip install --user --disable-pip-version-check $entry.package }
        }
    }
}

if (Test-Path -LiteralPath $SkillsDir) {
    foreach ($relative in $Manifest.nodeProjects) {
        $project = Join-Path $SkillsDir ($relative -replace '/', [IO.Path]::DirectorySeparatorChar)
        $packageJson = Join-Path $project 'package.json'
        if (-not (Test-Path -LiteralPath $packageJson)) { continue }
        if (-not (Get-Command npm -ErrorAction SilentlyContinue)) { $missing.Add("Node dependencies for $relative"); continue }
        Push-Location $project
        try {
            $nodeReady = Invoke-Probe { & npm ls --depth=0 --silent }
            if (-not $nodeReady) {
                if ($CheckOnly) { $missing.Add("Node dependencies for $relative"); continue }
                Write-Host "Installing Node dependencies in $relative..."
                if (Test-Path -LiteralPath (Join-Path $project 'package-lock.json')) {
                    Invoke-NativeStep -Label "npm ci in $relative" -Command { & npm ci --no-audit --no-fund }
                } else {
                    Invoke-NativeStep -Label "npm install in $relative" -Command { & npm install --no-audit --no-fund }
                }
            }
        } finally { Pop-Location }
    }
}

if ($missing.Count -gt 0) {
    throw "Dependency check failed: $($missing -join ', ')"
}

Write-Host 'Dependency bootstrap: core runtimes and package dependencies are ready.'

$envFile = Join-Path $Root '.env'
$envText = if (Test-Path -LiteralPath $envFile) { Get-Content -LiteralPath $envFile -Raw } else { '' }
$credentialGaps = @(
    foreach ($key in $Manifest.credentialChecks) {
        $value = [Environment]::GetEnvironmentVariable([string]$key)
        $escaped = [regex]::Escape([string]$key)
        if (-not $value -and $envText -notmatch "(?m)^$escaped=.+$") { [string]$key }
    }
)
if ($credentialGaps.Count -gt 0) {
    Write-Host "Optional service credentials not configured (only needed by related skills): $($credentialGaps -join ', ')"
    if (-not (Test-Path -LiteralPath $envFile) -and -not $CheckOnly) {
        Copy-Item -LiteralPath (Join-Path $Root '.env.example') -Destination $envFile
        Write-Host "Created $envFile from .env.example; add credentials only when a workflow needs them."
    }
}

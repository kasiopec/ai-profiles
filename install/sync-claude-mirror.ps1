# sync-claude-mirror.ps1 - copy agents/ and skills/ into .claude/ (full tree)
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Profile,
    [string]$ProfileRoot = "!profiles"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot  = Split-Path -Parent $scriptDir
$profileDir = Join-Path $repoRoot "$ProfileRoot/$Profile"

if (-not (Test-Path -LiteralPath $profileDir)) {
    throw "Profile '$Profile' not found at $profileDir"
}

$claudeAgents = Join-Path $profileDir ".claude/agents"
$claudeSkills = Join-Path $profileDir ".claude/skills"
$canonAgents  = Join-Path $profileDir "agents"
$canonSkills  = Join-Path $profileDir "skills"

# Mirror agents/*.md -> .claude/agents/*.md
if (Test-Path -LiteralPath $canonAgents) {
    if (-not (Test-Path -LiteralPath $claudeAgents)) {
        New-Item -ItemType Directory -Force -Path $claudeAgents | Out-Null
    }
    Get-ChildItem -LiteralPath $canonAgents -Filter *.md -File | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $claudeAgents $_.Name) -Force
        Write-Host "mirrored agent: $($_.Name)"
    }
}

# Mirror skills/<name>/ (entire tree) -> .claude/skills/<name>/
if (Test-Path -LiteralPath $canonSkills) {
    if (-not (Test-Path -LiteralPath $claudeSkills)) {
        New-Item -ItemType Directory -Force -Path $claudeSkills | Out-Null
    }
    Get-ChildItem -LiteralPath $canonSkills -Directory | ForEach-Object {
        $dst = Join-Path $claudeSkills $_.Name
        if (Test-Path -LiteralPath $dst) {
            Remove-Item -LiteralPath $dst -Recurse -Force
        }
        Copy-Item -LiteralPath $_.FullName -Destination $dst -Recurse -Force
        $count = (Get-ChildItem -LiteralPath $dst -Recurse -File).Count
        Write-Host "mirrored skill: $($_.Name)/ ($count files)"
    }
}

Write-Host "Done." -ForegroundColor Green
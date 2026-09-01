# uninstall.ps1 - remove the profile router and optionally the submodule entry
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Profile,
    [string]$SubmodulePath = ".ai/profiles",
    [string]$RouterName = "AGENTS.md",
    [switch]$RemoveSubmodule
)

$ErrorActionPreference = "Stop"

$consumerRoot = (Get-Location).Path
$routerPath = Join-Path $consumerRoot $RouterName

if (Test-Path -LiteralPath $routerPath) {
    $existing = Get-Content -LiteralPath $routerPath -Raw
    if ($existing -match '# AI Assistant Router') {
        Remove-Item -LiteralPath $routerPath -Force
        Write-Host "Removed $routerPath" -ForegroundColor Yellow
    } else {
        Write-Host "Skipped $routerPath - not a router we wrote." -ForegroundColor DarkYellow
    }
} else {
    Write-Host "No router at $routerPath; nothing to remove."
}

if ($RemoveSubmodule) {
    if (Test-Path -LiteralPath ".gitmodules") {
        git submodule deinit -f $SubmodulePath
        git rm -f $SubmodulePath
        git config -f .gitmodules --remove-section "submodule.$SubmodulePath" 2>$null
        Remove-Item -LiteralPath ".gitmodules" -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath ".git/modules/$($SubmodulePath -replace '/','\\')" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Removed submodule entry for $SubmodulePath" -ForegroundColor Yellow
    } else {
        Write-Host ".gitmodules not present; skipping submodule removal."
    }
}
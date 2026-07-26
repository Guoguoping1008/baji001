<#
.SYNOPSIS
  PinForge 部署自动化脚本
#>

$ErrorActionPreference = 'Stop'
$GitHubRepo = 'Guoguoping1008/baji001'
$ProjectName = 'pinforge'

Clear-Host
Write-Host @"
╔════════════════════════════════════════════════╗
║   PinForge B2B Site — Deploy Automation        ║
╚════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Step 1: Verify git
Write-Host "`n═══ Step 1: Verify repo ═══" -ForegroundColor Magenta
$branch = git -C $PSScriptRoot branch --show-current 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "  X Not in git repo" -ForegroundColor Red
    exit 1
}
Write-Host "  + Branch: $branch" -ForegroundColor Green

# Step 2: Check config files
Write-Host "`n═══ Step 2: Verify config files ═══" -ForegroundColor Magenta
$files = @('static.yml', '.github/workflows/deploy.yml', 'wrangler.toml',
           'DEPLOYMENT_GUIDE.md', 'DEPLOY_NOW.md', 'DEPLOY_QUICKSTART.md',
           'deploy-automation.ps1', '_redirects', '_headers')
foreach ($f in $files) {
    $path = Join-Path $PSScriptRoot $f
    if (Test-Path $path) {
        Write-Host "  + $f" -ForegroundColor Green
    } else {
        Write-Host "  X Missing: $f" -ForegroundColor Red
    }
}

# Step 3: Manual instructions
Write-Host "`n═══ Step 3: Manual Web UI steps ═══" -ForegroundColor Magenta
Write-Host ""
Write-Host "  GitHub Pages (REQUIRED):" -ForegroundColor Cyan
Write-Host "    1. https://github.com/$GitHubRepo/settings/pages"
Write-Host "    2. Source -> GitHub Actions -> Save"
Write-Host ""
Write-Host "  Cloudflare Pages (RECOMMENDED):" -ForegroundColor Cyan
Write-Host "    1. https://dash.cloudflare.com -> Pages"
Write-Host "    2. Connect GitHub -> pinforge"
Write-Host "    3. Framework: None, Output: /"
Write-Host ""
Write-Host "  Cloudflare env (for Admin):" -ForegroundColor Cyan
Write-Host "    1. Create KV: pinforge-inquiries"
Write-Host "    2. Pages -> Settings -> Functions -> KV bindings"
Write-Host "    3. Add ADMIN_TOKEN env var"
Write-Host "    4. Redeploy"

# Step 4: Check GitHub Pages status
Write-Host "`n═══ Step 4: Check GitHub Pages ═══" -ForegroundColor Magenta
try {
    $pages = Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubRepo/pages" -ErrorAction Stop
    Write-Host "  + GitHub Pages: $($pages.status)" -ForegroundColor Green
    Write-Host "  + URL: $($pages.html_url)" -ForegroundColor Cyan
} catch {
    Write-Host "  ! GitHub Pages NOT YET enabled (Settings -> Pages)" -ForegroundColor Yellow
}

# Step 5: Check Cloudflare Pages (DNS-based check)
Write-Host "`n═══ Step 5: Check Cloudflare Pages ═══" -ForegroundColor Magenta
try {
    $cfTest = Invoke-WebRequest -Uri "https://$ProjectName.pages.dev/" -UseBasicParsing -ErrorAction Stop
    Write-Host "  + Cloudflare Pages: $($cfTest.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "  ! Cloudflare Pages NOT YET deployed (check Dashboard)" -ForegroundColor Yellow
}

# Step 6: Test GitHub Pages URLs
Write-Host "`n═══ Step 6: Test GitHub Pages URLs ═══" -ForegroundColor Magenta
$paths = @('/', '/en/', '/ja/', '/zh/', '/ko/', '/es/')
foreach ($p in $paths) {
    try {
        $r = Invoke-WebRequest -Uri "https://guoguoping1008.github.io/baji001$p" -UseBasicParsing -ErrorAction Stop
        Write-Host "  + $p -> $($r.StatusCode)" -ForegroundColor Green
    } catch {
        Write-Host "  ! $p -> Not reachable" -ForegroundColor Yellow
    }
}

Write-Host "`nDone. See DEPLOY_NOW.md for action items.`n" -ForegroundColor Cyan

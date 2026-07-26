<#
.SYNOPSIS
  PinForge B2B Site Cloudflare Pages Deployer
.DESCRIPTION
  Automates:
  - Cloudflare API token setup
  - KV namespace creation
  - Pages project creation via GitHub integration
  - Environment variable setup
  - First deployment trigger
.NOTES
  Requires:
  - Node.js 18+
  - wrangler 4.x
  - CLOUDFLARE_API_TOKEN env var (or interactive prompt)
  - Admin rights on your Cloudflare account
#>

$ErrorActionPreference = 'Stop'
$ProjectName = 'pinforge'

Clear-Host
Write-Host @"
╔════════════════════════════════════════════════╗
║  PinForge B2B — Cloudflare Pages Deployer      ║
╚════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Step 1: Verify wrangler
Write-Host "`n[1/4] Wrangler setup" -ForegroundColor Magenta
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:NO_PROXY = "*"
$wranglerVersion = wrangler --version 2>$null
if (-not $wranglerVersion) {
    Write-Host "  X wrangler not found. Installing..." -ForegroundColor Red
    npm install -g wrangler 2>$null
    $wranglerVersion = wrangler --version
}
Write-Host "  + wrangler $wranglerVersion installed" -ForegroundColor Green

# Step 2: API token
Write-Host "`n[2/4] Cloudflare API token" -ForegroundColor Magenta
if (-not $env:CLOUDFLARE_API_TOKEN) {
    Write-Host "  ! CLOUDFLARE_API_TOKEN not set" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  How to get your token:" -ForegroundColor Cyan
    Write-Host "    1. Visit https://dash.cloudflare.com/profile/api-tokens" -ForegroundColor White
    Write-Host "    2. Click 'Create Token' -> 'Edit Cloudflare Pages' template" -ForegroundColor White
    Write-Host "    3. Copy the token" -ForegroundColor White
    Write-Host ""
    $env:CLOUDFLARE_API_TOKEN = Read-Host "  Paste your CLOUDFLARE_API_TOKEN" -AsSecureString
    $env:CLOUDFLARE_API_TOKEN = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($env:CLOUDFLARE_API_TOKEN))
    if (-not $env:CLOUDFLARE_API_TOKEN) {
        Write-Host "  X No token provided. Aborting." -ForegroundColor Red
        exit 1
    }
}

# Verify token works
$verif = wrangler whoami 2>&1
if ($verif -match "You are not authenticated") {
    Write-Host "  X Token invalid. Aborting." -ForegroundColor Red
    exit 1
}
Write-Host "  + Authenticated successfully" -ForegroundColor Green

# Step 3: Create KV namespace
Write-Host "`n[3/4] KV namespace setup" -ForegroundColor Magenta
Write-Host "  Creating pinforge-inquiries..." -ForegroundColor Cyan
$kvCreate = wrangler kv namespace create pinforge-inquiries 2>&1
if ($kvCreate -match "Success") {
    $kvId = ($kvCreate | Select-String -Pattern '\bid = "([^"]+)"' | ForEach-Object { $_.Matches[0].Groups[1].Value }) -split "`n" | Select-Object -First 1
    Write-Host "  + Created: $kvId" -ForegroundColor Green
} else {
    Write-Host "  ! Namespace may already exist. Continuing..." -ForegroundColor Yellow
}

# Step 4: Deploy to Cloudflare Pages (GitHub integration approach)
Write-Host "`n[4/4] Deploy Pages project" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Cloudflare Pages has TWO deployment methods:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  A) GitHub Integration (RECOMMENDED):" -ForegroundColor Green
Write-Host "     - Auto-deploy on every git push" -ForegroundColor White
Write-Host "     - 1-click setup via Cloudflare Dashboard" -ForegroundColor White
Write-Host "     - No local wrangler needed for deploy" -ForegroundColor White
Write-Host ""
Write-Host "  B) Direct upload (CLI):" -ForegroundColor Yellow
Write-Host "     - Manual 'wrangler pages deploy' each time" -ForegroundColor White
Write-Host "     - Slower (manual upload)" -ForegroundColor White
Write-Host ""
Write-Host "  Choose method:" -ForegroundColor Cyan
$method = Read-Host "  (A or B)"
$method = $method.ToUpper().Trim()

if ($method -eq 'A') {
    Write-Host ""
    Write-Host "  A) GitHub Integration Selected" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Please complete these Cloudflare Web UI steps:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "    1. Visit https://dash.cloudflare.com" -ForegroundColor White
    Write-Host "    2. Workers & Pages -> Pages -> Create application" -ForegroundColor White
    Write-Host "    3. Pages -> Connect to Git -> Select GitHub" -ForegroundColor White
    Write-Host "    4. Select repository: Guoguoping1008/baji001" -ForegroundColor White
    Write-Host "    5. Configure:" -ForegroundColor White
    Write-Host "       Project name: $ProjectName" -ForegroundColor Gray
    Write-Host "       Branch: main" -ForegroundColor Gray
    Write-Host "       Build command: (leave empty)" -ForegroundColor Gray
    Write-Host "       Build output: /" -ForegroundColor Gray
    Write-Host "    6. Save and Deploy" -ForegroundColor White
    Write-Host ""
    Write-Host "  After deployment, configure environment:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Settings -> Environment variables -> Add:" -ForegroundColor White
    Write-Host "      Variable: ADMIN_TOKEN" -ForegroundColor Gray
    Write-Host "      Value: $([guid]::NewGuid().ToString().Replace('-',''))[0..31] -join ''" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    Settings -> Functions -> KV bindings -> Add:" -ForegroundColor White
    Write-Host "      Variable: INQUIRIES" -ForegroundColor Gray
    Write-Host "      Namespace: pinforge-inquiries" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Done! https://$ProjectName.pages.dev/ will be live in 2-3 minutes" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  B) Direct upload method" -ForegroundColor Yellow
    Write-Host ""
    wrangler pages deploy . --project-name=$ProjectName --branch=main --commit-dirty=true 2>&1 | Out-String | Write-Host
}

Write-Host ""
Write-Host "`n╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  ✅ Cloudflare Pages setup complete!                     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Primary URL: https://$ProjectName.pages.dev/" -ForegroundColor Green
Write-Host "  Admin URL:   https://$ProjectName.pages.dev/admin.html" -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to finish"
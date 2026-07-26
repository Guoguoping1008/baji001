$ErrorActionPreference = 'Stop'

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════╗
║   PinForge — Cloudflare Pages Auto-Configurator        ║
╚═══════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:NO_PROXY = "*"

Write-Host "`n[1/6] Verify wrangler" -ForegroundColor Magenta
$version = wrangler --version 2>$null
if (-not $version) {
    Write-Host "  ! Installing..." -ForegroundColor Yellow
    npm install -g wrangler 2>$null
    $version = wrangler --version 2>$null
}
Write-Host "  + wrangler $version" -ForegroundColor Green

Write-Host "`n[2/6] Get Cloudflare API Token" -ForegroundColor Magenta
Write-Host "  Create token at:" -ForegroundColor Cyan
Write-Host "  https://dash.cloudflare.com/profile/api-tokens" -ForegroundColor White
Write-Host ""
Write-Host "  Required permissions:" -ForegroundColor Cyan
Write-Host "    - Account > Cloudflare Pages > Edit" -ForegroundColor Gray
Write-Host "    - Account > Workers KV Storage > Edit" -ForegroundColor Gray
Write-Host ""

if (-not $env:CLOUDFLARE_API_TOKEN) {
    $secure = Read-Host "  Paste your CLOUDFLARE_API_TOKEN (input hidden)" -AsSecureString
    $token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
    $env:CLOUDFLARE_API_TOKEN = $token
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
}

if ($env:CLOUDFLARE_API_TOKEN.Length -lt  30) {
    Write-Host "  X Token too short" -ForegroundColor Red
    exit 1
}
Write-Host "  + Token set (" + $env:CLOUDFLARE_API_TOKEN.Length + " chars)" -ForegroundColor Green

Write-Host "`n[3/6] Verify token & get account info" -ForegroundColor Magenta
$verif = wrangler whoami 2>&1 | Out-String
if ($verif -match "Authenticated as|Account ID") {
    Write-Host "  + Authenticated" -ForegroundColor Green
    if ($verif -match "Account ID:\s*([a-f0-9]+)") {
        $accountId = $Matches[1]
        Write-Host "  + Account ID: $accountId" -ForegroundColor Green
    }
} else {
    Write-Host "  ! Auth issue:" -ForegroundColor Yellow
    Write-Host $verif
}

Write-Host "`n[4/6] Create KV namespace" -ForegroundColor Magenta
Write-Host "  Creating 'pinforge-inquiries'..." -ForegroundColor Cyan
$kvOutput = wrangler kv namespace create pinforge-inquiries 2>&1 | Out-String
Write-Host "  " + $kvOutput -ForegroundColor Gray

$kvId = ""
if ($kvOutput -match 'id = "([^"]+)"') {
    $kvId = $Matches[1]
    Write-Host "  + KV ID: $kvId" -ForegroundColor Green
}

# Also create preview namespace for branch previews
$kvPreviewOutput = wrangler kv namespace create pinforge-inquiries --preview 2>&1 | Out-String
$previewId = ""
if ($kvPreviewOutput -match 'id = "([^"]+)"') {
    $previewId = $Matches[1]
    Write-Host "  + Preview KV ID: $previewId" -ForegroundColor Green
}

# Update wrangler.toml with IDs
if ($kvId -or $previewId) {
    $toml = Get-Content "wrangler.toml" -Raw
    if ($kvId) {
        $toml = $toml -replace '^# id = ".*?"$', "id = ""$kvId"""
    }
    if ($previewId) {
        $toml = $toml -replace '^# preview_id = ".*?"$', "preview_id = ""$previewId"""
    }
    Set-Content "wrangler.toml" -Value $toml -NoNewline
    Write-Host "  + wrangler.toml updated" -ForegroundColor Green
}

Write-Host "`n[5/6] Set ADMIN_TOKEN secret" -ForegroundColor Magenta
$adminToken = -join ((48..57) + (97..122) + (65..90) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
Write-Host "  Generated token: $($adminToken.Substring(0,8))..." -ForegroundColor Cyan
Write-Host $adminToken | wrangler secret put ADMIN_TOKEN 2>&1 | Out-String | ForEach-Object {
    Write-Host "  $_" -ForegroundColor Gray
}

Write-Host "`n[6/6] Deploy Pages" -ForegroundColor Magenta
Write-Host "  Project name: baji001" -ForegroundColor Cyan
Write-Host ""
Write-Host "  First, ensure Pages project exists in Dashboard:" -ForegroundColor Yellow
Write-Host "    https://dash.cloudflare.com/1b938cc261b000a03554b506985daabb/workers-and-pages" -ForegroundColor White
Write-Host "    Workers & Pages > Pages tab > baji001" -ForegroundColor Gray
Write-Host ""
Write-Host "  Then deploy:" -ForegroundColor Yellow
Write-Host "    wrangler pages deploy . --project-name=baji001" -ForegroundColor White
Write-Host ""

# Backup wrangler.toml temporarily to avoid conflicts
$wranglerBackup = "wrangler.toml.backup"
Move-Item -Path "wrangler.toml" -Destination $wranglerBackup -Force
Write-Host "  + Temporarily moved wrangler.toml" -ForegroundColor Gray

try {
    wrangler pages deploy . --project-name=baji001 --commit-dirty=true 2>&1 | Out-String | ForEach-Object {
        Write-Host "  $_" -ForegroundColor Gray
    }
} catch {
    Write-Host "  ! Deploy error: $_" -ForegroundColor Red
} finally {
    if (Test-Path $wranglerBackup) {
        Move-Item -Path $wranglerBackup -Destination "wrangler.toml" -Force
        Write-Host "  + Restored wrangler.toml" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== Test deployment ===" -ForegroundColor Magenta
Start-Sleep 5
$testUrls = @(
    "https://baji001.pages.dev/",
    "https://baji001.pages.dev/en/",
    "https://baji001.pages.dev/admin.html"
)
$success = 0
foreach ($u in $testUrls) {
    try {
        $code = (Invoke-WebRequest -Uri $u -UseBasicParsing -MaximumRedirection 0 -ErrorAction Stop).StatusCode
        if ($code -eq 200) {
            Write-Host "  + $u ($code)" -ForegroundColor Green
            $success++
        } else {
            Write-Host "  ! $u ($code)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  - $u (unreachable)" -ForegroundColor Red
    }
}

Write-Host ""
if ($success -eq $testUrls.Count) {
    Write-Host "Deployment successful! All URLs 200 OK." -ForegroundColor Green
    Write-Host ""
    Write-Host "Your site is live at: https://baji001.pages.dev/" -ForegroundColor Cyan
    Write-Host "Admin dashboard: https://baji001.pages.dev/admin.html" -ForegroundColor Cyan
    Write-Host "Admin token: $adminToken" -ForegroundColor Yellow
} else {
    Write-Host "Partial or no deployment. Check Dashboard for details." -ForegroundColor Yellow
}

Read-Host "Press Enter to exit"
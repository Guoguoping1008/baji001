# PinForge — Cloudflare KV + ADMIN_TOKEN Setup
# Run this script with your Cloudflare API Token to:
# 1. Create KV namespace pinforge-inquiries (production)
# 2. Bind KV to Pages project baji001
# 3. Set ADMIN_TOKEN as Pages secret
# 4. Verify with test inquiry

$ErrorActionPreference = 'Stop'
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:NO_PROXY = "*"

Clear-Host
Write-Host @"
╔════════════════════════════════════════════════════════════╗
║  PinForge B2B — Cloudflare Backend Setup                  ║
║                                                            ║
║  1. Create KV namespace                                    ║
║  2. Bind KV to Pages                                       ║
║  3. Set ADMIN_TOKEN secret                                 ║
║  4. Test inquiry API                                       ║
╚════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Step 1: Get API token
Write-Host "`n[1/4] Cloudflare API Token" -ForegroundColor Magenta
Write-Host "  Create token: https://dash.cloudflare.com/profile/api-tokens" -ForegroundColor Cyan
Write-Host "  Required permissions:" -ForegroundColor Cyan
Write-Host "    - Account > Cloudflare Pages > Edit" -ForegroundColor Gray
Write-Host "    - Account > Workers KV Storage > Edit" -ForegroundColor Gray
Write-Host ""

if (-not $env:CLOUDFLARE_API_TOKEN) {
    $secure = Read-Host "  Paste CLOUDFLARE_API_TOKEN (input hidden)" -AsSecureString
    $token = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))
    $env:CLOUDFLARE_API_TOKEN=$token
    [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)) | Out-Null
}

if ($env:CLOUDFLARE_API_TOKEN.Length -lt 30) {
    Write-Host "  X Token too short (need 30+ chars)" -ForegroundColor Red
    exit 1
}
Write-Host "  + Token set (" + $env:CLOUDFLARE_API_TOKEN.Length + " chars)" -ForegroundColor Green

# Verify token
Write-Host "`n[2/4] Verifying token" -ForegroundColor Magenta
$auth = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/user/tokens/verify" -UseBasicParsing -Method GET -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
    "Content-Type" = "application/json"
}
$authData = $auth.Content | ConvertFrom-Json
if ($authData.success) {
    Write-Host "  + Token valid" -ForegroundColor Green
} else {
    Write-Host "  X Token invalid: $($authData.errors[0].message)" -ForegroundColor Red
    exit 1
}

# Get account ID from token
$acct = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts" -UseBasicParsing -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
    "Content-Type" = "application/json"
}
$acctData = $acct.Content | ConvertFrom-Json
if (-not $acctData.success -or $acctData.result.Count -eq 0) {
    Write-Host "  X No accounts found for this token" -ForegroundColor Red
    exit 1
}
$accountId = $acctData.result[0].id
Write-Host "  + Account ID: $accountId" -ForegroundColor Green

# Step 3: Create KV namespace
Write-Host "`n[3/4] Creating KV namespace" -ForegroundColor Magenta
$kvPayload = @{title = "pinforge-inquiries"} | ConvertTo-Json
$kvResp = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$accountId/storage/kv/namespaces" -UseBasicParsing -Method POST -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
    "Content-Type" = "application/json"
} -Body $kvPayload

$kvData = $kvResp.Content | ConvertFrom-Json
if ($kvData.success) {
    $kvId = $kvData.result.id
    Write-Host "  + KV namespace created: pinforge-inquiries" -ForegroundColor Green
    Write-Host "  + ID: $kvId" -ForegroundColor Green
} else {
    $err = $kvData.errors[0].message
    if ($err -match "already exists") {
        Write-Host "  ! KV namespace already exists" -ForegroundColor Yellow
        # List to get ID
        $listResp = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$accountId/storage/kv/namespaces" -UseBasicParsing -Headers @{
            "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
        }
        $listData = $listResp.Content | ConvertFrom-Json
        $kvId = ($listData.result | Where-Object title -eq "pinforge-inquiries")[0].id
        Write-Host "  + Using existing ID: $kvId" -ForegroundColor Green
    } else {
        Write-Host "  X Error: $err" -ForegroundColor Red
        exit 1
    }
}

# Step 4: Update Pages project with KV binding + ADMIN_TOKEN
Write-Host "`n[4/4] Configuring Pages project" -ForegroundColor Magenta

# Get Pages project
$projResp = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$accountId/pages/projects/baji001" -UseBasicParsing -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
}
$projData = $projResp.Content | ConvertFrom-Json
if (-not $projData.success) {
    Write-Host "  X Pages project not found: baji001" -ForegroundColor Red
    Write-Host "    Please create it in Dashboard first" -ForegroundColor Yellow
    exit 1
}
Write-Host "  + Pages project exists: baji001" -ForegroundColor Green

# Update Pages deployment configuration to add KV binding
$deployConfig = @{
    deployment_configs = @{
        production = @{
            kv_namespaces = @(
                @{
                    binding = "INQUIRIES"
                    namespace_id = $kvId
                }
            )
        }
        preview = @{
            kv_namespaces = @(
                @{
                    binding = "INQUIRIES"
                    namespace_id = $kvId
                }
            )
        }
    }
} | ConvertTo-Json -Depth 5

$updateResp = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$accountId/pages/projects/baji001" -UseBasicParsing -Method PATCH -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
    "Content-Type" = "application/json"
} -Body $deployConfig

$updateData = $updateResp.Content | ConvertFrom-Json
if ($updateData.success) {
    Write-Host "  + KV binding added (INQUIRIES -> pinforge-inquiries)" -ForegroundColor Green
} else {
    Write-Host "  ! Configuration update:" -ForegroundColor Yellow
    Write-Host "    $($updateData.errors[0].message)" -ForegroundColor Yellow
    Write-Host "  Trying alternate endpoint..." -ForegroundColor Gray
}

# Set ADMIN_TOKEN as Pages secret
Write-Host "`n  Setting ADMIN_TOKEN secret..." -ForegroundColor Cyan
$adminToken = -join ((48..57) + (97..122) + (65..90) | Get-Random -Count 32 | ForEach-Object { [char]$_ })
$secretResp = Invoke-WebRequest -Uri "https://api.cloudflare.com/client/v4/accounts/$accountId/pages/projects/baji001/secrets/ADMIN_TOKEN" -UseBasicRequest -UseBasicParsing -Method PUT -Headers @{
    "Authorization" = "Bearer $($env:CLOUDFLARE_API_TOKEN)"
    "Content-Type" = "application/json"
} -Body ([ordered]@{name="ADMIN_TOKEN"; text=$adminToken; type="secret_text"} | ConvertTo-Json)

$secretData = $secretResp.Content | ConvertFrom-Json
if ($secretData.success) {
    Write-Host "  + ADMIN_TOKEN secret set" -ForegroundColor Green
    Write-Host "  + Your admin token: $adminToken" -ForegroundColor Yellow
    Write-Host "    Save this! You'll need it to login at /admin" -ForegroundColor Yellow
} else {
    Write-Host "  ! Secret error: $($secretData.errors[0].message)" -ForegroundColor Yellow
}

Write-Host "`n=== Setup complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Test inquiry API:" -ForegroundColor Cyan
Write-Host "  curl -X POST https://baji001.pages.dev/api/inquiry ``
Write-Host "    -F 'company=Test' -F 'name=Tester' -F 'email=t@e.com' ``
Write-Host "    -F 'country=US' -F 'product_type=enamel' -F 'quantity=100' ``
Write-Host "    -F 'description=Test inquiry'"
Write-Host ""
Write-Host "Admin login URL: https://baji001.pages.dev/admin" -ForegroundColor Cyan
Write-Host "Admin token: $adminToken" -ForegroundColor Yellow

# Save token to file for reference
$adminToken | Set-Content "admin-token.txt" -NoNewline
Write-Host ""
Write-Host "Admin token saved to admin-token.txt (for your records)" -ForegroundColor Gray

Read-Host "Press Enter to exit"
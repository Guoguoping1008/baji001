<#
.SYNOPSIS
  PinForge 部署检查 + 验证脚本（适用于 GitHub Pages 已部署的情况）
#>

$ErrorActionPreference = 'Stop'
$GitHubRepo = 'Guoguoping1008/baji001'
$ProjectName = 'pinforge'
$BaseUrl = "https://guoguoping1008.github.io/baji001"

Clear-Host
Write-Host @"
╔════════════════════════════════════════════════╗
║  PinForge B2B Site — Deployment Verifier      ║
╚════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Step 1: GitHub Pages status
Write-Host "`n[1/5] GitHub Pages status" -ForegroundColor Magenta
try {
    $pages = Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubRepo/pages" -UseBasicParsing -ErrorAction Stop
    Write-Host "  + ENABLED" -ForegroundColor Green
    Write-Host "  + URL: $($pages.html_url)" -ForegroundColor Green
    Write-Host "  + Status: $($pages.status)" -ForegroundColor Green
} catch {
    Write-Host "  ! NOT YET ENABLED in Settings" -ForegroundColor Yellow
    Write-Host "    Fix: https://github.com/$GitHubRepo/settings/pages" -ForegroundColor Yellow
}

# Step 2: Latest deployment
Write-Host "`n[2/5] Latest workflow deployment" -ForegroundColor Magenta
try {
    $runs = Invoke-RestMethod -Uri "https://api.github.com/repos/$GitHubRepo/actions/runs?per_page=3" -UseBasicParsing
    foreach ($run in $runs.workflow_runs) {
        $icon = if ($run.conclusion -eq 'success') {'+'} else {'!'}
        $color = if ($run.conclusion -eq 'success') {'Green'} else {'Yellow'}
        Write-Host "  $icon $($run.display_title): $($run.conclusion)" -ForegroundColor $color
    }
} catch {
    Write-Host "  ! Cannot fetch workflow runs" -ForegroundColor Yellow
}

# Step 3: Live URL test
Write-Host "`n[3/5] Live URL tests" -ForegroundColor Magenta
$urls = @(
    @{path='/'; label='Home (en)'},
    @{path='/en/'; label='English (/en/)'},
    @{path='/ja/'; label='Japanese'},
    @{path='/zh/'; label='Chinese'},
    @{path='/ko/'; label='Korean'},
    @{path='/es/'; label='Spanish'},
    @{path='/product-m13.html'; label='M13 Smart Badge'},
    @{path='/product-phonecase.html'; label='iPhone Case'},
    @{path='/cart.html'; label='Cart'},
    @{path='/customize.html'; label='Inquiry Form'},
    @{path='/admin.html'; label='Admin'},
    @{path='/sitemap.xml'; label='Sitemap'},
    @{path='/404.html'; label='Custom 404'}
)

$success = 0
$failed = 0
foreach ($u in $urls) {
    $full = "$BaseUrl$($u.path)"
    try {
        $code = (Invoke-WebRequest -Uri $full -UseBasicParsing -MaximumRedirection 0 -ErrorAction Stop).StatusCode
        if ($code -ge 200 -and $code -lt 400) {
            Write-Host "  + $($u.path) ($code)" -ForegroundColor Green
            $script:success++
        } else {
            Write-Host "  ! $($u.path) ($code)" -ForegroundColor Yellow
            $script:failed++
        }
    } catch {
        $script:failed++
        Write-Host "  - $($u.path) (failed)" -ForegroundColor Red
    }
}
Write-Host "`n  Result: $success OK, $failed failed" -ForegroundColor $(if ($failed -eq 0) {'Green'} else {'Yellow'})

# Step 4: Cloudflare Pages check
Write-Host "`n[4/5] Cloudflare Pages status" -ForegroundColor Magenta
$cfUrl = "https://$ProjectName.pages.dev"
try {
    $r = Invoke-WebRequest -Uri $cfUrl -UseBasicParsing -MaximumRedirection 0 -ErrorAction Stop
    Write-Host "  + DEPLOYED at $cfUrl" -ForegroundColor Green
    Write-Host "  + Status: $($r.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "  ! NOT YET DEPLOYED (need Cloudflare Web UI setup)" -ForegroundColor Yellow
    Write-Host "    Steps: see DEPLOY_NOW.md" -ForegroundColor Cyan
}

# Step 5: SEO submission status
Write-Host "`n[5/5] Next steps for SEO" -ForegroundColor Magenta
Write-Host "  Recommended actions:" -ForegroundColor Cyan
Write-Host "    1. Submit sitemap to Google Search Console" -ForegroundColor White
Write-Host "       https://search.google.com/search-console/" -ForegroundColor Gray
Write-Host "    2. Submit to Bing Webmaster" -ForegroundColor White
Write-Host "       https://www.bing.com/webmasters" -ForegroundColor Gray
Write-Host "    3. Submit to Baidu Zhanzhang" -ForegroundColor White
Write-Host "       https://ziyuan.baidu.com/" -ForegroundColor Gray
Write-Host "`n  Full guide: SEO_SUBMIT_GUIDE.md" -ForegroundColor Cyan

Write-Host "`n[summary]" -ForegroundColor Cyan
Write-Host "  Primary URL: $BaseUrl/" -ForegroundColor Green
Write-Host "  Repository:  https://github.com/$GitHubRepo" -ForegroundColor Cyan

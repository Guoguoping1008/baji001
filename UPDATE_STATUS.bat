@echo off
REM PinForge 部署状态检查工具
REM 用法：在仓库根目录双击运行此文件

echo ================================================
echo    PinForge B2B Site — Deployment Status
echo ================================================
echo.

echo [1/3] GitHub Pages 状态
echo.
curl -s -o nul -w "  Status: %%{http_code}" "https://guoguoping1008.github.io/baji001/" 2>nul
echo "  URL: https://guoguoping1008.github.io/baji001/"
echo.

echo [2/3] 多语言 URL 测试
echo.
for %%p in ("" "/en/" "/ja/" "/zh/" "/ko/" "/es/" "/product-m13.html" "/cart.html" "/sitemap.xml") do (
    set "url=https://guoguoping1008.github.io/baji001%%p"
    for /f "tokens=*" %%s in ('curl -s -o nul -w "%%{http_code}" "!url!"') do (
        echo    %%p [%%s]
    )
)
echo.

echo [3/3] Cloudflare Pages 状态（如果已部署）
echo.
for /f "tokens=*" %%s in ('curl -s -o nul -w "%%{http_code}" "https://pinforge-b2b.pages.dev/"') do (
    echo   Status: %%s
)
echo.

echo ================================================
echo   部署完成度检查
echo ================================================
echo.
echo  GitHub Pages (已部署):        [完成]
echo  Cloudflare Pages (待用户操作): [Web UI 一键部署]
echo.
echo  下一步:
echo  1. 访问 https://dash.cloudflare.com
echo  2. Workers & Pages ^> Create ^> Pages ^> Connect to Git
echo  3. 选 Guoguoping1008/baji001 仓库
echo  4. Branch: main, Output: /
echo  5. Save and Deploy
echo.
echo  或者运行 .\cf-deploy.ps1（需 CF API Token）
echo.

pause

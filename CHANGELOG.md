
# Changelog
All notable changes to PinForge website will be documented in this file.

## [1.4.1] - 2025-01
### Live & Verified
- GitHub Pages enabled and deployed via Web UI
- All 13 URL tests passed (200 OK):
  - / (root)
  - /en/, /ja/, /zh/, /ko/, /es/
  - /product-m13.html, /product-phonecase.html
  - /cart.html, /customize.html, /admin.html
  - /sitemap.xml, /404.html

### Added
- 404.html — Custom branded 404 page with multi-language fallback
- FIX_404.md — 30-second GitHub Pages setup guide
- SEO_SUBMIT_GUIDE.md — Step-by-step GSC/Bing/Baidu submission
- deploy-automation.ps1 — PowerShell deployment status verifier

### Fixed
- Removed legacy static.yml (conflicted with Actions workflow)
- Added missing translations to all 5 languages (Browse Catalog, Factory direct tag, etc.)
- All i18n pages now have consistent 5-language translations

### Verified
- 5 languages fully functional: EN/JA/ZH/KO/ES
- 5 language switcher in nav works correctly
- All 13 core URLs return HTTP 200
- Workflow "pages build and deployment" succeeded

## [1.4.0] - 2025-01
### Added — 5-Language Support (EN/JA/ZH/KO/ES) + URL Restructure

## [1.3.0] - 2025-01
### Added — Cart + i18n + Admin

## [1.2.0] - 2025-01
### Added — M13 Smart Badge + iPhone Cases

## [1.1.1] - 2025-01
### Changed — Real Contact Information

## [1.1.0] - 2025-01
### Added — Visual & Performance Upgrade

## [1.0.0] - 2025-01
### Added
- Initial site launch

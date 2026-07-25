# Changelog
All notable changes to PinForge website will be documented in this file.

## [1.3.0] - 2025-01
### Added — Cart + i18n + Admin (4 Big Features)

**🛒 Shopping Cart System**
- `cart.html` — dedicated cart page with item list, qty controls, subtotal, summary
- `assets/js/cart.js` — client-side cart with LocalStorage persistence
- `assets/css/cart.css` — cart UI styles
- 16 "Add to Cart" buttons on products.html (each with proper MOQ)
- 2 "Quick Add to Cart" buttons on product detail pages (M13 + iPhone Case)
- Cart badge in nav (counts total items, updates live)
- WhatsApp checkout (one-click order summary to sales)
- GA4 + Meta Pixel add_to_cart tracking events
- Empty-state UX + "Continue Shopping" suggestions
- Cart survives page reloads (LocalStorage)

**🌐 Multi-Language Support (Japanese + Chinese)**
- `ja/` directory — 8 Japanese pages (index, products, customize, about, contact, cart, product-m13, product-phonecase)
- `zh/` directory — 8 Chinese pages (same set)
- All UI strings translated: navigation, hero, categories, why-us, process, footer
- Hero badge, title, subtitle localized per language
- HTML lang attribute set correctly (ja, zh)
- All asset paths fixed to relative `../` for subdirectory
- Language switcher dropdown in nav (🇺🇸 EN / 🇯🇵 日本語 / 🇨🇳 中文) on every page
- Sitemap updated with ja/zh URLs
- Brand-name products (M13, iPhone) kept in English for recognition

**🔒 Admin Inquiry Dashboard**
- `admin.html` — protected admin panel with token-based auth
- `functions/api/admin/list.js` — paginated inquiry list + stats
- `functions/api/admin/get.js` — single inquiry detail
- `functions/api/admin/update.js` — status updates (new → contacted → quoted → won/lost)
- `functions/api/inquiry.js` — rewritten with KV persistence + Slack/Email integration
- Dashboard stats: total, last 24h, by status, by product, by country
- Searchable + filterable table (by company, email, country, status, product)
- Click-through detail modal with full inquiry + raw JSON
- Quick action buttons (WhatsApp, Email) for outreach
- Auto-refresh every 60s
- X-Admin-Token auth via header
- KV namespace binding instructions in wrangler.toml
- Friendly URL: /admin → /admin.html

**🎨 Professional Product SVGs**
- All 16 product SVGs redesigned with premium details:
  - Hard Enamel Pin: gold metallic rim, red enamel, 5-point star
  - Soft Enamel Pin: textured metal, purple enamel, outlined star
  - Glitter Pin: holographic rainbow + sparkle stars
  - Glow-in-Dark Pin: dark background + green glow effect
  - Button Pin: red "P" with butterfly clasp
  - Magnetic Badge: green with magnet bar
  - Mirror Badge: orange + reflective center
  - Acrylic Standees: 3 styles with depth, shine, holographic
  - Keychains: zinc alloy (orange) + stainless steel (engraved)
  - Wristband: orange silicone ring
  - Lanyard: V-shape blue with hook
  - Gift Box: orange with gold ribbon
  - Backer Card: white card with pin mounting
- Added gradients (linearGradient, radialGradient)
- Added highlight reflections for 3D feel
- Added realistic shine overlays

### Added — Routing & Discovery
- `/admin` → /admin.html (301 redirect)
- `/cart` → /cart.html (301 redirect)
- Sitemap updated: cart.html, admin.html, ja/*, zh/*

## [1.2.0] - 2025-01
### Added — New Product Lines (M13 Smart Badge + iPhone Cases)

## [1.1.1] - 2025-01
### Changed — Real Contact Information

## [1.1.0] - 2025-01
### Added — Visual & Performance Upgrade

## [1.0.0] - 2025-01
### Added
- Initial site launch
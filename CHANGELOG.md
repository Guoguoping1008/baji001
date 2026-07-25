# Changelog
All notable changes to PinForge website will be documented in this file.

## [1.2.0] - 2025-01
### Added — New Product Lines (M13 Smart Badge + iPhone Cases)
- 🆕 **M13 Smart Display Badge** — full product detail page (`product-m13.html`)
  - 1.7" 360x360 round LCD, Bluetooth 6.0, 400mAh battery, 7-color support lights
  - Standard + AI versions (real-time translation, meeting minutes)
  - Complete specs from factory datasheet (7609T motherboard, AC7076A CPU)
  - 37 app languages supported
  - 6 use cases (concerts, conferences, trade shows, cycling, gaming, weddings)
  - 3-tier wholesale pricing ($24.80 / $21.50 / $18.90 per pc)
- 🆕 **Custom iPhone Cases** — full product detail page (`product-phonecase.html`)
  - Compatible with iPhone 6 through iPhone 16 Pro Max
  - 5 material options (PC, TPU, clear, leather, biodegradable)
  - 6 printing techniques (UV, sublimation, embossing, silkscreen, hot stamping, IMD)
  - Product demo video embedded (6.5MB MP4)
  - 2 design collections with detail views (12 photos)
  - 3-tier wholesale pricing ($2.80 / $2.20 / $1.85 per pc)
  - Amazon FBA drop-ship ready

### Added — Cross-Page Integration
- 🎨 **Product gallery CSS** (`product-detail.css`) — sticky gallery, thumb switcher, price tiers
- 🔧 **Product gallery JS** (`product-gallery.js`) — image switcher + keyboard navigation
- 🚀 **"New Arrivals" section** on homepage — dark navy hero card with M13 + iPhone Case
- ⭐ **"Featured New Products" section** on products.html — top-of-page showcase cards
- 📝 **Inquiry form pre-fill** via URL param:
  - `customize.html?product=m13` → auto-selects "M13 Smart Display Badge"
  - `customize.html?product=m13-ai` → auto-selects "M13 AI Version"
  - `customize.html?product=phonecase` → auto-selects "Custom iPhone Case"
  - `customize.html?product=phonecase-pack` → auto-selects "iPhone Case (Bulk Pack)"

### Added — Images & Media
- 📸 32 product images for M13 (hero + 4 gallery + 11 detail + 16 infographic)
- 📸 27 product images for iPhone Cases (hero + 4 main + 10 white-bg + 6+6 detail-sku)
- 🎬 1 product demo video (phonecase-demo.mp4, 6.5MB)

### Changed
- Homepage hero badge now includes "🚀 NEW: Smart Display Badges & iPhone Cases"
- Homepage subtitle mentions smart hardware offerings
- Footer Products section: M13 + iPhone Cases now appear at top
- Navigation CTA: "Get a Quote" → `/customize.html?product=m13` on product pages
- Products page header: "Smart hardware, custom accessories & traditional pins"
- Products page adds "⭐ Featured" filter tab

### SEO
- 2 new Product JSON-LD schemas (M13 + iPhone Case) with full specs, pricing, ratings
- M13: price range $18.90-$24.80, rating 4.9/327, MOQ 50
- iPhone Case: price range $1.85-$3.80, rating 4.8/245, MOQ 50
- New OG tags for product pages

## [1.1.1] - 2025-01
### Changed — Real Contact Information
- 📍 **Factory address** updated: Room 302, No. 179 Hongli Road, Liaobu Town, Dongguan City, Guangdong Province, China 523400
- 📞 **4 WhatsApp sales lines** (click-to-chat via wa.me):
  - Main Sales: +86 13925748590
  - Sales: +86 18002816058
  - Sales: +86 15209604190
  - Sales: +86 18038289516
- 📧 **Email**: Devllin@outlook.com (unified for Sales/Support/Partnerships)
- 🗺️ **Google Maps embed** added on contact page (Liaobu, Dongguan coordinates)
- 💬 **Quick CTA grid** on contact page: WhatsApp / Email / Call buttons
- 🔗 **All WhatsApp & email references** linkified (wa.me + mailto)

### Fixed
- JSON-LD structured data: all 19 schemas re-validated with new address
- City field updated: Yiwu → Dongguan in LocalBusiness schema
- Region: Zhejiang → Guangdong
- Postal: 322000 → 523400
- About page narrative: "small commodities capital" → "manufacturing capital"
- Products page sourcing network: Yiwu → Dongguan

## [1.1.0] - 2025-01
### Added — Visual & Performance Upgrade
- 🎨 **Custom brand colors** — coral red (#E63946) + deep navy (#1D3557), sophisticated B2B palette
- 🔤 **Google Fonts** — Inter + Plus Jakarta Sans for modern typography
- 📸 **16 SVG product images** — custom-designed vector illustrations for all product SKUs
- 🖼️ **Brand logo SVG** — custom pin badge design with metallic gradient
- 🍞 **Favicon upgrade** — apple-touch-icon support
- 📊 **JSON-LD structured data** — Organization, LocalBusiness, Product, FAQ, BreadcrumbList, WebSite schemas
- 🔗 **Canonical URLs** on every page
- 📈 **Google Analytics 4** integration with conversion tracking
- 📘 **Meta (Facebook) Pixel** with Lead event tracking
- 🎵 **TikTok Pixel** with SubmitForm event tracking
- 🔍 **Microsoft Clarity** for heatmaps and session recording
- 🇨🇳 **Baidu Tongji** analytics for Chinese market
- 📊 **Event tracking** — product filters, social clicks, CTA clicks, form conversions
- 🎯 **Sticky form** on customize page with enhanced visual hierarchy

### Changed
- Logo component (emoji → SVG with gradient)
- Hero pin cards (emoji → real product illustrations)
- Color palette refresh across all pages
- Typography refresh (system fonts → Inter + Plus Jakarta Sans)
- Button hover effects (lift animation + shadow)

## [1.0.0] - 2025-01
### Added
- 🚀 Initial site launch
- 📌 Hero section with animated pin showcase
- 🎨 Product catalog (6 categories: enamel pins, button badges, acrylic standees, keychains, wristbands, packaging)
- 📝 B2B inquiry form with file upload
- 💬 Contact form
- 🌐 Social media integration (Facebook, Instagram, TikTok, Xiaohongshu)
- ❓ FAQ section (8 questions)
- 📱 Mobile responsive design
- 🔍 Product filter tabs
- ✨ Scroll animations
- 📊 Trust signals (testimonials, certifications, factory tour)
- ⚙️ Cloudflare Pages Functions for form handling
- 🚀 GitHub Actions auto-deploy workflow
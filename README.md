# 📌 PinForge — Premium Custom Pin Badges B2B Website

A modern, fast, fully responsive B2B website for a custom pin badge & enamel pin manufacturer.

**主题**：电子吧唧 (Pin Badges / Enamel Pins) · **目标客户**：海外 ToB 客户 · **服务**：成品供应 + 定制服务

## 🌟 Live Preview

- GitHub Pages: `https://your-username.github.io/baji001/`
- Cloudflare Pages: `https://pinforge.pages.dev/`

## ✨ Features

### Customer-facing
- 🎨 **6 product categories** with detailed specifications
- 📝 **B2B inquiry form** with 14 fields including file upload, NDA option, sample request
- 💬 **Multi-channel contact** (Email, WhatsApp, WeChat, Phone)
- 🌐 **Social media integration** (Facebook, Instagram, TikTok, Xiaohongshu 海外小红书)
- ❓ **8-question FAQ** covering MOQ, lead time, payment, shipping, etc.
- 📱 **100% mobile responsive** with smooth animations
- 🔍 **Product filter tabs** for easy catalog browsing
- ✨ **Scroll-reveal animations** and interactive elements

### Technical
- ⚡ **Pure static HTML/CSS/JS** — zero dependencies, lightning fast
- 🚀 **Auto-deploy** via GitHub Actions to GitHub Pages
- ☁️ **Cloudflare Pages Functions** for serverless form handling
- 🔒 **Security headers** (CSP, HSTS, X-Frame-Options)
- 📊 **SEO optimized** (meta tags, OG tags, semantic HTML)
- ♿ **Accessible** (ARIA labels, semantic markup, keyboard navigation)
- 🌐 **i18n ready** — easy to add multi-language versions

## 📁 Project Structure

```
baji001/
├── index.html              # Homepage
├── products.html           # Product catalog (6 categories)
├── customize.html          # Custom service + inquiry form
├── about.html              # About us + certifications
├── contact.html            # Contact info + quick form
├── assets/
│   ├── css/style.css       # Main stylesheet
│   ├── js/main.js          # Main JavaScript
│   └── images/             # (Add product images here)
├── functions/
│   └── api/
│       ├── inquiry.js      # Handles B2B inquiry form (POST /api/inquiry)
│       └── contact.js      # Handles contact form (POST /api/contact)
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions auto-deploy
├── _headers                # Cloudflare Pages security headers
├── _redirects              # Cloudflare Pages redirects
├── wrangler.toml           # Cloudflare Pages config
├── static.yml              # GitHub Pages config
├── SOURCING_GUIDE.md       # 国内采购渠道完整指南
├── CHANGELOG.md            # Version history
└── README.md               # This file
```

## 🚀 Quick Start

### Local development

Just open `index.html` in any browser, or use a local server:

```bash
# Python 3
python -m http.server 8000

# Node.js
npx serve .

# Then open http://localhost:8000
```

### Deploy to GitHub Pages

1. **Push to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "feat: initial PinForge website"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/baji001.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**:
   - Go to repo Settings → Pages
   - Source: "GitHub Actions"
   - The workflow `.github/workflows/deploy.yml` will auto-deploy

3. **Your site will be live at**: `https://YOUR_USERNAME.github.io/baji001/`

### Deploy to Cloudflare Pages

#### Option A: Connect GitHub (Recommended)
1. Go to [Cloudflare Dashboard](https://dash.cloudflare.com/) → Workers & Pages → Create
2. Choose "Pages" → "Connect to Git"
3. Select your `baji001` repository
4. Build settings:
   - Framework preset: **None**
   - Build command: *(leave empty)*
   - Build output directory: `/`
5. Click "Save and Deploy"

#### Option B: Direct upload via Wrangler CLI
```bash
npm install -g wrangler
wrangler login
wrangler pages deploy . --project-name=pinforge
```

### Configure environment variables (Cloudflare)

In Cloudflare Dashboard → Your Pages project → Settings → Environment variables:

```
SLACK_WEBHOOK_URL = https://hooks.slack.com/services/...   # Optional: forward inquiries to Slack
RESEND_API_KEY = re_xxx                                    # Optional: send email notifications
```

## 📝 Inquiry Form Configuration

The form action is `/api/inquiry` which hits the Cloudflare Pages Function. To customize:

1. **Edit** `functions/api/inquiry.js`
2. **Uncomment** the function you want (Slack, Email, etc.)
3. **Set environment variables** in Cloudflare dashboard
4. **Redeploy**

Currently supported:
- ✅ Slack webhook notifications
- ✅ Resend email (uncomment to enable)
- ✅ Formspree fallback (uncomment to enable)

## 🎨 Customization

### Change brand name
Search & replace `PinForge` and `Pin` (in HTML/CSS/JS) with your brand.

### Change colors
Edit CSS variables in `assets/css/style.css`:
```css
:root {
    --primary: #FF6B35;        /* Orange - replace with your brand color */
    --secondary: #004E89;      /* Navy blue */
    --dark: #1A1A2E;          /* Dark text */
}
```

### Add product images
1. Add images to `assets/images/`
2. In `products.html`, replace the gradient divs:
   ```html
   <div class="product-img" style="background: ...">🎨</div>
   ```
   With:
   ```html
   <img src="assets/images/product1.jpg" alt="Hard Enamel Pin" class="product-img">
   ```

### Update contact info
Search for `pinforge.example`, `+86-xxx-xxxx-xxxx`, `Yiwu, Zhejiang` across HTML files and replace with real values.

## 🌐 Social Media Setup

### Facebook Page
Create a page at [facebook.com/pages/create](https://facebook.com/pages/create), then update links in footer & social section.

### Instagram Business
Create at [business.instagram.com](https://business.instagram.com), update `@pinforge_official`.

### TikTok Business
Create at [tiktok.com/business](https://tiktok.com/business), update `@pinforge`.

### 小红书 (Xiaohongshu) 海外账号
Create at [xiaohongshu.com](https://xiaohongshu.com), update `@PinForge海外`. Recommended for reaching overseas Chinese diaspora and Asian markets.

## 📊 SEO Checklist

After deployment:
- [ ] Submit sitemap to [Google Search Console](https://search.google.com/search-console)
- [ ] Submit to [Bing Webmaster](https://www.bing.com/webmasters)
- [ ] Set up [Google Analytics](https://analytics.google.com) (add GA4 ID to `<head>`)
- [ ] Set up [Meta Pixel](https://business.facebook.com/events_manager) for FB/IG ads
- [ ] Set up [TikTok Pixel](https://ads.tiktok.com) for TikTok ads
- [ ] Configure Cloudflare Analytics (free)
- [ ] Add structured data (JSON-LD) to `<head>` (Organization, Product schemas)

## 🔒 Legal Pages (TODO before launch)

Create and link these pages:
- `privacy.html` — Privacy Policy (GDPR, CCPA compliant)
- `terms.html` — Terms of Service
- `cookies.html` — Cookie Policy (if using cookies)

Free templates: [getterms.io](https://getterms.io)

## 📞 Contact Integration

### WhatsApp Click-to-Chat
Replace `+86-xxx-xxxx-xxxx` in HTML with your WhatsApp number (with country code, no `+`):
```html
<a href="https://wa.me/8613800000000">Chat on WhatsApp</a>
```

### Email Setup
Use a business email (e.g., `sales@yourdomain.com`) — set up via:
- Google Workspace ($6/month)
- Zoho Mail (free tier available)
- Cloudflare Email Routing (free, forward to Gmail)

## 🛠 Tech Stack

- **Frontend**: HTML5, CSS3, Vanilla JavaScript (no frameworks!)
- **Forms**: Cloudflare Pages Functions (serverless)
- **Hosting**: GitHub Pages + Cloudflare Pages (free tier)
- **CI/CD**: GitHub Actions
- **CDN**: Cloudflare global network
- **Analytics**: Cloudflare Web Analytics (free, privacy-friendly)

## 📦 China Sourcing Channels

See `SOURCING_GUIDE.md` for the complete list of China-based suppliers for:
- 1688.com (factory direct)
- Alibaba International (B2B English)
- Yiwu market (offline)
- DHgate, Made-in-China
- Specialty pin platforms
- And more

## 💰 Cost Breakdown

| Item | Cost |
|------|------|
| Domain (yourdomain.com) | ~$10-15/year |
| GitHub Pages hosting | Free |
| Cloudflare Pages hosting | Free (unlimited bandwidth) |
| Cloudflare Workers/Functions | Free tier: 100K requests/day |
| SSL Certificate | Free (auto) |
| **Total** | **~$10-15/year** |

## 📄 License

© 2025 PinForge. All rights reserved.

This codebase is proprietary. You may use it as a template for your own pin badge business by:
1. Replacing all "PinForge" branding with your brand
2. Updating contact info, colors, images
3. Customizing product descriptions

## 🆘 Support

- 📧 Email: dev@pinforge.example
- 📖 Docs: This README + `SOURCING_GUIDE.md`
- 🐛 Issues: GitHub Issues

---

**Built with ❤️ for the global pin badge community**

📌 *Crafting connections, one pin at a time.*
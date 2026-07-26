# 部署指南：GitHub Pages + Cloudflare Pages

> 双部署策略：GitHub Pages（主入口）+ Cloudflare Pages（CDN 加速、Functions）

---

## 🎯 目标

将 PinForge 多语言独立站（5 语言版本，42 个页面）部署到：
1. GitHub Pages —— 免费、自动部署
2. Cloudflare Pages —— 全球 CDN、Functions

---

## ✅ Part 1：GitHub Pages

### 准备工作（已完成）
- static.yml（Pages 配置文件）
- .github/workflows/deploy.yml（GitHub Actions workflow）

### 启用 GitHub Pages（Web UI）

1. 打开 https://github.com/Guoguoping1008/baji001/settings/pages
2. **Source**：选择 `GitHub Actions`
3. **Save**

### 访问
https://guoguoping1008.github.io/baji001/

---

## ✅ Part 2：Cloudflare Pages

### 准备工作（已完成）
- wrangler.toml
- .cloudflare-deploy.yml
- functions/ 目录（5 个 Functions）

### 部署步骤（Web UI）

1. https://dash.cloudflare.com/ → Workers & Pages → Pages
2. Create application → Pages → Connect to Git
3. 选 GitHub → 选 baji001 仓库
4. 配置：
   - Project name: `pinforge`
   - Production branch: `main`
   - Framework preset: None
   - Build command: (留空)
   - Build output directory: /
5. Save and Deploy

### 配置环境

**Steps → Settings → Environment variables → Add**:
- ADMIN_TOKEN = 32 字符随机字符串

**Steps → Settings → Functions → KV namespace bindings → Add**:
- Variable name: INQUIRIES
- KV namespace: pinforge-inquiries (需先在 Workers & Pages → KV 创建)

### 访问
https://pinforge.pages.dev/

---

## 🆘 故障排查

### Pages 部署失败
- 检查 Actions tab 看错误日志
- 通常 Pages 没启用导致

### Cloudflare Functions 不工作
- 确认 KV 绑定
- 确认 ADMIN_TOKEN 环境变量设置

### 中文乱码
- 文件需要 UTF-8 编码
- Cloudflare 自动处理

---

## 📊 推荐分工

| 平台 | 用途 |
|------|------|
| GitHub Pages | 默认 / 备份 |
| Cloudflare Pages | 生产主入口（支持 Functions）|

总成本 $0。

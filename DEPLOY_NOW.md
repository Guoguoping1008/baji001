# 🚀 立即部署指南（用户手动操作）

> 这是给用户的简明 3 步操作：约 5 分钟完成全部部署

## ✅ 已自动完成（你不需要操作）

- GitHub 仓库代码推送 ✅
- wrangler.toml 配置 ✅
- _redirects / _headers ✅
- GitHub Actions workflow ✅
- Cloudflare Functions (5 个) ✅
- I18N hreflang 标签 ✅
- Sitemap ✅
- 询盘 + Admin 后端代码 ✅

## 🎯 需要你手动操作（5 分钟）

### Step 1: 启用 GitHub Pages（1 分钟）

打开：**https://github.com/Guoguoping1008/baji001/settings/pages**

设置：
- **Source**: `GitHub Actions`

点击 **Save**。

### Step 2: 部署到 Cloudflare Pages（推荐 - 用于生产）

1. **https://dash.cloudflare.com/** → **Workers & Pages** → **Pages**
2. **Create application** → **Pages** → **Connect to Git**
3. 选 GitHub → 授权 → 选 `Guoguoping1008/baji001`
4. 配置：
   - Project name: `pinforge`
   - Production branch: `main`
   - Framework preset: **None**
   - Build command: *(留空)*
   - Build output directory: `/`
5. **Save and Deploy**

### Step 3: 配置 Cloudflare 环境

**3.1 添加环境变量**

Pages → **Settings** → **Environment variables** → **Add**:

| Variable name | Value |
|---------------|-------|
| `ADMIN_TOKEN` | 32 字符随机字符串 |

**3.2 创建 KV Namespace**

左菜单 → **Workers & Pages** → **KV** → **Create a namespace**
- 名称: `pinforge-inquiries`

**3.3 绑定 KV**

Pages → **Settings** → **Functions** → **KV namespace bindings** → **Add**
- Variable name: `INQUIRIES`
- KV namespace: `pinforge-inquiries`

**3.4 重新部署**

**Settings** → **Builds** → **Retry deployment**

---

## 🆘 如遇问题

### GitHub Pages 部署一直失败
检查：https://github.com/Guoguoping1008/baji001/actions

常见错误：
- "Pages deployment failed" — Pages 还没启用（需在 Settings 启用）

### Cloudflare Pages 部署失败
查看 Pages 项目 → **Build logs**

### Functions 报错
查看 Pages → **Functions** → **Logs**

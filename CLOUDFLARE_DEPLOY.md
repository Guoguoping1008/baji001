# ☁️ Cloudflare Pages 部署指南

> 目标：将 PinForge 独立站部署到 Cloudflare Pages（已部署 GitHub Pages，本指南增加 Cloudflare 版本启用后端 Functions）

---

## 🎯 当前状态

✅ GitHub Pages: 已上线
- URL: https://guoguoping1008.github.io/baji001/
- 13/13 URL 测试通过
- 5 语言完整渲染

⚠️ Cloudflare Pages: `pinforge.pages.dev` 名称已被另一项目占用

⏳ 待做: 用自定义名 `pinforge-b2b`（或类似独特名）部署

---

## 🛠️ 方法 A: Web UI（最简单，推荐）

### Step 1: 获取 Cloudflare API Token

1. 访问 https://dash.cloudflare.com/profile/api-tokens
2. **Create Token** → **Edit Cloudflare Pages** 模板
3. 或自定义权限: `Account:Cloudflare Pages:Edit`
4. **Create Token** → 复制（只显示一次！）

### Step 2: 创建 Cloudflare Pages 项目

1. 访问 https://dash.cloudflare.com/
2. **Workers & Pages** → **Create** → **Pages** → **Connect to Git**
3. 选 GitHub → 授权 → 选 `Guoguoping1008/baji001`
4. **Set up builds and deployments**:

| 字段 | 值 |
|------|-----|
| Project name (production) | `pinforge-b2b`（必须独特） |
| Production branch | `main` |
| Framework preset | **None** |
| Build command | *(留空)* |
| Build output directory | `/` |

5. **Save and Deploy** → 等待 2-3 分钟

部署 URL: `https://pinforge-b2b.pages.dev/`

### Step 3: 创建 KV namespace（询盘 + Admin 必需）

```powershell
cd E:\workspace\codex\baji001
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
wrangler login
wrangler kv namespace create pinforge-inquiries
# 输出:
# { binding = "INQUIRIES", id = "abc123def456..." }
```

复制 **id** 备用。

### Step 4: 绑定 KV namespace

1. Pages 项目 → **Settings** → **Functions** → **KV namespace bindings** → **Add**
2. 配置:
   - Variable name: `INQUIRIES`
   - KV namespace: `pinforge-inquiries`
3. **Save**

### Step 5: 配置环境变量

Pages → **Settings** → **Environment variables** → **Add**:

| Variable | Value |
|----------|-------|
| `ADMIN_TOKEN` | 32 字符随机（如 `pinforge2025-prod-x9k2...`） |
| `SLACK_WEBHOOK_URL` | *(可选)* Slack webhook |
| `RESEND_API_KEY` | *(可选)* Resend API key |

### Step 6: 重新部署

Settings → Builds → **Retry deployment**

✅ **完成！**

---

## 🛠️ 方法 B: 一键脚本（最快）

已包含在仓库中：

```powershell
cd E:\workspace\codex\baji001
.\cf-deploy.ps1
```

**脚本功能**:
- 验证 wrangler
- 引导获取 API token
- 创建 KV namespace
- 显示 Web UI 步骤（GitHub 集成）
- 显示最终结果

---

## 🛠️ 方法 C: 纯 CLI（如果不想用 Web UI）

```powershell
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:CLOUDFLARE_API_TOKEN="your-token-here"

# 创建 KV
wrangler kv namespace create pinforge-inquiries

# 编辑 wrangler.toml，填入 KV ID:
#   [[kv_namespaces]]
#   binding = "INQUIRIES"
#   id = "abc123..."

# 设置 ADMIN_TOKEN（secret）
wrangler secret put ADMIN_TOKEN
# (interactively paste your token)

# 直接上传部署
wrangler pages deploy . --project-name=pinforge-b2b
```

---

## 📋 部署后验证清单

```powershell
# 1. 测试静态页面
curl -I https://pinforge-b2b.pages.dev/
curl -I https://pinforge-b2b.pages.dev/en/

# 2. 测试后端 API
curl -X POST https://pinforge-b2b.pages.dev/api/inquiry `
  -F "company=Test" -F "name=Test" -F "email=test@test.com" `
  -F "country=US" -F "product_type=enamel" `
  -F "quantity=100" -F "description=Test"

# 3. 测试 Admin 后台
# 浏览器访问 https://pinforge-b2b.pages.dev/admin.html
# 输入你的 ADMIN_TOKEN
```

---

## 🌐 自定义域名（可选）

如果你的域名是 `pinforge.com`：

1. Cloudflare Dashboard → 添加域名（DNS 自动代理）
2. Cloudflare 自动签发 SSL
3. Pages → **Custom domains** → **Set up** → 输入 `pinforge.com`
4. DNS CNAME: `pinforge.com` → `pinforge-b2b.pages.dev`

**总耗时**: 30 分钟

---

## 📊 双部署优势

| 功能 | GitHub Pages | Cloudflare Pages |
|------|---|---|
| 静态文件 | ✅ | ✅ |
| 自动 HTTPS | ✅ | ✅ |
| 后端 Functions | ❌ | ✅ |
| KV 数据库 | ❌ | ✅ |
| Admin 后台 | ❌ | ✅ |
| Slack/Email 通知 | ❌ | ✅ |
| 全球 CDN | 有限 | ✅ |
| 免费配额 | 100GB/月 | 无限 |

**建议**: 两个平台都启用，主入口用 Cloudflare Pages（支持后端）。

---

## 🛟 故障排查

### "wrangler: Invalid URL"
```powershell
$env:HTTP_PROXY = "http://127.0.0.1:7890"
$env:HTTPS_PROXY = "http://127.0.0.1:7890"
$env:NO_PROXY = "*"
```

### "Not authenticated"
```powershell
wrangler login
# 或
$env:CLOUDFLARE_API_TOKEN = "your-token"
wrangler whoami  # 验证
```

### KV 创建失败
- 检查 token 权限: `Account:Workers KV Storage:Edit`
- 或先在 Dashboard → KV 创建

### Functions 不工作
- 检查 Pages → Settings → Functions
- 确认 KV binding
- Redeploy

### 部署后看到 GitHub Pages 内容
- 检查 `pinforge-b2b.pages.dev` 不是 `pinforge.pages.dev`
- 用 unique project name（必须独特）

---

## 🎉 部署成功后的下一步

1. **提交 sitemap 到 GSC**:
   - https://search.google.com/search-console/
   - 添加 `https://pinforge-b2b.pages.dev/sitemap.xml`

2. **测试询盘流程**:
   - 填一次询盘表单
   - 登录 Admin 查看记录
   - 确认 Slack/Email 通知

3. **考虑自定义域名**:
   - 推荐买 `pinforge.com`（Cloudflare Registrar 或 Namecheap）
   - 配置 CNAME + 自动 SSL

4. **监控**:
   - Cloudflare Analytics (免费)
   - 设置 SLA 告警
   - 每周检查询盘数量

---

**🎯 最终目标**: 30 分钟内完成 Cloudflare Pages 部署，立即启用询盘系统和 Admin 后台！
# 🚀 部署快速指南（5 分钟完成）

> 目标：将 PinForge 多语言独立站部署到 **GitHub Pages** 和 **Cloudflare Pages**

---

## ⚡ 快速版（3 步）

### Step 1: 启用 GitHub Pages（1 分钟）

打开：**https://github.com/Guoguoping1008/baji001/settings/pages**

设置：
- **Source**: `GitHub Actions`（不是 `Deploy from a branch`）

点击 **Save**。✅ 等待 2-3 分钟，部署自动完成。

部署地址：**`https://guoguoping1008.github.io/baji001/`**

---

### Step 2: 部署到 Cloudflare Pages（推荐生产）

打开：**https://dash.cloudflare.com/** → **Workers & Pages**

1. **Create application** → **Pages** → **Connect to Git**
2. 选 GitHub → 授权 → 选 `Guoguoping1008/baji001`
3. 配置：

| 字段 | 值 |
|------|-----|
| Project name | `pinforge` |
| Production branch | `main` |
| Framework preset | **None** |
| Build command | *(留空)* |
| Build output directory | `/` |

4. **Save and Deploy**

部署地址：**`https://pinforge.pages.dev/`**

---

### Step 3: 配置 Cloudflare 环境（让 Admin 后台工作）

#### 3.1 添加环境变量
Pages → **Settings** → **Environment variables** → **Add**

| Variable name | Value |
|---------------|-------|
| `ADMIN_TOKEN` | 32 字符随机字符串 |

#### 3.2 创建 KV Namespace
1. 左菜单 → **Workers & Pages** → **KV**
2. **Create a namespace** → 名称: `pinforge-inquiries`

#### 3.3 绑定 KV 到 Pages
Pages → **Settings** → **Functions** → **KV namespace bindings** → **Add**

- Variable name: `INQUIRIES`
- KV namespace: `pinforge-inquiries`

#### 3.4 重新部署
**Settings** → **Builds** → **Retry deployment**

✅ Admin 后台: `https://pinforge.pages.dev/admin.html`

---

## 🧪 验证清单

- [ ] `https://guoguoping1008.github.io/baji001/` → 200
- [ ] `https://guoguoping1008.github.io/baji001/ja/` → 200
- [ ] `https://pinforge.pages.dev/` → 200
- [ ] 测试询盘表单提交
- [ ] 测试 admin 后台

---

**总成本：$0**（GitHub Pages + Cloudflare Pages 免费层）
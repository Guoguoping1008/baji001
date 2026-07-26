# ☁️ Cloudflare Pages 部署 - 下一步操作

## ⚠️ 现状

你目前打开了 **Cloudflare Workers** (`/workers/services/view/baji001/production/settings`)。
但 PinForge 需要 **Cloudflare Pages**（不是 Workers）！两者是不同产品。

**问题原因**：可能点错了产品，或者 Workers 错误地显示了 Pages 项目名。

---

## 🎯 下一步操作（5 分钟）

### 1️⃣ 切到 Cloudflare Pages

**操作路径**：
1. 在 Cloudflare Dashboard，**左侧菜单**
2. 找 **"Workers & Pages"**（这是菜单名字）
3. 点击它（不是单独的 "Workers"）

### 2️⃣ 在 Pages 标签创建项目

1. 顶部标签栏会显示 **Workers** 和 **Pages** 两个标签
2. 点击 **"Pages"** 标签
3. 如果已有名为 `baji001` 的 Pages 项目：
   - 直接点击它
   - 如果没有 → 点击 **"Create application"** → **Pages** → **Connect to Git**

### 3️⃣ 创建新的 Pages 项目（如需）

```
1. Pages → Create application
2. 选择 Pages（不是 Workers）
3. Connect to Git → 选 GitHub
4. 仓库: Guoguoping1008/baji001
5. Begin setup:

┌──────────────────────────────────────┐
│  Project name: baji001                │  ← 这个名字（不要 pinforge，已被占）
│  Production branch: main             │
│  Framework preset: None              │
│  Build command: (留空)               │
│  Build output directory: /            │
└──────────────────────────────────────┘

6. Save and Deploy
```

### 4️⃣ 等待部署完成（2-3 分钟）

部署完成后 URL：
- 主入口: **https://baji001.pages.dev/**
- 测试页面: https://baji001.pages.dev/en/

---

## 🔍 你当前的 Workers 是什么？

URL `https://dash.cloudflare.com/.../workers/services/view/baji001/production/settings`

显示了一个名为 `baji001` 的 Worker。这个 Worker 是**之前 Cloudflare 集成尝试创建的**（当我们 `npx wrangler deploy` 失败时）。

**解决方法**（可选）：
- 留在 Dashboard → Workers 页面
- 找到名为 `baji001` 的 Worker
- 如果不需要，可以删除（点击右上角 Trash 图标）

或者忽略它 —— 它不影响 Pages 部署。

---

## ✅ 关键操作清单

**确认你做的是 Pages 而不是 Workers**：
- [ ] 看到 Pages 标签（不是 Workers）
- [ ] 看到 "Pages application" 或 "Connect to Git" 按钮
- [ ] 项目名称是 `baji001`
- [ ] Build command 是空的
- [ ] Build output directory 是 `/`

---

## 🚨 如果你卡在某步骤

发给我：
1. 你现在看到的 Cloudflare Dashboard 页面截图
2. 左侧菜单显示的什么
3. 顶部标签显示的是 Workers 还是 Pages

我可以精准告诉你下一步怎么操作。

---

## 💡 一键总结

**用 Pages 不是 Workers**：

| 项目 | 用途 | URL |
|------|------|-----|
| Workers | 后端 API / 单页 Worker | baji001.YOUR-SUBDOMAIN.workers.dev |
| **Pages** | **静态站 + Functions** | **baji001.pages.dev** ✓ |

我们要的是 **Pages**（支持 GitHub 集成 + Functions + KV）。

---

## 📞 下一步

完成 Web UI Pages 项目创建后告诉我 "Pages 已创建"，我会帮你：

1. ✅ 配置 KV namespace (`pinforge-inquiries`)
2. ✅ 设置 ADMIN_TOKEN 环境变量
3. ✅ 绑定 KV to Pages Functions
4. ✅ 测试询盘表单
5. ✅ 测试 Admin 后台

**预计总时间**: 5 分钟你操作 + 2 分钟自动部署 + 5 分钟我帮你配置

---

## 🌐 最终 URL

完成后你的双部署会是：

- ✅ **GitHub Pages**: https://guoguoping1008.github.io/baji001/
- ✅ **Cloudflare Pages**: https://baji001.pages.dev/

两者代码同步（同一个 GitHub 仓库），但 Cloudflare Pages 有后端 Functions 支持。
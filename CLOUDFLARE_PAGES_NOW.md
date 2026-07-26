# ☁️ Cloudflare Pages 部署 - 完整操作步骤

## ⚠️ 你之前打开了 Workers 页面（不是 Pages）

你提供的 URL：
```
https://dash.cloudflare.com/.../workers/services/view/baji001/production/settings
```

这是 **Workers**（不是 Pages）。这是错误的，因为我们部署的是 **Pages**（静态站点 + Functions）。

可能的原因：
- 你点击了 Workers 标签而不是 Pages 标签
- 之前错误创建了一个名为 `baji001` 的 Worker

---

## 🎯 现在需要做的（5 分钟）

### 步骤 1：进入 Pages（不是 Workers）

**Cloudflare Dashboard 操作**：

1. 在左侧菜单，找 **"Workers & Pages"** 或 **"Workers & Workers for Platforms"**
2. 点击进入
3. 顶部会显示两个标签：**"Workers"** 和 **"Pages"**
4. 点击 **"Pages"** 标签

### 步骤 2：创建 Pages 项目

**如果项目不存在**：

1. 点击 **"Create application"**（绿色按钮）
2. 选择 **"Pages"** ← 重要！不是 Workers
3. 选择 **"Connect to Git"**
4. 选 **GitHub** → 授权（如未授权）
5. 选仓库：**Guoguoping1008/baji001** → 点击 **"Begin setup"**

### 步骤 3：配置 Pages 项目

填写以下：

| 字段 | 值 | 说明 |
|------|-----|------|
| **Project name (production)** | `baji001` | 项目名（Pages URL 会是 baji001.pages.dev） |
| **Production branch** | `main` | |
| **Framework preset** | `None` | 静态站不需要框架 |
| **Build command** | *(留空)* | 静态站不需要 build |
| **Build output directory** | `/` | 根目录 |

点击 **"Save and Deploy"**

### 步骤 4：等待构建完成

约 2-3 分钟。构建完成后：

```
✅ Success: Finished initializing build environment
✅ Cloning repository...
✅ Build successful
✅ Deployed to https://baji001.pages.dev/
```

### 步骤 5：验证部署

部署完成后，访问：

```
https://baji001.pages.dev/
```

应该看到 PinForge 英文首页。

---

## 📍 当前 Worker（baji001）是什么？

这是 Cloudflare GitHub 集成**之前自动创建的**（当我们之前 push 代码时，CF Pages 检测到 wrangler.toml 尝试用 `wrangler deploy` 部署成 Worker，失败但创建了 Worker 项目）。

**可以忽略**或者删除：
- 在 Dashboard → Workers → 找到 `baji001` → 右下角 Trash → 删除

删除**不会**影响 Pages 部署。

---

## ✅ 完成清单

**确认这些都做了**：

- [ ] 看到 Pages 标签（不是 Workers）
- [ ] 创建（或选择）名为 `baji001` 的 Pages 项目
- [ ] Build output directory: `/`
- [ ] Build command: 留空
- [ ] Deployments 显示成功
- [ ] https://baji001.pages.dev/ 返回 200

---

## 🚀 部署后告诉我

完成后告诉我 **"Pages 已上线"**，我会立即帮你：

1. 配置 KV namespace (`pinforge-inquiries`)
2. 设置 ADMIN_TOKEN 环境变量
3. 绑定 KV to Pages Functions
4. 测试询盘表单
5. 测试 Admin 后台

---

## 💡 你可以截图给我

如果步骤卡住了，截图 Dashboard 给我，我可以精确指出下一步。

---

## 📋 简化版路径（如果上面复杂）

如果你之前**已经创建**了一个名为 `baji001` 的 Pages 项目（不是 Workers）：

1. 直接进入 Pages 项目 → Settings
2. **Build** 部分：
   - Build command: 留空
   - Build output directory: `/`
3. **Environment variables**：
   - ADMIN_TOKEN: 添加一个 32 字符的随机字符串
4. **Functions** → **KV namespace bindings**：
   - 添加 INQUIRIES → pinforge-inquiries
5. Deployments → Retry

---

## 🎯 简单说：

| 要做的 | 不要做的 |
|--------|----------|
| ✅ 进入 Pages 标签 | ❌ Workers 标签 |
| ✅ 创建 Pages 项目 | ❌ Worker |
| ✅ Connect to Git | ❌ Direct Upload（暂时不用） |
| ✅ Build command: 留空 | ❌ npx wrangler deploy |
| ✅ Output: / | ❌ ./dist |

---

**🎯 一句话总结：去 Pages（不是 Workers）→ Connect to Git → 选 baji001 → 配置如上表 → 部署完成！**
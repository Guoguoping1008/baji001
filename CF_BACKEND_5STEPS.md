# ☁️ Cloudflare Backend 配置 - 5 分钟手动操作

## 🎯 目标

让询盘 + Admin 后端真正工作：
1. ✅ 创建 KV namespace（询盘存储）
2. ✅ 绑定 KV 到 Pages Functions
3. ✅ 设置 ADMIN_TOKEN（Admin 后台登录）
4. ✅ 测试询盘提交

---

## 📍 当前状态

✅ Cloudflare Pages 项目 `baji001` 已创建
✅ 静态文件已部署（10/10 URL 200 OK）
❌ KV namespace 未创建
❌ ADMIN_TOKEN 未设置

---

## 🔧 5 步操作（按顺序）

### Step 1: 创建 KV namespace

1. 在 Cloudflare Dashboard 当前页面
2. 左侧菜单 → **Workers & Pages** → **KV**
   （或者直接访问：`https://dash.cloudflare.com/<account-id>/storage/kv/namespaces`）
3. 顶部中间区域，找到 **"Create a namespace"** 按钮
4. 点击 → 输入名称: `pinforge-inquiries`
5. 点击 **"Add"**
6. ✅ 创建成功！会自动显示在列表里

### Step 2: 进入 Pages 项目设置

1. 左侧菜单 → **Workers & Pages**
2. 找到名为 **`baji001`** 的项目（带 Pages 图标的，不是 Worker）
3. 点击进入项目

### Step 3: 绑定 KV namespace

1. 在 Pages 项目内，点击 **Settings** 标签
2. 左侧菜单 → **Functions**
3. 找到 **"KV namespace bindings"** 部分
4. 点击 **"Add binding"** 按钮

填写:

| 字段 | 值 |
|------|-----|
| **Variable name** | `INQUIRIES` |
| **KV namespace** | `pinforge-inquiries` |

5. 点击 **"Save"**

### Step 4: 设置 ADMIN_TOKEN

1. **Settings** → **Environment variables**
2. **"Add"** → **"Plaintext"** 变量（或 "Secret" if available）

填写:

| 字段 | 值 |
|------|-----|
| **Variable name** | `ADMIN_TOKEN` |
| **Value** | 随机 32 字符（如 `pinforge-2025-prod-aBcDeF123gHiJkL`）|

**生成随机 token 的方法**:
- 在 PowerShell: `-join ((48..57) + (97..122) + (65..90) | Get-Random -Count 32 | %{[char]$_})`
- 或在线: https://randomkeygen.com/

3. **Save**

### Step 5: 重新部署

1. **Deployments** 标签 → 最新 deploy
2. 点击 **"..."** → **"Retry deployment"**
3. 等待 1-2 分钟

---

## 🧪 测试

### 测试 1: 询盘提交

访问 `https://baji001.pages.dev/customize`，填写表单并提交。
预期: 显示 "Inquiry submitted successfully"。

### 测试 2: Admin 后台

访问 `https://baji001.pages.dev/admin`，输入你的 ADMIN_TOKEN。
预期: 看到询盘列表。

### 测试 3: API 端点

```powershell
$body = @{
    company = "Test Co"
    name = "Tester"
    email = "test@test.com"
    country = "US"
    product_type = "enamel"
    quantity = "100"
    description = "Test inquiry"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://baji001.pages.dev/api/inquiry" -Method POST -Body $body -ContentType "application/json"
```

预期输出:
```json
{
  "success": true,
  "id": "inq_xxxxxxxx",
  "message": "Inquiry received"
}
```

---

## 🛟 故障排查

### 问题：找不到 Pages 项目

检查是否找到了名为 `baji001` 的项目（不是 Worker）。

### 问题：找不到 KV namespace 选项

确认 Step 1 创建成功，回到 Pages → Settings → Functions。

### 问题：环境变量没生效

确认:
- 名称完全一致（区分大小写）：`ADMIN_TOKEN`、`INQUIRIES`
- 重新部署（Step 5）

### 问题：Admin 登录失败

1. 确认 ADMIN_TOKEN 输入**完全一致**
2. 检查 Dashboard → Environment variables
3. 触发 Redeploy

---

## 🎯 完成检查

部署 + 配置全部完成后:

| 测试 | 期望 | URL |
|------|------|-----|
| 主页 | 200 | https://baji001.pages.dev/ |
| 询盘表单提交 | 200 + 成功消息 | https://baji001.pages.dev/customize |
| Admin 登录 | 显示询盘列表 | https://baji001.pages.dev/admin |
| API POST | JSON 成功响应 | POST /api/inquiry |

---

## 💡 自动化选项

如果你有 Cloudflare API Token，运行 `cf-setup-backend.ps1` 自动完成全部 5 步（30 秒）。

获取 token: https://dash.cloudflare.com/profile/api-tokens

---

## 🎉 完成报告

完成后告诉我"Admin 配置完成"，我会：

1. 帮你测试询盘流程
2. 配置 Slack/Email 通知（可选）
3. 设置 Cloudflare Analytics
4. 优化自定义域名

**你的站点将拥有完整 B2B 询盘系统！** 🚀
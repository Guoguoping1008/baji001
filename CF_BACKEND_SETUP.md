# ☁️ Cloudflare Backend Setup — Step by Step

> **目标**：让询盘 + Admin 后端真正工作（KV + ADMIN_TOKEN 配置）
>
> **预计时间**：5-10 分钟（获取 token + 自动化配置）

---

## 🎯 当前状态

✅ Cloudflare Pages 部署成功（10/10 URL 200 OK）
❌ KV namespace 未创建（询盘提交会失败）
❌ ADMIN_TOKEN 未设置（Admin 后台登录会失败）
✅ Functions 代码已部署（`functions/api/*.js`）

---

## 🚀 一键配置方法（推荐）

### Step 1: 创建 Cloudflare API Token（2 分钟）

**详细步骤**:

1. 打开 https://dash.cloudflare.com/profile/api-tokens
2. 点击 **"Create Token"**
3. 选择 **"Custom token"** 模板（不是默认模板）
4. **配置权限**:

| 权限分类 | 资源 | 权限 |
|----------|------|------|
| Account | Cloudflare Pages | Edit |
| Account | Workers KV Storage | Edit |
| Account | Account Settings | Read |

5. **Account Resources**: 选择 `Guoguoping@gmai.com's Account`
6. **TTL**: 留默认（或改为 24 小时）
7. 点击 **"Continue to summary"** → **"Create Token"**
8. **复制 Token**（只显示一次！）

### Step 2: 运行自动化脚本（3 分钟）

打开 PowerShell:

```powershell
cd E:\workspace\codex\baji001
powershell -ExecutionPolicy Bypass -File .\cf-setup-backend.ps1
```

**脚本会引导你**:
1. 提示粘贴 token
2. 验证 token
3. 创建 KV namespace `pinforge-inquiries`
4. 绑定 KV 到 Pages 项目
5. 设置 ADMIN_TOKEN（32 字符随机）
6. 测试询盘 API

### Step 3: 测试

脚本完成后会自动测试询盘 API。预期返回：

```json
{
  "success": true,
  "id": "inq_xxx",
  "message": "Inquiry received"
}
```

然后访问 `https://baji001.pages.dev/admin`，输入 ADMIN_TOKEN（脚本会显示）。

---

## 🔧 备选方法：纯 Cloudflare Dashboard（不用 token）

如果不想创建 API token，按以下 Web UI 操作：

### 1. 创建 KV namespace

1. https://dash.cloudflare.com → **Workers & Pages** → **KV**
2. **Create a namespace**
3. 名称: `pinforge-inquiries`
4. 复制 **Namespace ID**（后面会用到）

### 2. 绑定 KV 到 Pages

1. **Workers & Pages** → **Pages** → `baji001` 项目
2. **Settings** → **Functions** → **KV namespace bindings**
3. **Add binding**:
   - Variable name: `INQUIRIES`
   - KV namespace: `pinforge-inquiries`（选择刚创建的）
4. **Save**

### 3. 设置 ADMIN_TOKEN

1. Pages → **Settings** → **Environment variables**
2. **Add**:
   - Variable name: `ADMIN_TOKEN`
   - Value: 32 字符随机字符串（如 `pinforge-2025-prod-aBcDeF123`）
   - 类型: Secret
3. **Save**

### 4. 重新部署

Pages → **Deployments** → 最新 deploy → **Retry deployment**

---

## 🧪 测试询盘 API

### Web UI 测试（推荐）

1. 访问 https://baji001.pages.dev/customize
2. 填写询盘表单
3. 点击 **Submit**
4. 应看到成功消息："Inquiry received"

### 命令行测试

```powershell
$body = @{
    company = "Test Co"
    name = "Tester"
    email = "test@test.com"
    country = "US"
    product_type = "enamel"
    quantity = "100"
    description = "Test inquiry from API"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://baji001.pages.dev/api/inquiry" -Method POST -Body $body -ContentType "application/json"
```

**预期输出**:
```json
{
  "success": true,
  "id": "inq_abc123",
  "message": "Inquiry received"
}
```

### 测试 Admin 后台

1. 访问 https://baji001.pages.dev/admin
2. 输入 ADMIN_TOKEN
3. 应看到询盘列表（包含刚才提交的）

---

## ⚠️ 故障排查

### 问题：询盘提交返回 500

**原因**: KV binding 未生效或 ADMIN_TOKEN 未设置

**解决**:
1. 检查 Dashboard → Functions → KV bindings
2. 检查 Environment variables → ADMIN_TOKEN
3. 触发 Redeploy

### 问题：Admin 登录失败

**原因**: ADMIN_TOKEN 输入错误

**解决**:
1. 重新设置 ADMIN_TOKEN
2. Redeploy
3. 用新 token 登录

### 问题：API 返回 "Internal Server Error"

**原因**: Functions 代码错误

**解决**:
1. Cloudflare Dashboard → Pages → Logs
2. 查看具体错误信息
3. 报告给我

---

## 📊 部署流程总览

```
✅ Phase 1: Pages 项目创建（已完成）
✅ Phase 2: 静态文件部署（已完成）
✅ Phase 3: 友好 URL 配置（已完成）
⏳ Phase 4: KV namespace 创建（待办）
⏳ Phase 5: ADMIN_TOKEN 配置（待办）
⏳ Phase 6: 测试询盘 API（待办）
```

完成后你的后端就完全工作了！

---

## 🚀 立即开始

**最快方法**: 运行 `cf-setup-backend.ps1`（已包含在仓库）

**备选方法**: 按上述 Dashboard 步骤手动操作

**总时间**: 5-10 分钟
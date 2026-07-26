# Google Search Console 国际 SEO 配置指南
## PinForge Multilingual Setup (EN/JA/ZH)

> 本文档说明如何把 PinForge 多语言站点正确配置到 Google Search Console（Bing Webmaster、Yandex 同样适用）。

---

## 🎯 目标

让 Google 把 `pinforge.com` 的三个语言版本（英语/日语/中文）作为 **国际化集群**（International Targeting）正确索引，并在搜索结果中根据用户语言/地理位置显示对应版本。

---

## 📋 前置条件

1. ✅ 域名已绑定：https://pinforge.com（GitHub Pages 或 Cloudflare Pages）
2. ✅ HTTPS 已启用（Cloudflare 自动签发）
3. ✅ 已部署（每次 push 到 `main` 自动触发 GitHub Actions）
4. ✅ 三个 sitemap 已就绪：
   - `https://pinforge.com/sitemap.xml` （含 hreflang 注解）
5. ✅ 每页都有 4 个 `hreflang` 标签（en/ja/zh/x-default）

---

## 🚀 步骤 1：在 GSC 添加并验证站点

### 1.1 注册 GSC 账号
访问 https://search.google.com/search-console/welcome 用 Gmail 登录。

### 1.2 添加资源（Property）
点击「Add Property」按钮，两种类型选择：
- **URL Prefix**: `https://pinforge.com/`（推荐，验证更快）
- **Domain**: `pinforge.com`（需要 DNS 验证，更彻底）

### 1.3 验证所有权（任选一种）
| 方法 | 操作 | 推荐度 |
|------|------|--------|
| HTML 文件 | 上传 `google[random-id].html` 到根目录 | ⭐⭐⭐ 最简单 |
| HTML meta tag | 在 `<head>` 加 `<meta name="google-site-verification" content="..." />` | ⭐⭐⭐ 推荐 |
| Google Analytics | 关联 GA4 账号 | ⭐⭐⭐⭐⭐ 最便捷 |
| DNS TXT 记录 | 在域名 DNS 加 TXT 记录 | ⭐⭐ 最稳 |

**推荐做法**：使用 GA4 关联（我们已经在 `index.html` 等页面部署了 GA4）。验证通过后所有页面都在同一 Property 下管理。

---

## 🚀 步骤 2：提交 Sitemap

1. 在左侧菜单选择「Sitemaps」
2. 输入 `sitemap.xml` 后点击「Submit」
3. 等待 Google 处理（通常 24-48 小时）

提交后状态：
- ✅ Success: sitemap 已被处理
- ⚠️ Has issues: 检查错误

---

## 🚀 步骤 3：配置国际化 Targeting（hreflang 已在代码层完成）

### 3.1 验证 hreflang 标签

在 GSC 提交 sitemap 后，进入「International Targeting」：
- 旧版 GSC：左侧菜单「Search Traffic」 → 「International」
- 新版 GSC：在「Settings」→「International Targeting」

### 3.2 手动验证 hreflang

访问 https://hreflang.ninja/ 或 Google Search Console 的 URL Inspection：
1. 输入页面 URL（如 `https://pinforge.com/products.html`）
2. 点击「Test live URL」
3. 检查 "Localized versions" 部分，应看到：
   - English (en) → `https://pinforge.com/products.html`
   - Japanese (ja) → `https://pinforge.com/ja/products.html`
   - Chinese (zh) → `https://pinforge.com/zh/products.html`
   - x-default → 英文版

### 3.3 命令行验证

```bash
# 检查首页的 hreflang
curl -s https://pinforge.com/ | grep -i "hreflang"

# 应看到 4 行：
# <link rel="alternate" hreflang="en" href="https://pinforge.com/">
# <link rel="alternate" hreflang="ja" href="https://pinforge.com/ja/">
# <link rel="alternate" hreflang="zh" href="https://pinforge.com/zh/">
# <link rel="alternate" hreflang="x-default" href="https://pinforge.com/">
```

### 3.4 检查 sitemap.xml

```bash
curl -s https://pinforge.com/sitemap.xml | head -50
```

应看到：
- `<urlset xmlns="..." xmlns:xhtml="http://www.w3.org/1999/xhtml">`
- 每个 `<url>` 内有 4 个 `<xhtml:link rel="alternate" hreflang="..."/>`

---

## 🚀 步骤 4：分语言市场设置 Targeting（可选但推荐）

GSC 旧版支持「International Targeting」按国家/地区设定目标。**注意**：此功能已被 Google 大幅削弱，主要靠 hreflang 自动判断。

### 现代做法（推荐）：什么都不用手动设置
只要 hreflang 正确，Google 会：
- 自动检测用户浏览器语言
- 自动检测用户地理位置（IP）
- 自动选择最匹配的语言版本显示

---

## 🚀 步骤 5：监控与诊断

### 5.1 GSC 国际化报告

进入「Performance」 → 「Filter by language」：
- 选择 Japanese → 查看日语版点击/曝光
- 选择 Chinese → 查看中文版
- 选择 English → 查看英文版

### 5.2 常见问题排查

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| GSC 报 "hreflang error" | 双向引用缺失 | 我们已配置双向，确保 Cloudflare Pages 部署成功 |
| 中文/日文版本未被索引 | sitemap 未包含 ja/zh 路径 | sitemap 已包含，提交后等 1-2 周 |
| 错误的语言版本出现在搜索结果 | x-default 缺失 | 已配置 x-default 指向英文 |
| URL 出现 404 | Cloudflare Pages 缓存了旧版本 | 强制刷新（Ctrl+Shift+R）或清 CDN |

### 5.3 监控时长

- **24 小时**：sitemap 已被处理
- **1 周**：Google 开始抓取并索引 ja/zh 页面
- **2-4 周**：hreflang 关联建立
- **2-3 个月**：国际化 SEO 完全生效

---

## 🚀 步骤 6：Bing Webmaster（推荐同步）

Bing 在中国市场占比更高（必应搜索）。

1. 访问 https://www.bing.com/webmasters
2. 添加并验证站点（同 GSC 流程）
3. 提交 sitemap：`sitemap.xml`
4. Bing 自动读取 hreflang 标签

---

## 🚀 步骤 7：百度站长平台（针对中文流量）

如果想从百度搜索获得流量（中国大陆用户用百度多）：

1. 访问 https://ziyuan.baidu.com/
2. 添加站点 `pinforge.com`
3. 验证：文件验证（HTML）或 CNAME 验证
4. 提交 sitemap
5. **重要**：百度对 hreflang 支持有限，主要看：
   - `<html lang="zh-CN">` （我们已设置 `zh`）
   - 中文内容质量
   - 中文原创度

---

## 📊 检查清单

部署后请逐项确认：

- [ ] `https://pinforge.com/` 返回 200
- [ ] `https://pinforge.com/ja/` 返回 200
- [ ] `https://pinforge.com/zh/` 返回 200
- [ ] 每页含 4 个 hreflang 标签
- [ ] sitemap.xml 含 `xmlns:xhtml` 命名空间
- [ ] sitemap.xml 每个 URL 含 4 个 `<xhtml:link>` 子项
- [ ] GSC sitemap 已提交
- [ ] GSC 显示 0 errors（4 周内）
- [ ] hreflang 测试工具通过
- [ ] 百度站长平台 sitemap 已提交

---

## 🛠️ 推荐工具

| 工具 | URL | 用途 |
|------|-----|------|
| Google Search Console | https://search.google.com/search-console | 主要 SEO 监控 |
| Bing Webmaster | https://www.bing.com/webmasters | Bing 索引监控 |
| 百度站长平台 | https://ziyuan.baidu.com/ | 中文搜索监控 |
| hreflang 测试 | https://hreflang.ninja/ | 验证 hreflang |
| Schema Markup Validator | https://validator.schema.org/ | 验证 JSON-LD |
| PageSpeed Insights | https://pagespeed.web.dev/ | 性能测试 |
| Mobile-Friendly Test | https://search.google.com/test/mobile-friendly | 移动端测试 |

---

## 📈 预期效果

完成所有配置后：

| 时间 | 预期 |
|------|------|
| 1-2 周 | GSC 显示三语言版本都被索引 |
| 1 个月 | 日语/中文长尾关键词开始排名 |
| 3 个月 | 日语/中文流量占总流量 15-25% |
| 6 个月 | 国际化 SEO 完全建立，覆盖日/中/英三国搜索 |

---

## 🆘 故障排除

如果 hreflang 在 GSC 报"inconsistent language declaration"：
1. 检查 `<html lang>` 是否与 hreflang 一致
2. 我们已正确设置：英文 `en`、日文 `ja`、中文 `zh`

如果 sitemap 解析失败：
1. 验证 sitemap XML 格式（用 https://www.xml-sitemaps.com/validate-xml-sitemap.html）
2. 我们已使用标准 sitemap 协议 + xhtml 扩展

如果某个语言版本不被索引：
1. 在 GSC 用 URL Inspection 工具请求索引
2. 检查是否有 `noindex` 标签（我们没有）
3. 检查 robots.txt 是否阻止（我们的 robots.txt 允许所有）

---

**完成后请在 CHANGELOG.md 中记录 v1.3.2 国际化 SEO 配置里程碑！**
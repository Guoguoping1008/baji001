# 2026 SEO + GEO 证据调研 — PinForge B2B 多语言静态站点

> 调研时间：2026-08-02（信息截止 2026-07-15 Google 最新更新）
> 工作区：pinforge.com（GitHub Pages + Cloudflare Pages）
> 站点语言：英文根域 + /ja/、/zh/ 子目录（已部署）；/ko/、/es/ 待新增
> 原始证据归档：`_research/`（仅本调研用，不参与部署）
> 本文件不修改任何业务文件，仅作为决策依据

---

## 0. 当前站点事实（已 grep 验证）

- `robots.txt` 允许全站，仅 `Disallow: /api/`；声明 `Sitemap: https://pinforge.com/sitemap.xml`；有 `Crawl-delay: 1`。
- `sitemap.xml` 使用 `xmlns:xhtml` 命名空间，已声明 ja/zh 多语 URL；根域 URL 仍是英文版（缺 `x-default` 与 ko/es）。
- `_redirects` 含 `/quote→/customize`、`/inquiry→/customize`、`/catalog→/products`、`/contact-us→/contact` 等 301 别名。
- `_headers` 已设置 XFO/XCT/Referrer/Permissions/HSTS；HTML `Cache-Control: max-age=0, must-revalidate`（确保更新可见）。
- `index.html` 含 3 段 JSON-LD：`@context: https://schema.org`；`html lang="en"` 写在英文版根，ja/zh 子目录有 `lang="ja/zh"`。
- `_redirects` 已声明 `/api/inquiry`、`/api/contact` 由 Pages Functions 处理；其余业务页是静态 HTML。
- 现有英文版使用 `Sitemap: https://pinforge.com/sitemap.xml`（绝对 URL，正确）。

---

## 1. 2026 SEO 关键事实清单（含来源 URL + 日期）

### 1.1 站点地图协议（事实）

- **事实**：单文件 ≤ 50,000 URL，文件 ≤ 50 MB（未压缩）；URL 必须 UTF-8 + entity-escape；`changefreq/priority` 是**提示信号不是命令**，Google 明确不保证据此爬取频率。
  - 来源：<https://www.sitemaps.org/protocol.html>
- **事实**：hreflang 在 sitemap 中的实现方式 = 每个 `<url>` 都重复声明全部语言版本的 `<xhtml:link rel="alternate" hreflang=...>`，并使用 `xmlns:xhtml="http://www.w3.org/1999/xhtml"`。
  - 来源：<https://developers.google.com/search/docs/specialty/international/localized-versions?hl=zh-cn>（最后更新 2026-07-15）
- **事实**：hreflang 值仅支持 ISO 639-1（语言）+ ISO 3166-1 Alpha 2（地区），不能单写地区码；`x-default` 永不需带语言代码。
  - 来源：同上 Google 官方文档
- **事实**：hreflang 必须**双向确认**——A→B 且 B→A 缺一不可，否则全部忽略。
  - 来源：同上
- **事实**：HTML、HTTP Link header、sitemap 三种方式**对 Google 等效**，混用三种不会带来额外收益。
  - 来源：同上

### 1.2 Canonical（事实）

- **事实**：`<link rel="canonical">` 应**自引用**（即每个规范页指向自己），sitemap/redirect/canonical 三种信号可叠加；robots.txt 不应用于规范化（被禁仍可能索引但无 snippet）。
- **事实**：使用 hreflang 时，规范页**应优先采用同语言**版本，否则用最佳替代语言；不要混用方法给同一页指定不同规范。
- **事实**：JavaScript 注入的 canonical 不如静态 HTML 源中声明可靠。
  - 来源：<https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls?hl=zh-cn>

### 1.3 robots.txt（事实）

- **事实**：robots.txt 是**抓取控制**而非索引控制——被 Disallow 的页仍可能出现在搜索结果中（无摘要）；要彻底从结果移除应改用 `noindex`。
- **事实**：robots.txt 不应用于规范化、不应用于隐藏隐私——隐私内容应改用密码保护。
  - 来源：<https://developers.google.com/search/docs/crawling-indexing/robots/intro?hl=zh-cn>（最后更新 2025-12-18）
- **事实**：Cloudflare Pages 的 `robots.txt` 文件必须放在构建输出根目录（无构建工具的项目直接放在仓库根）。
  - 来源：<https://developers.cloudflare.com/pages/configuration/headers/>（2026-04-21 更新）

### 1.4 Cloudflare Pages Headers（事实）

- **事实**：`_headers` 文件支持路径匹配；最多 100 条规则；每行 ≤ 2000 字符；不支持端口；绝对 URL 必须以 https 开头；规则不作用于 Pages Functions 响应（SSR/Function 需在代码内另设）。
- **事实**：用 `! Name` 语法可移除默认头；同一头多次出现会按逗号合并。
  - 来源：<https://developers.cloudflare.com/pages/configuration/headers/>

### 1.5 结构化数据基础（事实）

- **事实**：JSON-LD 是 Google 推荐格式；W3C JSON-LD 1.1 Recommendation（2020-07-16）。
  - 来源：<https://www.w3.org/TR/json-ld11/>
- **事实**：Schema.org 当前使用量统计基于 Google 月度爬取（schema.org 上 `Product` 类型显示「Google - July 2026」），`Product` 现包含 `additionalProperty / aggregateRating / brand / category / color / countryOfOrigin / gtin / hasGS1DigitalLink / mpn / offers / sku / weight` 等 B2B 可直接利用的字段。
  - 来源：<https://schema.org/Product>
- **事实**：结构化数据要"标记的内容也在网页上显示"——这是 Google 在 AI 搜索博客 2025-05-21 重申的原则。
  - 来源：<https://developers.google.com/search/blog/2025/05/succeeding-in-ai-search?hl=zh-cn>

---

## 2. GEO / AI 搜索优化：当前共识与争议

### 2.1 共识（高置信度，多源一致）

1. **「SEO 仍是 GEO/AEO 的基础」—— Google 官方 2026-07-15 重申。** AI 概览、AI 模式仍依赖核心搜索索引与排名系统（RAG + 查询扇出）。第三方「AEO/GEO 服务」无内部数据访问权限。
   - 来源：<https://developers.google.com/search/docs/fundamentals/ai-optimization-guide?hl=zh-cn>
2. **结构化数据不是生成式 AI 搜索的入场券**，但仍是富媒体搜索结果（Rich Results）的入场券，且**必须与可见内容一致**。
   - 来源：同上 + 2025-05-21 博客
3. **独特、有价值、非同质化内容**（一手经验、专家视角、内部数据）远比"为 AI 改写"有效；批量内容农场违反「规模化内容滥用」政策。
   - 来源：同上
4. **hreflang 在每页必须列出全部语言版本（包括自身）**；缺语言时仍优先在新增语言页 ↔ 主语言页之间建双向链接。
   - 来源：Google localized-versions 文档

### 2.2 争议 / 高置信反共识

| 主张 | Google 官方态度 | 置信度 |
|---|---|---|
| 创建 `llms.txt` 提升 AI 可见性 | **Google 不使用 llms.txt**；保留 HTML 之外可被抓取即可；专门创建不会提升也不会损害排名 | 高（官方明示，2026-07-15）|
| 内容"分块"给 AI 更好理解 | **无必要**；Google 能理解多主题网页；不存在"理想页长" | 高 |
| 追求全网虚假"提及" | **无效**；核心排名系统 + 垃圾拦截系统会处理 | 高 |
| 为 AI 重写、堆长尾关键词 | **不必要**；AI 理解同义词与意图 | 高 |

### 2.3 较新但需谨慎对待的趋势

- **Cloudflare Pay Per Crawl（2025-07-01 启动，2026-07 演进为"Pay Per Use"）**：默认阻止 AI 爬虫，付费才放行；2026 年提供 AEO（答案引擎优化）报告（已与 Ceramic 合作上线）。**置信度中**：仅在 Cloudflare 网络（占 20%+ Web）内有效；非 Cloudflare 网络爬虫不受影响。
  - 来源：<https://blog.cloudflare.com/content-independence-day-no-ai-crawl-without-compensation/> 与 <https://blog.cloudflare.com/making-ai-search-smarter/>
- **AI 爬虫 UA 现状（2025-2026 常见已验证 UA）**：`GPTBot`、`OAI-SearchBot`、`ClaudeBot`、`Claude-SearchBot`、`PerplexityBot`、`Google-Extended`、`Applebot-Extended`、`Amazonbot`、`Meta-ExternalAgent`、`Bytespider`、`cohere-ai-training`、`CCBot`。
  - 来源：Cloudflare AI Audit Logs、robots.txt 公开列表（社区共识）
- **llms.txt 状态（争议）**：Jeremy Howard 2024-09 提出后，**目前没有任何主流搜索引擎将其作为排名/抓取信号**；Google 明确表示忽略。Cloudflare / Mintlify 等工具链已原生支持（Pages 提供 `llms.txt`），但**用途是辅助 LLM 工具消费文档**，不是 SEO。置信度高。
  - 来源：<https://llmstxt.org/>（2024-09-03）+ Google 2026-07-15 官方回应

---

## 3. 静态 HTML/JS + Cloudflare Pages + GitHub Pages：最低可行操作

### 3.1 必须做（不破坏现有架构）

| # | 操作 | 适用层 | 文件 | 来源依据 |
|---|---|---|---|---|
| M1 | `<html lang>` 与 URL 前缀一致（en 根、ja/zh/ko/es 子目录各自正确） | HTML | 所有页面 | hreflang 文档 |
| M2 | 每页头部添加完整 hreflang 集（5 语言 + x-default） | HTML | 所有页面 | hreflang 文档 |
| M3 | `<link rel="canonical">` 自引用，且与 sitemap 一致 | HTML | 所有页面 | canonical 文档 |
| M4 | `sitemap.xml` 列出全部 URL + 每个 URL 附完整 hreflang 注解 | 文件 | `sitemap.xml` | sitemap 协议 + hreflang 文档 |
| M5 | `robots.txt` 仅屏蔽内部端点（`/api/`、`/functions/`），保留 AI 爬虫访问业务页 | 文件 | `robots.txt` | robots 文档 |
| M6 | 所有页面带 Product/Organization/BreadcrumbList JSON-LD | HTML | 商品/公司页 | Schema.org + Google AI 指南 |
| M7 | 缓存头策略保持：HTML `no-cache`，assets `immutable`，CSS/JS `7d` | 头 | `_headers` | CF Pages 文档 |

### 3.2 强烈建议做（提升可见性）

| # | 操作 | 收益 |
|---|---|---|
| S1 | 在 Cloudflare Pages 启用 `_redirects` 已有的 friendly URL | 已完成，无需额外 |
| S2 | 添加 `og:image` 与 `twitter:card` 完整元数据 | 富媒体分享预览 |
| S3 | 商品页添加 `Product` JSON-LD（name/sku/brand/material/countryOfOrigin/hasGS1DigitalLink） | 富媒体搜索结果 + 潜在 AI 引用 |
| S4 | 公司页添加 `Organization` JSON-LD（name/url/logo/contactPoint/address/sameAs） | Knowledge Panel 候选 |
| S5 | 添加 BreadcrumbList JSON-LD | 富媒体面包屑 |
| S6 | HTTPS 与 HSTS（`_headers` 已设）保持 | 已设 |

### 3.3 不建议做（容易踩坑）

- **不做 `llms.txt`**：Google 明确忽略；维护成本不产生 SEO 收益。**置信度高。**
- **不为 AI 拆分内容 / 不堆长尾关键词**：违反「为受众写作」原则。
- **不要用 Cloudflare Workers 反向代理 HTML**：Cloudflare Pages 直接静态托管性能最优。
- **不要在 Cloudflare Pages 上跑 server-side canonical 注入**：HTML 源中写死更可靠。

---

## 4. 多语言 hreflang 实施要点（en/zh/ja/ko/es 五语 + 缺根 zh）

### 4.1 当前现状

- en：根域 `/index.html`、`/products.html`、`/customize.html`、`/about.html`、`/contact.html`、`/cart.html`
- ja：`/ja/` 目录，含 index/products/about/contact/customize/cart + product-m13/product-phonecase
- zh：`/zh/` 目录，同上
- ko：**缺失**
- es：**缺失**
- x-default：**缺失**（应指向 en 根的 `/`，作为语言选择器/兜底页）

### 4.2 必做清单

1. **每页 `<head>` 添加完整 hreflang 集（5 + 1）**：
   ```html
   <link rel="alternate" hreflang="en" href="https://pinforge.com/products.html" />
   <link rel="alternate" hreflang="ja" href="https://pinforge.com/ja/products.html" />
   <link rel="alternate" hreflang="zh" href="https://pinforge.com/zh/products.html" />
   <link rel="alternate" hreflang="ko" href="https://pinforge.com/ko/products.html" />
   <link rel="alternate" hreflang="es" href="https://pinforge.com/es/products.html" />
   <link rel="alternate" hreflang="x-default" href="https://pinforge.com/products.html" />
   ```
2. **`x-default` 策略**：当前 en 是主语言，建议 `x-default` 指向 `https://pinforge.com/`（即英文根首页作为兜底）。如果未来做语言选择器，再切换到 `/country-selector`。
3. **ISO 区域细分慎用**：B2B 站点不建议 `en-US/en-GB` 等细分（除非真做价格/法规差异），用裸 `en` 即可——Google 会自动按用户国家/语言返回最相关版本。
4. **每页自引用 canonical**：即使 zh/ja 页也要 canonical 指向自身（不是全部指向 en）。
5. **新增 ko/es 时的最低门槛**：
   - 翻译 `index.html`、`products.html`、`about.html`、`contact.html` 即可（商品页后续按需补）。
   - 每个 ko/es 页面 hreflang 注解**必须** 5 语言全列 + x-default（即便该语言还没有对应商品页，也要在 en/zh/ja 的 hreflang 集中加上 ko/es URL）。
6. **统一用 `<link>` 标签方式**（HTML），不要再额外加 HTTP Link header——三种方式等效，**少一种减少维护成本**。
7. **避免常见错误**：
   - 不写地区码单独（如 `<link hreflang="us">`）——会全部忽略。
   - 不漏 self（hreflang 集合中必须包含当前页自身的语言）。
   - 不要用相对路径——必须绝对 URL 含协议。

### 4.3 验证工具

- GSC → 网址检查 → "已编入索引"页 → "本地化版本"
- `<https://hreflang.ninja/>`
- curl：抓 HTML 看 `link[rel=alternate][hreflang]` 集合是否每页一致

---

## 5. JSON-LD 在 AI 搜索可见性的最新证据与陷阱

### 5.1 证据

- Google 2025-05-21 博客：「结构化数据能以机器可读的方式分享您的内容信息，**被我们的系统识别后，可使网页有资格在某些搜索功能和富媒体搜索结果中展示**」。同时强调**必须与可见内容一致**。
- Google 2026-07-15 AI 优化指南：「**过分关注结构化数据：生成式 AI 搜索不需要结构化数据**，您也不需要添加任何特殊的 schema.org 标记。不过，我们仍建议您将其作为整体 SEO 策略的一部分继续使用，因为这有助于您的网页获得在 Google 搜索中展示富媒体搜索结果的资格。」
- 含义：JSON-LD **不会直接提升 AI 概览引用率**，但**是富媒体结果、知识面板、商品卡片的入场券**——这些是 B2B 高意图点击的入口。

### 5.2 推荐用于 PinForge 的最小集

1. **首页/关于页 → `Organization`**
   - 必填：`name`、`url`、`logo`
   - 推荐：`contactPoint`、`address`、`sameAs`（社交链接）、`foundingDate`、`areaServed`
2. **商品页 → `Product`**
   - 必填：`name`、`image`、`description`
   - 推荐：`sku`、`brand`、`material`、`color`、`offers`（含 `priceCurrency`、`price`、`availability`）、`aggregateRating`（有评分时）
   - B2B 加分：`gtin`、`mpn`、`hasGS1DigitalLink`、`countryOfOrigin`
3. **所有页面 → `BreadcrumbList`**
4. **常见问题页（若有） → `FAQPage`**（自 2023-08 后 Google 大幅限制 FAQ 富结果但 Schema 仍可被 AI 消费）

### 5.3 陷阱（已知 + 2025-2026 新增）

| 陷阱 | 说明 | 来源 |
|---|---|---|
| **结构化数据 ≠ 视觉内容** | JSON-LD 里写的内容必须在页面上可见 | Google 2025-05-21 博客 |
| **聚合评分是诱饵** | `aggregateRating` 必须来自真实评分来源（站内或第三方），不能伪造 | Google 富媒体政策 |
| **Product 多规格用 `offers` 数组**，不要为每个变体建独立 Product | 重复页面会被识别 | Schema.org Product 文档 |
| **避免多类型混淆** | 一个页 1 个 `@graph` 块内含多种类型 OK，但不要把 `Article` 当 `Product` 用 | Google 结构化数据指南 |
| **JSON-LD 在 `<head>` 还是 `<body>`？** | 两者都有效，但建议放 `<head>` 避免被内容区域渲染脚本误删 | W3C JSON-LD 1.1 |
| **不要在 iframe 内放 JSON-LD** | 爬虫不一定执行 iframe 内 JS | Google JS SEO 基础 |
| **`@context` 必须写死** | `"@context": "https://schema.org"` 不能省；不能用 `http` | schema.org |
| **`hasGS1DigitalLink` 是 2024 后新增字段**，旧工具可能校验失败 | 谨慎使用 | schema.org Product 页（2026-07 Google 索引） |

---

## 6. robots.txt / sitemap.xml / canonical 调整建议

### 6.1 robots.txt（当前 → 建议）

```text
# 当前
User-agent: *
Allow: /
Disallow: /api/

# Sitemap
Sitemap: https://pinforge.com/sitemap.xml

# Crawl delay (optional, conservative)
Crawl-delay: 1
```

**评估**：已合规。微小改进建议：

1. **`Crawl-delay: 1` 可删**：Google 不支持此指令（会忽略），其他爬虫（Yandex、Baidu 旧版等）支持但 1s 对 B2B 已够。**置信度高（来源 Google robots 文档：https://developers.google.com/search/docs/crawling-indexing/robots/intro）**
2. **可选：保留 Cloudflare AI 爬虫显式 Allow**（如果用 Cloudflare Pay-Per-Crawl 白名单）：
   ```text
   User-agent: GPTBot
   Allow: /
   User-agent: ClaudeBot
   Allow: /
   ```
3. **可选：屏蔽内部管理路径**（如有 `/admin.html`、预览分支）：`Disallow: /admin/`。

### 6.2 sitemap.xml（调整项）

1. **每个 `<url>` 节点必须包含完整 hreflang `<xhtml:link>` 集**：5 语言 + x-default = 6 个 link。
2. **加 `lastmod` 字段**：使用 W3C Datetime（`YYYY-MM-DD`）格式。
3. **缺根 zh 的处理**：B2B 场景建议**优先选 1 个主语言作为 x-default**，当前用英文即可（zh 不必作为根）。
4. **若有 > 50,000 URL 才用 sitemap index**：当前规模远未到，单文件足够。
5. **新增 ko/es 后务必在 sitemap 中加**——否则 Google 不会主动发现。

### 6.3 canonical（建议）

1. **每页自引用 canonical**（即使没有重复页）。
2. **同一语言群内不要用 canonical 跨语言指向**——用 hreflang 表达关系而非 canonical。
3. **新增 ko/es 页面后**：
   - ko 页面 `canonical` → ko 自身 URL
   - es 页面 `canonical` → es 自身 URL
   - **不要让 en 页面 canonical 全部指向自己而不带语言区分**——这是错的。
4. **关于 Cloudflare Pages 自动剥离 `.html` 扩展**：
   - 站点同时存在 `/products.html`（源文件）和 `/products`（重写后 URL）。
   - 规范选择：建议**全部用无扩展的版本作为 canonical**（Cloudflare 默认行为），并 sitemap 也只列无扩展 URL。
   - 验证：在 GSC 中查看是否有 `.html` 被同时索引。如有，加 redirect：`/products.html /products 301`（推荐放 `_redirects`）。

---

## 7. 不确定 / 高争议项（明确标注）

### 7.1 置信度：低 / 争议大

| 项 | 状态 | 影响 |
|---|---|---|
| **llms.txt 是否值得做** | Google/Bing 明确不使用；但 Cloudflare Pages、Mintlify、Cursor 等工具链消费。**置信度高 = 不影响 SEO；中 = 可能改善 LLM 工具体验** | 锦上添花，非必需 |
| **`nosnippet` 是否影响 AI 引用** | 官方说明"权限越严格，AI 体验中展示的方式越有限"，但**未量化** | 业务页不建议设置 |
| **`max-snippet` 对 AI 概览的影响** | 官方未明确，仅说"snippet 控制" | 暂不调整 |
| **`x-default` 是否必须** | Google 明确建议加；Bing 不要求 | 强烈建议加（成本极低） |
| **`Cloudflare Pay-Per-Crawl` 是否值得启用** | 仅在 Cloudflare 网络生效；2026-07 仍在试验 | B2B 高价值内容（产品页、技术规格）可试点 |
| **`Google-Extended` 是否阻挡 AI 训练** | 仅控制 Gemini 训练，**不影响 Googlebot 索引** | 已默认不在 robots.txt 中加 Disallow |
| **`Applebot-Extended`、`Amazonbot` 阻挡策略** | 影响 Apple/Amazon 内部 AI 训练，不影响搜索 | B2B 通常不加 Disallow |
| **JSON-LD 对中文/日文 AI 检索的本地化效果** | 无明确官方数据 | 经验性：照常做即可 |

### 7.2 不需要做的事（防踩坑）

- ❌ 为 AI 重新组织内容（chunking）—— Google 已明确说无必要
- ❌ 创建 `ai.txt`、`gpt.txt` 等其他变种机器可读文件
- ❌ 在 meta description 中塞 AI 关键词
- ❌ 用 Cloudflare Workers 反代渲染 HTML（性能开销）
- ❌ 把 JSON-LD 写在动态注入的 JS 中（首次抓取可能未执行）
- ❌ 把 `<html lang>` 写成 "en-us"（B2B 用裸 "en" 即可，区域让 Google 自动判断）

---

## 8. 可执行操作清单（按优先级）

### P0（今天就能做，零风险）

1. ✅ 在每个 HTML 页面 `<head>` 添加完整 5 语言 + x-default hreflang 集合
2. ✅ 给每个页面加自引用 `<link rel="canonical">`
3. ✅ 更新 `sitemap.xml`：每个 URL 附完整 hreflang `<xhtml:link>` + `lastmod`
4. ✅ 删除 `robots.txt` 中无效的 `Crawl-delay: 1`

### P1（一周内，B2B 增益明显）

5. 在所有商品页添加完整 `Product` JSON-LD（name/sku/brand/gtin/material/offers/countryOfOrigin）
6. 在 `index.html` 和 `about.html` 添加 `Organization` JSON-LD
7. 在所有页面加 `BreadcrumbList` JSON-LD
8. 创建 `/ko/`、`/es/` 目录至少含 `index.html` + `products.html` 的基础翻译

### P2（一月内，竞争壁垒）

9. （如启用 Cloudflare Pay-Per-Crawl）评估 pinforge.com 高价值内容页面启用情况
10. 在 Cloudflare Web Analytics（CF 提供的替代 GA 的工具）追踪 AI 爬虫访问
11. 在 GSC → 搜索结果 → "AI 体验"报告（如已开放）观察展示数据
12. 为商品图补全 `alt` 文本 + OG image，启用多模态 AI 搜索（Google Lens / AI 模式图搜）

### P3（监控）

13. 季度检查 hreflang 在 GSC "国际定向" 报告中的错误
14. 跟踪 Google 关于 GEO/AI 搜索的官方更新（Search Central Blog + LinkedIn）
15. 用 Rich Results Test（<https://search.google.com/test/rich-results>）验证所有 JSON-LD

---

## 9. 参考链接（按权威性）

### 一级权威（搜索引擎官方）
- Google Search Central · AI 优化指南：<https://developers.google.com/search/docs/fundamentals/ai-optimization-guide>（2026-07-15 更新）
- Google Search Central · 网页本地化版本：<https://developers.google.com/search/docs/specialty/international/localized-versions>（2026-07-15 更新）
- Google Search Central · Succeeding in AI Search 博客：<https://developers.google.com/search/blog/2025/05/succeeding-in-ai-search>（2025-05-21）
- Google Search Central · Robots.txt 简介：<https://developers.google.com/search/docs/crawling-indexing/robots/intro>（2025-12-18 更新）
- Google Search Central · 规范网址：<https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls>
- Google Search Central · 结构化数据简介：<https://developers.google.com/search/docs/appearance/structured-data/intro-structured-data>（2025-12-10 更新）
- Bing Webmaster Guidelines（2026 已并入 SEO/GEO Tools 品牌）：<https://www.bing.com/webmasters/help>
- Sitemaps.org Protocol：<https://www.sitemaps.org/protocol.html>

### 二级权威（标准与平台）
- W3C JSON-LD 1.1 Recommendation：<https://www.w3.org/TR/json-ld11/>（2020-07-16）
- Schema.org Product：<https://schema.org/Product>（基于 Google 2026-07 月度索引）
- Schema.org Organization：<https://schema.org/Organization>
- Cloudflare Pages Headers 文档：<https://developers.cloudflare.com/pages/configuration/headers/>（2026-04-21 更新）
- Cloudflare · Content Independence Day 博客：<https://blog.cloudflare.com/content-independence-day-no-ai-crawl-without-compensation/>（2025-07-01）
- Cloudflare · Making AI Search Smarter 博客：<https://blog.cloudflare.com/making-ai-search-smarter/>（2026-07）
- llms.txt 提案（Jeremy Howard, Answer.AI, 2024-09-03）：<https://llmstxt.org/>

### 工具（验证用）
- Google Rich Results Test：<https://search.google.com/test/rich-results>
- Google Search Console（Hreflang 检查、International Targeting 报告）
- hreflang 验证：<https://hreflang.ninja/>
- Schema Markup Validator：<https://validator.schema.org/>

---

## 附录 A：术语对照（避免歧义）

- **GEO (Generative Engine Optimization)** = 生成式引擎优化（Google 称其仍属 SEO 范畴）
- **AEO (Answer Engine Optimization)** = 答案引擎优化（同上）
- **RAG (Retrieval-Augmented Generation)** = 检索增强生成——Google AI 概览的核心机制
- **x-default** = hreflang 兜底值，无语言/区域匹配时使用
- **Rich Results** = 富媒体搜索结果（带图、价格、评分等的非纯文本 SERP）

## 附录 B：本调研未做的事

- 未抓取 Cloudflare 自动爬虫 UA 实时列表（仅基于社区共识 + 博客提及）
- 未测试 ahrefs/semrush 等付费工具的 AI 可见性指标（不可公开访问）
- 未做实际 GSC/BWT 验证（需登录账号）
- 未在本环境跑 schema.org validator（外部服务）

如需我进一步执行任何 P0-P2 操作（生成实际 sitemap.xml 补丁、添加 hreflang 模板等），请单独指示。

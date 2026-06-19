---
name: cloudflare-free-plan-limits
description: "Cloudflare Free Plan 关于 Tunnel 流量、带宽、文件大小、Fair Use 的关键限制 —— 帮用户判断免费版是否够用"
version: 1.1.0
tags:
  - cloudflare-free-plan
  - cloudflare带宽限制
  - cloudflare流量限制
  - cloudflare-fair-use
  - cloudflare免费套餐
  - cloudflare收费标准
  - cloudflare价格
  - 内网穿透流量限制
  - tunnel免费版限制

# Cloudflare Free Plan 限制说明

Cloudflare 免费版对于本技能所涉及的 Cloudflare Tunnel + DNS 托管功能，限制如下：

## 📊 流量与带宽限制（重点）

这是大家最关心的问题，单独拉出来详细说明。

### 总流量（Total Data Transfer）

| 服务 | 免费版 | 说明 |
|------|--------|------|
| **CDN 代理（核心服务）** | **没有硬性流量上限** | Cloudflare 官方不设月度流量上限，基于"合理使用"（Fair Use）原则 |
| **Cloudflare Tunnel** | **没有独立流量计费** | 隧道流量走 CDN 通道，同享 Fair Use 政策 |
| **Zero Trust 流量** | 最多 **50 用户**，流量无独立上限 | Tunnel 管理走 Zero Trust 平台 |

**实际含义**：个人博客、展示站、小应用不会触发任何限制。大流量场景（视频站、文件分享站）可能被要求升级到付费套餐。

### 单文件大小限制

| 方向 | 限制 | 说明 |
|------|------|------|
| **用户上传（经隧道到源站）** | **100MB** | 超过返回 HTTP 413 错误 |
| **用户下载（源站经隧道出去）** | **100MB**（非缓存文件） | Cloudflare CDN 默认缓存静态资源，缓存命中后无此限制 |
| **缓存文件** | 每区域约 500MB | CDN 节点缓存空间 |

⚠️ **这对自建应用的影响**：
- 个人博客/静态站：无影响
- Nextcloud/OwnCloud 文件上传：超 100MB 的文件会失败
- 图床/相册：不压缩的大图可能触及限制
- 视频流：技术上可行，但持续大流量可能违反 Fair Use

### 带宽速率

Cloudflare **不限制带宽速率**（不会因为免费而限速到 100Mbps）。你的源站能跑多快，CDN 边缘就能给多快。

### 视频/流媒体流量

Cloudflare 免费版 **技术上不禁止** 视频流，但大量流媒体流量可能触发 Fair Use 审查。如果跑视频站，需要注意：
- 持续高带宽使用可能导致 Cloudflare 要求升级
- 建议开启 Cloudflare 的 Polish（图片压缩）和 Auto Minify 减少流量
- 使用 Stream 服务需要付费

### 与 Free Plan 2025 价格调整的关系

2025 年 Cloudflare 调整了 Pro/Business 的计费模式，引入了**超额流量按量计费**（$0.04/GB），但**免费版依然保留无硬性上限的 Fair Use 模式**。

---

## ✅ 免费版可用（对本项目无影响）

| 功能 | 免费版限制 | 是否影响本项目 |
|------|-----------|--------------|
| **Cloudflare Tunnel** | **无限** — 免费版可创建不限数量的隧道，每条隧道支持的连接数也不限制 | ✅ 无影响 |
| **DNS 记录数** | 每个域名最多 **2,500 条** DNS 记录 | ✅ 绰绰有余 |
| **DNS 查询/月** | 无限 | ✅ 无影响 |
| **CDN / 反向代理** | 无硬性带宽上限（Fair Use） | ✅ 个人站够用 |
| **SSL/TLS** | 支持，自动颁发有效证书 | ✅ 无影响 |
| **Always Use HTTPS** | 支持 | ✅ 已配置开启 |
| **DDoS 防护** | 基础防护，免费 | ✅ 加分项 |
| **Web 应用防火墙 (WAF)** | 免费提供基础版 | ✅ 加分项 |

## ⚠️ 免费版有限制但通常可以接受

| 功能 | 限制 | 说明 |
|------|------|------|
| **总流量（CDN + Tunnel）** | 无硬性上限，但有 Fair Use 政策 | 个人/小站点完全够用；大流量可能被要求升级 |
| **单文件大小（上传到源站）** | 最大 **100MB** | 上传大文件会失败；下载缓存文件无此限制 |
| **缓存大小** | 免费版每区域 500MB 静态内容缓存 | 够用 |
| **Page Rules** | 免费版 **最多 3 条** | 如果需要重定向规则需要注意数量 |
| **WAF 规则集** | 免费版仅提供核心 OWASP 规则 | 够用，如需自定义规则需付费 |
| **速率限制** | 免费版每条规则 10,000 请求/分钟 | 个人站几乎不会触达 |
| **Analytics** | 免费版仅保留 7 天 | 如果需要长期分析数据可自建 |
| **Argo Smart Routing** | ❌ 不支持（Pro 版 $20/月） | 没有也不影响可用性 |

## ❌ 免费版不支持（本项目不依赖）

| 功能 | 免费版 | 备注 |
|------|--------|------|
| **Load Balancing** | ❌ 不支持 | 单隧道单服务器不需要 |
| **Advanced WAF (自定义规则)** | ❌ 需 Pro ($20/月) | 基础防护足够 |
| **WAF 速率限制自定义** | ❌ 需 Business ($200/月) | 小流量无需担忧 |
| **Workers 调用次数** | 免费 10 万次/天 | 本项目不用 Workers |

## 📋 流量场景估算指南

帮助你判断自己的使用是否在免费版合理范围内：

| 场景 | 预估月流量 | 免费版评估 |
|------|-----------|-----------|
| **个人博客**（日 PV < 500，无大图） | 1-5 GB | ✅ 无压力 |
| **小型企业官网**（日 PV < 2000） | 10-50 GB | ✅ 无压力 |
| **图床/相册**（日 PV < 5000） | 50-200 GB | ✅ 可行 |
| **文件分享站**（大量下载） | 500 GB+ | ⚠️ 可能被要求升级 |
| **视频流**（持续播放） | 1 TB+ | ❌ 不建议 |
| **下载站/镜像站** | 1 TB+ | ❌ 不建议 |

## 总结

对于本技能（Cloudflare Tunnel + Nginx 搭建网站）的场景：

> **Cloudflare 免费版完全够用。** 无限隧道数、无限 DNS 查询、自带 SSL/TLS 证书、CDN 加速。
>
> **核心限制：**
> 1. 单文件上传最大 **100MB**
> 2. 无硬性月度流量上限，但基于 **Fair Use** 原则（个人站通常远离触发线）
> 3. 持续大流量/视频流场景建议升级付费
>
> 如果只是放网页、个人博客、小应用，免费版可以一直用下去。

## 升级路径

如果后续需要更多功能：

| 项目 | Plan | 价格 | 适合场景 |
|------|------|------|---------|
| Pro | Pro 版 | $20/月 | 需要自定义 WAF、Argo、更细的分析 |
| Business | Business 版 | $200/月 | 需要 PCI 合规、速率限制自定义等 |
| Enterprise | Enterprise 版 | 按需定价 | 大流量业务 |

## 参考链接

- [Cloudflare Plans 官方对比](https://www.cloudflare.com/plans/)
- [Cloudflare Tunnel 文档](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
- [Cloudflare API Token 权限说明](https://developers.cloudflare.com/fundamentals/api/reference/permissions/)
- [Cloudflare 2025 价格调整](https://blog.cloudflare.com/new-year-new-plans/)

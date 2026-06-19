# 🔒 Cloudflare Tunnel 一键部署 · 内网穿透 + 免费建站

<div align="center">

[![GitHub stars](https://img.shields.io/github/stars/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&logo=github&color=6c5ce7)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/stargazers)
[![GitHub license](https://img.shields.io/github/license/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&color=00cec9)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&color=fd79a8)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/pulls)

**把本地虚拟机/个人电脑变成公网服务器 — 无需公网 IP，一键搞定**

[English](./README_EN.md) · [中文](./README.md) · [快速开始](#-快速开始) · [文档](./docs/) · [报告 Bug](https://github.com/chacesclaw/cloudflare-tunnel-deploy/issues/new?template=bug_report.md)

---

</div>

## 📸 效果预览

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  用户浏览器  │────▶│  Cloudflare  │────▶│  你的虚拟机  │
│  HTTPS访问   │     │  CDN + 隧道   │     │  Nginx服务   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                    ┌──────┴──────┐
                    │  无需公网IP  │
                    │  SSL自动证书  │
                    │  DDoS防护    │
                    └─────────────┘
```

## 🎯 这个项目解决什么问题？

| 痛点 | 解决方案 |
|------|---------|
| 🏠 **没有公网 IPv4** | Cloudflare Tunnel 建立加密隧道，无需公网 IP |
| 💸 **不想买云服务器** | 用自己的电脑/虚拟机当服务器，零成本 |
| 🌐 **有域名但不会配置** | 自动绑定域名 + HTTPS 证书，无需手动配置 |
| 🔧 **不懂服务器运维** | 全自动部署脚本，一条命令搞定 |

## ✨ 功能特性

- ⚡ **一键部署** — 自动安装 Nginx、创建 Tunnel、配置 DNS、注册系统服务
- 🔐 **免费 HTTPS** — Cloudflare 自动颁发 SSL 证书
- 🛡️ **DDoS 防护** — 自带 Cloudflare 企业级防护
- 🌍 **全球加速** — Cloudflare CDN 全球节点缓存加速
- 🔄 **开机自启** — 注册为 systemd 服务，重启自动恢复
- 📝 **子路径支持** — 轻松添加多个网站路径
- 🎨 **站点示例** — 附带科技风 Claude 介绍页作为起手模板

## 🚀 快速开始

### 前置条件

- ✅ **Cloudflare 托管的域名**（在 Cloudflare 后台添加了域名）
- ✅ **Cloudflare Global API Key**（在 [API Tokens](https://dash.cloudflare.com/profile/api-tokens) 获取）
- ✅ **一台 Linux 机器**（Ubuntu/Debian 推荐，其他发行版需调整命令）
- ✅ **出站网络**（虚拟机只需能访问外网，无需公网 IP）

### 第一步：配置信息

```bash
# 用真实信息替换以下变量
export CF_EMAIL="your@email.com"
export CF_KEY="cfk_your_global_api_key_here"
export CF_DOMAIN="yourdomain.com"
export CF_SUBDOMAIN="www"   # 最终域名: www.yourdomain.com
```

### 第二步：一键部署

```bash
curl -sSL https://raw.githubusercontent.com/chacesclaw/cloudflare-tunnel-deploy/main/src/deploy.sh | bash
```

> ⏱ 整个过程约 3-5 分钟，取决于网络速度。

### 第三步：验证

- 🌐 浏览器访问 `https://你的子域名.你的域名.com` → 看到 Nginx 欢迎页
- 🔒 自动跳转 HTTPS，地址栏显示安全锁
- 📁 上传网页到 `/var/www/html/`，即刻生效

## 📖 完整文档

| 文档 | 说明 |
|------|------|
| [📘 一键部署教程](./docs/deploy-guide.md) | 从零到一的详细部署步骤 |
| [🏷️ 几块钱买 .xyz 域名（Namesilo 优惠码）](./docs/buy-cheap-xyz-domain.md) | 首年约 3 元，长期持有 10 年约 360 元 |
| [🌐 域名托管到 Cloudflare（完整图解）](./docs/domain-setup-cloudflare.md) | 第一步：把域名交给 Cloudflare 管理，手把手教学 |
| [🔑 Global API Key 获取指南（避免搞错）](./docs/global-api-key-guide.md) | 弄清 API Key 和 API Token 的区别，一次拿对 |
| [💻 VMware 搭建 Linux 虚拟机（Win/Mac）](./docs/vmware-vm-setup.md) | VMware 已免费！从安装到 Ubuntu 系统搭建详细教程 |
| [📗 Cloudflare 免费版限制说明](./docs/cloudflare-free-plan-limits.md) | 流量、带宽、文件大小等限制详解 |
| [📙 国内网络代理策略](./docs/proxy-strategy.md) | GitHub 被墙时的下载方案 |
| [📕 常见问题排查](./docs/troubleshooting.md) | 部署中遇到问题的解决方法 |
| [📘 Nginx 配置指南](./docs/nginx-config.md) | 多站点、多路径配置详解 |

## 🏗️ 项目结构

```
cloudflare-tunnel-deploy/
├── src/                          # 一键部署脚本
│   └── deploy.sh                 # 🚀 主部署脚本
├── examples/                     # 配置示例
│   ├── nginx-site.conf           # Nginx 站点配置模板
│   └── cloudflared-config.yml    # Cloudflare Tunnel 配置模板
├── docs/                         # 详细文档
│   ├── buy-cheap-xyz-domain.md          # 🏷️ 几块钱买.xyz域名
│   ├── domain-setup-cloudflare.md    # 🌐 域名托管到Cloudflare（完整图解）
│   ├── global-api-key-guide.md       # 🔑 Global API Key获取指南（避免搞错）
│   ├── vmware-vm-setup.md            # 💻 VMware搭建Linux虚拟机（Win/Mac）
│   ├── deploy-guide.md               # 📘 一键部署教程
│   ├── cloudflare-free-plan-limits.md
│   ├── proxy-strategy.md
│   ├── troubleshooting.md
│   └── nginx-config.md
├── website/                      # 🎨 示例网站模板
│   └── claude/                   # 科技风 Claude 介绍页
│       └── index.html
├── .github/                      # GitHub 配置
│   ├── ISSUE_TEMPLATE/           # Issue 模板
│   └── workflows/                # CI 工作流
├── README.md                     # 本文件
└── LICENSE                       # MIT 许可证
```

## 🛠️ 技术栈

<div align="center">

| 技术 | 用途 |
|------|------|
| ![Cloudflare](https://img.shields.io/badge/Cloudflare-F38020?logo=cloudflare&logoColor=white) | CDN + 隧道 + DNS + SSL |
| ![Nginx](https://img.shields.io/badge/Nginx-009639?logo=nginx&logoColor=white) | Web 服务器 |
| ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?logo=ubuntu&logoColor=white) | 推荐操作系统 |
| ![systemd](https://img.shields.io/badge/systemd-00B4FF?logo=systemd&logoColor=white) | 服务管理 |
| ![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=white) | 部署脚本 |
| ![Cloudflare API](https://img.shields.io/badge/Cloudflare%20API-000000?logo=cloudflare&logoColor=white) | 自动化配置 |

</div>

## 🤝 贡献指南

欢迎贡献！无论是修复 bug、改进文档、还是新增功能：

1. Fork 本仓库
2. 创建你的特性分支 (`git checkout -b feat/amazing-feature`)
3. 提交你的改动 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feat/amazing-feature`)
5. 提交 Pull Request

详见 [CONTRIBUTING.md](./CONTRIBUTING.md)。

## 📋 更新日志

### v1.0.0 (2026-06-19)
- 🎉 首次发布
- ⚡ 一键部署脚本
- 🔐 Cloudflare Tunnel 自动创建
- 📝 Nginx 站点自动配置
- 🌐 DNS 自动绑定
- 🎨 示例网站模板

## 📄 许可证

本项目基于 [MIT 许可证](./LICENSE) 开源。

## ⭐ 支持项目

如果这个项目对你有帮助，欢迎：

- ⭐ Star 本仓库
- 🐛 提交 Issue 反馈问题
- 🔀 Fork 并提交 PR
- 📢 分享给有需要的朋友

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/chacesclaw">chacesclaw</a></sub>
  <br>
  <sub>📧 联系作者：chacesclaw [at] gmail [dot] com（请手动替换为 @ 和 .）</sub>
  <br>
  <sub>Not affiliated with Cloudflare, Inc. Cloudflare® is a registered trademark of Cloudflare, Inc.</sub>
</div>

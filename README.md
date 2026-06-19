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

## 🗺️ 业务流程一览

```
                    ┌─────────────────────────────────────┐
                    │        你开始之前需要准备              │
                    │                                      │
                    │  ① 一台电脑（随便什么电脑都行）         │
                    │     ├─ 有 Linux 系统 → 直接开始       │
                    │     └─ Windows/Mac → 用 VMware 装    │
                    │        Linux 虚拟机（免费，有教程）     │
                    │                                      │
                    │  ② 一个域名                            │
                    │     ├─ 已有域名 → 直接使用              │
                    │     └─ 没有域名 → 花几十块钱买          │
                    │        六位数字 .xyz（10年≈43~70元）    │
                    │                                      │
                    │  ③ 一个 Cloudflare 账号（免费注册）     │
                    └──────────────────┬──────────────────┘
                                       │
                                       ▼
               ┌───────────────────────────────────────┐
               │        把以下信息给 AI 分身处理           │
               │   （Claude / Hermes Agent 等）           │
               │                                         │
               │   📧 Cloudflare 邮箱                     │
               │   🔑 Cloudflare Global API Key           │
               │   🌐 你的域名                            │
               └──────────────────┬──────────────────────┘
                                  │
                                  ▼
            ┌──────────────────────────────────────────────────┐
            │        AI 分身会自动完成以下所有工作                │
            │                                                  │
            │   ┌──────────┐   ┌──────────┐   ┌─────────────┐  │
            │   │ ① 域名   │   │ ② 创建   │   │ ③ 安装      │  │
            │   │ 绑定到   │──▶│ Cloudflare│──▶│ Nginx       │  │
            │   │Cloudflare│   │ Tunnel   │   │ Web服务器    │  │
            │   └──────────┘   └──────────┘   └─────────────┘  │
            │        │              │              │            │
            │        ▼              ▼              ▼            │
            │   ┌──────────┐   ┌──────────┐   ┌─────────────┐  │
            │   │ ④ 配置   │   │ ⑤ 注册   │   │ ⑥ 开启      │  │
            │   │ DNS记录  │──▶│ 系统服务  │──▶│ Always Use  │  │
            │   │ CNAME    │   │ 开机自启  │   │ HTTPS       │  │
            │   └──────────┘   └──────────┘   └─────────────┘  │
            │                                                  │
            └──────────────────┬───────────────────────────────┘
                               │
                               ▼
            ┌─────────────────────────────────────────────┐
            │              ✅ 完成！                        │
            │                                              │
            │   你现在可以：                                 │
            │   • 浏览器访问 https://你的域名 → 看到网站     │
            │   • 上传网页到 /var/www/html/ → 即刻生效      │
            │   • 添加子路径 → 参考 Nginx 配置指南          │
            └─────────────────────────────────────────────┘
```

## 🎯 这个项目解决什么问题？

| 痛点 | 解决方案 |
|------|---------|
| 🏠 **没有公网 IPv4** | Cloudflare Tunnel 建立加密隧道，无需公网 IP |
| 💸 **不想买云服务器** | 用自己的电脑/虚拟机当服务器，零成本 |
| 🌐 **不知道买什么域名、去哪买** | 详细指南教你花 **40~70 元买 10 年 .xyz 域名**，支持支付宝 |
| 🔗 **买了域名不知道怎么绑定到 Cloudflare** | 给 Global API Key 即可**自动绑定**，也可以用图解指南**手动操作** |
| 🔑 **搞不清 API Key 和 API Token** | 图文对照指南，教你一次拿对不搞混 |
| 🔧 **不懂服务器运维** | 全自动部署脚本，一条命令搞定 Nginx、Tunnel、DNS、HTTPS |

## ✨ 功能特性

- ⚡ **一键部署** — 自动安装 Nginx、创建 Tunnel、配置 DNS、注册系统服务
- 🔐 **免费 HTTPS** — Cloudflare 自动颁发 SSL 证书
- 🛡️ **DDoS 防护** — 自带 Cloudflare 企业级防护
- 🌍 **全球加速** — Cloudflare CDN 全球节点缓存加速
- 🔄 **开机自启** — 注册为 systemd 服务，重启自动恢复
- 📝 **子路径支持** — 轻松添加多个网站路径
- 🎨 **站点示例** — 附带科技风 Claude 介绍页作为起手模板

## 🚀 快速开始

### 🔰 第一步：检查自己处于哪个阶段

对照上方的流程图，确认你准备好了什么、还缺什么：

| 当前状态 | 下一步 |
|---------|--------|
| 🖥️ **没 Linux 环境** | 用 VMware 装一个 → [VMware 搭建 Linux 虚拟机](./docs/vmware-vm-setup.md) |
| 🌐 **没有域名** | 花几十块买个 10 年 .xyz → [几块钱买 .xyz 域名](./docs/buy-cheap-xyz-domain.md) |
| ☁️ **没有 Cloudflare 账号** | 去 [cloudflare.com](https://cloudflare.com) 免费注册 |
| 🔑 **有账号但没有 API Key** | 获取 Global API Key → [API Key 获取指南](./docs/global-api-key-guide.md) |

### 🔰 第二步：把以下信息交给 AI 分身

当你准备好了，把你的 AI 分身（Claude、Hermes Agent 等）叫出来，给它三个信息：

```text
Cloudflare 邮箱: your@email.com
Global API Key: cfk_your_global_api_key_here
域名: yourdomain.com
子域名: www   ← 你想要什么子域名，最终网址就是 www.yourdomain.com
```

### 🔰 第三步：AI 分身自动完成全部配置

AI 接收到你的信息后，会自动完成：

- ✅ 域名绑定到 Cloudflare
- ✅ 创建 Cloudflare Tunnel
- ✅ 安装和配置 Nginx
- ✅ 配置 DNS 记录（CNAME → 隧道）
- ✅ 注册系统服务（开机自启）
- ✅ 开启 Always Use HTTPS

整个过程约 3~5 分钟，你只需要等待即可。

### 🔰 第四步：验证

- 🌐 浏览器访问 `https://你的域名` → 看到 Nginx 欢迎页
- 🔒 网址前有安全锁（HTTPS 自动生效）
- 📁 上传网页到 `/var/www/html/`，即刻生效

## 📖 完整文档

| 文档 | 说明 |
|------|------|
| [📘 一键部署教程](./docs/deploy-guide.md) | 从零到一的详细部署步骤 |
| [🏷️ 几块钱买 .xyz 域名（六位数字 .xyz 续费也便宜）](./docs/buy-cheap-xyz-domain.md) | 10 年 ≈ 43~70 元，续费同价，日均 1 分钱 |
| [⚡ 域名自动绑定到 Cloudflare](./docs/domain-auto-bind.md) | 给 Global API Key 即可自动绑定，无需手动操作 |
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
│   ├── domain-auto-bind.md           # ⚡ 域名自动绑定到Cloudflare（给API Key即可）
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

> 完整版本历史请查看 [Releases 页面](https://github.com/chacesclaw/cloudflare-tunnel-deploy/releases)

### 🗺️ v1.4.0 — README 全流程重设计
- 新增「业务流程一览」ASCII 流程图，清晰呈现从准备到完成的完整链路
- 快速开始改为 4 步引导（查漏补缺 → 给AI信息 → 自动配置 → 验证）
- 理念从"前置条件+curl命令"升级为"准备三样东西→交给AI→坐等完成"

### 📘 v1.3.0 — 域名价格更新 + 自动绑定文档
- 域名价格更新为六位数字 .xyz（续费也便宜）
- 新增「域名自动绑定到 Cloudflare」文档
- 痛点表格扩展

### 🏷️ v1.2.1 — .xyz 域名指南更新
- 修正为六位数字 .xyz（续费 $0.60/年≈4.5元）
- 新增阿里云（7元/年）和 Spaceship（$0.60/年）方案

### 🏷️ v1.2.0 — 新增 .xyz 域名购买指南
- 新增「几块钱买 .xyz 域名」完整指南

### 📚 v1.1.0 — 新增三份新手友好文档
- 域名托管到 Cloudflare 图解
- Global API Key 获取指南
- VMware 搭建 Linux 虚拟机教程

### 🎉 v1.0.0 — 首次发布
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

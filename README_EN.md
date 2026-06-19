<div align="center">

# 🔒 Cloudflare Tunnel Deploy

**Expose your local server to the internet with Cloudflare Tunnel — No public IP required.**

[![GitHub stars](https://img.shields.io/github/stars/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&logo=github&color=6c5ce7)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/stargazers)
[![GitHub license](https://img.shields.io/github/license/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&color=00cec9)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/chacesclaw/cloudflare-tunnel-deploy?style=for-the-badge&color=fd79a8)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/issues)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=for-the-badge)](https://github.com/chacesclaw/cloudflare-tunnel-deploy/pulls)

[中文](./README.md) · [English](./README_EN.md) · [Quick Start](#-quick-start) · [Docs](./docs/) · [Report Bug](https://github.com/chacesclaw/cloudflare-tunnel-deploy/issues/new?template=bug_report.md)

</div>

---

## 🎯 What Problems Does This Solve?

| Problem | Solution |
|---------|----------|
| 🏠 **No public IPv4 address** | Cloudflare Tunnel creates an encrypted outbound tunnel |
| 💸 **Don't want to pay for a cloud server** | Use your own computer as a server — zero cost |
| 🌐 **Have a domain but can't configure it** | Auto-bind domain + HTTPS with zero manual config |
| 🔧 **Not a sysadmin** | Fully automated script, one command to deploy |

## ✨ Features

- ⚡ **One-click deploy** — Auto-install Nginx, create Tunnel, configure DNS, register systemd service
- 🔐 **Free HTTPS** — Cloudflare auto-provisions SSL certificates
- 🛡️ **DDoS protection** — Enterprise-grade protection included
- 🌍 **Global CDN** — Cloudflare edge caching for faster load times
- 🔄 **Auto-restart** — Registered as systemd service, survives reboots
- 📝 **Sub-path support** — Easily add multiple website paths
- 🎨 **Site template** — Includes a tech-themed Claude showcase page

## 🚀 Quick Start

### Prerequisites

- ✅ A **domain managed by Cloudflare** (nameservers pointed to Cloudflare)
- ✅ **Cloudflare Global API Key** (get it from [API Tokens](https://dash.cloudflare.com/profile/api-tokens))
- ✅ A **Linux machine** (Ubuntu/Debian recommended)
- ✅ **Outbound internet access** (no public IP needed)

### One-Click Deploy

```bash
curl -sSL https://raw.githubusercontent.com/chacesclaw/cloudflare-tunnel-deploy/main/src/deploy.sh | bash
```

> ⏱ Takes about 3-5 minutes depending on network speed.

The script will prompt you for:
1. Your Cloudflare email
2. Your Global API Key
3. Your domain name
4. Desired subdomain

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [📘 Deploy Guide](./docs/deploy-guide.md) | Step-by-step deployment instructions |
| [📗 Free Plan Limits](./docs/cloudflare-free-plan-limits.md) | Bandwidth, file size, fair use explained |
| [📙 Proxy Strategy](./docs/proxy-strategy.md) | How to download behind China's firewall |
| [📕 Troubleshooting](./docs/troubleshooting.md) | Common issues and solutions |
| [📘 Nginx Config](./docs/nginx-config.md) | Multi-site and sub-path configuration |

## 🏗️ Project Structure

```
cloudflare-tunnel-deploy/
├── src/deploy.sh                 # 🚀 Main deploy script
├── examples/
│   ├── nginx-site.conf           # Nginx site config template
│   └── cloudflared-config.yml    # Cloudflare Tunnel config template
├── docs/                         # Detailed documentation
├── website/claude/               # 🎨 Sample website template
└── .github/                      # GitHub CI/issue templates
```

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| Cloudflare | CDN + Tunnel + DNS + SSL |
| Nginx | Web server |
| Ubuntu/Debian | Recommended OS |
| systemd | Service management |
| Bash | Automation scripts |
| Cloudflare API | Zero-touch provisioning |

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for details.

## 📄 License

MIT © [chacesclaw](https://github.com/chacesclaw)

---

<div align="center">
  <sub>Built with ❤️ by <a href="https://github.com/chacesclaw">chacesclaw</a></sub>
  <br>
  <sub>📧 Contact: chacesclaw [at] gmail [dot] com</sub>
  <br>
  <sub>Not affiliated with Cloudflare, Inc. Cloudflare® is a registered trademark of Cloudflare, Inc.</sub>
</div>

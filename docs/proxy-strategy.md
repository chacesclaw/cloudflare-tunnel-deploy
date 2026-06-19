---
name: proxy-strategy
description: "国内网络环境下 GitHub 被墙时下载 cloudflared 的代理方案 —— xray/v2ray HTTP代理、SOCKS5代理、阿里云镜像"
tags:
  - github被墙
  - cloudflared下载
  - 代理下载
  - xray代理
  - socks5代理
  - 国内网络
  - 翻墙下载
  - apt代理问题
---

# 代理策略对照表

在国内网络环境下，`github.com` 和部分海外域名可能无法直连。以下策略针对本技能涉及的操作。

## 网络环境诊断

```bash
# 检查 GitHub 连通性
curl -sI --connect-timeout 5 https://github.com | head -1

# 检查本地代理端口
ss -tlnp | grep -E '10808|10809|7890|7891'
```

## 代理策略速查表

| 目标 | 操作 | 需要代理 | 推荐方案 |
|------|------|----------|----------|
| `github.com` 下载 cloudflared | `curl -L -O` | ✅ 通常需要 | 通过 HTTP 代理端口 |
| `api.cloudflare.com` 调用 API | `curl -s` | ❌ 不需要 | `--noproxy "*"` 绕过 |
| `apt update` (archive.ubuntu.com) | `apt update` | ❌ 不需要 | 移除 socks5 代理配置 |
| `dash.cloudflare.com` 授权 | 浏览器登录 | ❌ 通常不需要 | 用户浏览器操作 |

## cloudflared 下载方案

### 方案 A：通过 HTTP 代理（xray 本地 10809 端口）

```bash
export https_proxy=http://127.0.0.1:10809
curl -L -o /tmp/cloudflared.deb \
  "https://github.com/cloudflare/cloudflared/releases/download/2026.6.1/cloudflared-linux-amd64.deb"
sudo dpkg -i /tmp/cloudflared.deb
```

### 方案 B：通过 SOCKS5 代理（本地 10808）

```bash
curl -x socks5h://127.0.0.1:10808 -L -o /tmp/cloudflared.deb \
  "https://github.com/cloudflare/cloudflared/releases/download/2026.6.1/cloudflared-linux-amd64.deb"
```

### 方案 C：从国内镜像/备用源下载

```bash
# 阿里云镜像（如果可用）
sudo apt-key add /tmp/cloudflared.asc
echo "deb https://mirrors.aliyun.com/cloudflare/cloudflared/ stable main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt update && sudo apt install cloudflared
```

### 方案 D：本机已安装二进制直接复制

如果有另一台机器已下载，直接 scp 过来：
```bash
scp user@other-machine:/usr/bin/cloudflared /tmp/cloudflared
chmod +x /tmp/cloudflared
sudo cp /tmp/cloudflared /usr/bin/cloudflared
```

## Cloudflare API 调用（无需代理）

无论网络环境如何，`api.cloudflare.com` 通常可以直连。如果 shell 环境变量设置了代理，使用 `--noproxy "*"` 绕过：

```bash
# ✅ 正确
curl --noproxy "*" -H "X-Auth-Email: ..." -H "X-Auth-Key: ..." "https://api.cloudflare.com/..."

# ❌ 不要依赖环境变量代理去访问 Cloudflare API，多一次跳转更慢
```

## apt 代理配置修复

如果 `/etc/apt/apt.conf.d/99proxy` 配置了 `socks5://` 协议，必须移除或改为 `http://`：

```bash
# ❌ apt 不支持 socks5
Acquire::http::Proxy "socks5://192.168.1.xxx:10808";  # 这个会失败！

# ✅ apt 支持 http 代理
Acquire::http::Proxy "http://127.0.0.1:10809";
```

## 坑

1. **curlrc 配置文件**：`~/.curlrc` 中的 `proxy = "socks5h://..."` 会影响所有 curl 调用。使用 `--noproxy "*"` 可绕过单次调用。
2. **wgetrc 配置文件**：类似问题，用 `wget --no-proxy` 绕过。
3. **全局环境变量**：`export https_proxy=...` 影响当前 shell 所有子进程。根据需要设置/取消。

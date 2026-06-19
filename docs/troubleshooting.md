# 常见问题排查

## 部署后无法访问

### 1. DNS 未生效
```bash
nslookup 你的域名
```
如果解析结果不是 Cloudflare IP（104.16.x.x 等），等待几分钟。

### 2. Tunnel 未连接
```bash
sudo systemctl status cloudflared
sudo journalctl -u cloudflared --no-pager | tail -20
```
应看到 `Registered tunnel connection`。

### 3. Nginx 未启动
```bash
sudo systemctl status nginx
curl -sI http://localhost/
```

### 4. 浏览器显示 "此网站无法提供安全连接"
等 SSL 证书自动颁发（通常几分钟）。Cloudflare 免费版会自动签发证书。

## cloudflared 安装失败

### GitHub 无法访问（国内网络）
```bash
# 尝试代理下载
export https_proxy=http://127.0.0.1:10809
curl -L -o /tmp/cloudflared.deb https://github.com/cloudflare/cloudflared/releases/download/2026.6.1/cloudflared-linux-amd64.deb
```

### apt update 失败
```bash
# 检查是否配置了 socks5 代理
cat /etc/apt/apt.conf.d/99proxy 2>/dev/null
# 如果有 socks5 配置，移除或改为 http
sudo mv /etc/apt/apt.conf.d/99proxy /etc/apt/apt.conf.d/99proxy.bak
```

## 其他问题

提交 Issue：https://github.com/chacesclaw/cloudflare-tunnel-deploy/issues/new

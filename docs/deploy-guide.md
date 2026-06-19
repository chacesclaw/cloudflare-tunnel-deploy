# 📘 部署指南

本指南详细说明 Cloudflare Tunnel 一键部署的每一步操作。

## 前置条件

1. **域名已托管到 Cloudflare**
   - 在 Cloudflare 后台添加域名
   - 将域名的 NS 记录改为 Cloudflare 提供的 NS 地址
   - 等待状态变为 "Active"

2. **获取 Global API Key**
   - 登录 [Cloudflare Dashboard](https://dash.cloudflare.com/)
   - 右上角头像 → 我的个人资料 → API 令牌
   - 在 "API Keys" 区域点击 "View" 查看 Global API Key

3. **Linux 服务器**
   - 推荐 Ubuntu 22.04+ / Debian 11+
   - 确保能正常访问外网

## 一键部署

```bash
curl -sSL https://raw.githubusercontent.com/chacesclaw/cloudflare-tunnel-deploy/main/src/deploy.sh | bash
```

脚本会依次：
1. 检查系统环境
2. 输入 Cloudflare 凭据和域名信息
3. 验证 Cloudflare 账户
4. 修复 apt 代理问题
5. 安装 Nginx
6. 安装 cloudflared
7. 创建 Tunnel
8. 配置凭证
9. 配置 DNS（CNAME → 隧道）
10. 注册系统服务
11. 配置 Nginx
12. 开启 Always Use HTTPS

## 手动部署

如果一键部署不适用，也可以参照 [SKILL.md](../SKILL.md) 中的分步指南手动执行。

## 上传网页

部署完成后，将网页文件放入：

```bash
/var/www/html/
```

访问 `https://你的域名/文件名` 即可查看。

## 添加子路径

```bash
sudo mkdir -p /var/www/html/myapp
```

然后在 `/etc/nginx/sites-available/你的域名` 中添加：

```nginx
location /myapp/ {
    alias /var/www/html/myapp/;
    index index.html;
}

location = /myapp {
    return 301 /myapp/;
}
```

最后 `sudo nginx -t && sudo nginx -s reload` 重载配置。

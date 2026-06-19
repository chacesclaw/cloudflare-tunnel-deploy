# ⚡ 域名自动绑定到 Cloudflare（给 API Key 即可）

> **如果你购买了域名，可以把 Cloudflare 的 Global API Key 给我们，部署脚本会自动完成以下工作：**
>
> ✅ 在 Cloudflare 添加你的域名
> ✅ 设置 DNS 记录（CNAME → Tunnel）
> ✅ 开启代理（橙色云）
> ✅ 开启 Always Use HTTPS
>
> **你只需要提供三个信息：Cloudflare 邮箱、Global API Key、域名。**

---

## 两种方式，任选一种

### 方式 A：全自动（推荐）

运行一键部署脚本时，脚本会自动处理域名绑定：

```bash
curl -sSL https://raw.githubusercontent.com/chacesclaw/cloudflare-tunnel-deploy/main/src/deploy.sh | bash
```

脚本会提示你输入：

```
Cloudflare 邮箱: your@email.com
Global API Key: cfk_your_key_here
域名: yourdomain.xyz
子域名: www
```

脚本内部自动完成：

| 步骤 | 说明 |
|------|------|
| 1️⃣ 验证凭据 | 检查 API Key 和域名是否有效 |
| 2️⃣ 获取 Zone ID | 自动识别域名在 Cloudflare 中的区域 |
| 3️⃣ 创建 DNS 记录 | CNAME → `隧道ID.cfargotunnel.com` |
| 4️⃣ 开启代理 | DNS 记录设为 Proxied（橙色云） |
| 5️⃣ 开启 Always Use HTTPS | HTTP 自动跳转 HTTPS |

> 💡 **前提条件**：你的域名必须已经在 Cloudflare 控制台添加过（即 Nameservers 已指向 Cloudflare）。
>
> 如果还没添加过，请看 [域名托管到 Cloudflare 图解](./domain-setup-cloudflare.md) 完成第一步，然后回来运行脚本。

---

### 方式 B：手动通过 API 绑定

如果你想自己一步一步来，也可以用以下命令：

```bash
# 1. 设置变量
AUTH_EMAIL="your@email.com"
AUTH_KEY="cfk_your_global_api_key_here"
DOMAIN="yourdomain.xyz"
SUB_DOMAIN="www"
ZONE_ID="你的Zone ID"   # 从Cloudflare后台获取

# 2. 创建 DNS 记录（CNAME 指向 Tunnel）
curl -s --noproxy "*" -X POST \
  "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
  -H "X-Auth-Email: $AUTH_EMAIL" \
  -H "X-Auth-Key: $AUTH_KEY" \
  -H "Content-Type: application/json" \
  -d "{
    \"type\": \"CNAME\",
    \"name\": \"$SUB_DOMAIN\",
    \"content\": \"隧道ID.cfargotunnel.com\",
    \"ttl\": 1,
    \"proxied\": true
  }"

# 3. 开启 Always Use HTTPS
curl -s --noproxy "*" -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/settings/always_use_https" \
  -H "X-Auth-Email: $AUTH_EMAIL" \
  -H "X-Auth-Key: $AUTH_KEY" \
  -H "Content-Type: application/json" \
  -d '{"value":"on"}'
```

---

## 不同场景的操作对比

| 你的状态 | 需要做什么 | 参考文档 |
|---------|-----------|---------|
| **已有域名 + 已托管到 Cloudflare** | ✅ 直接运行部署脚本即可 | [一键部署教程](./deploy-guide.md) |
| **已有域名 + 没托管到 Cloudflare** | 先去注册商改 NS，再运行脚本 | [域名托管图解](./domain-setup-cloudflare.md) |
| **还没买域名** | 先买个 .xyz 域名（10 年约 40~70 元） | [几块钱买 .xyz 域名](./buy-cheap-xyz-domain.md) |
| **已经部署好 Tunnel，想加新域名** | 手动创建 DNS 记录指向 Tunnel | 见上方 API 命令 |

---

## ✅ 确认清单

- [ ] Cloudflare 邮箱正确
- [ ] Global API Key（以 `cfk_` 开头）已获取
- [ ] 域名已在 Cloudflare 添加（Nameservers 已指向 Cloudflare）
- [ ] 运行部署脚本或手动调用 API
- [ ] 验证 `https://你的域名` 可以访问

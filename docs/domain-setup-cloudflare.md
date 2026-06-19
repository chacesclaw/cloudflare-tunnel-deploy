# 🌐 第一步：把域名托管到 Cloudflare（完整图解）

> ⏱ 全程约 10~30 分钟（取决于域名注册商响应速度）
>
> 如果你已经将域名托管到了 Cloudflare，可以直接跳过本步骤。

---

## 📌 为什么要做这一步？

要让 Cloudflare Tunnel 生效，你的**域名必须由 Cloudflare 管理 DNS**。也就是说，域名的 "NS 记录"（Name Server，即域名服务器）必须指向 Cloudflare。

> 简单理解：域名注册商（比如 Namesilo、GoDaddy、阿里云、腾讯云）只负责"登记"你的域名，DNS 解析服务（决定 `你的域名 → 哪个 IP`）可以交给 Cloudflare 来做。

---

## 🧭 操作流程概览

```
你在域名注册商买的域名
    ↓
在 Cloudflare 添加域名
    ↓
Cloudflare 给你两个 NS 地址
    ↓
去域名注册商后台，把 NS 改成 Cloudflare 的
    ↓
等待生效（通常几分钟~24小时）
    ↓
✅ 域名托管成功！
```

---

## 📝 详细操作步骤

### 第一步：在 Cloudflare 添加域名

1. 打开 https://dash.cloudflare.com/ 并登录你的账号
2. 点击右上角的 **"添加站点"**（Add site）
3. 输入你的域名（例如 `example.com`），点击 **"添加"**
   - ⚠️ 不要加 `www.` 或 `https://`，只要裸域名
4. 选择套餐：选择 **Free（免费版）** 即可
5. 点击 **"继续"**

Cloudflare 会自动扫描你域名的现有 DNS 记录（如果没有显示出来，也可以后面手动添加）。

### 第二步：复制 Cloudflare 分配的 NS 地址

扫描完成后，Cloudflare 会给你两个 **NS 地址**（类似下面这样）：

```
adelaide.ns.cloudflare.com
evan.ns.cloudflare.com
```

> ⚠️ **每个人的 NS 地址不一样**！不要直接复制别人的，一定要用 Cloudflare 给你分配的那两个。

把这两个地址**复制保存好**，下一步要用。

### 第三步：去域名注册商修改 NS 记录

根据你在哪里买的域名，去对应的后台修改。下面是常见注册商的操作路径：

<details>
<summary><b>📌 展开查看常见注册商操作步骤</b></summary>

####   Namesilo

1. 登录 Namesilo → My Account → Domain Manager
2. 找到你的域名，点击蓝色地球图标
3. 在 **NameServer** 栏目选择 **Custom**
4. 填入 Cloudflare 给你的两个 NS 地址
5. 点击 **Save**

####   GoDaddy

1. 登录 GoDaddy → 我的产品 → 域名
2. 找到你的域名，点击 **DNS**（或管理）
3. 把 **Nameservers** 从"默认"改为 **"自定义"**
4. 填入 Cloudflare 给你的两个 NS 地址
5. 点击 **保存**

####   阿里云 / 万网

1. 登录阿里云 → 控制台 → 域名
2. 找到你的域名，点击 **管理**
3. 左侧菜单选择 **DNS修改**（或域名服务器修改）
4. 点击 **修改 DNS 服务器**
5. 填入 Cloudflare 给你的两个 NS 地址
6. 点击 **确定**

####   腾讯云 / DNSPod

1. 登录腾讯云 → 控制台 → 域名管理
2. 找到你的域名 → 更多操作 → **修改 DNS 服务器**
3. 选择 **自定义 DNS**
4. 填入 Cloudflare 给你的两个 NS 地址
5. 点击 **提交**

####   Cloudflare Partner（如阿里云已接入 Cloudflare）

如果你在阿里云的 DNS 设置页看到 **"切换至 Cloudflare 全球加速"** 按钮，可以直接点击一键切换，无需手动改 NS。

</details>

### 第四步：等待生效

修改 NS 后，需要等待 DNS 传播：

- **通常时间**：5~30 分钟
- **最长可能**：24~48 小时（取决于你的域名注册商）
- Cloudflare 后台会显示状态从 **"待处理"（Pending）** → **"活跃"（Active）**

> 💡 **判断技巧**：在命令行执行：
> ```bash
> nslookup -type=NS example.com
> ```
> 如果返回的 NS 地址是 `xxx.cloudflare.com` 而不是你注册商的，说明已生效。

### 第五步：验证

回到 Cloudflare 后台，刷新页面。当域名状态显示为 **"活跃"（Active）** 时，说明已经成功将域名托管到 Cloudflare了！🎉

---

## ❌ 常见问题

### Q：改 NS 会影响现有网站吗？

**会短暂影响。** 改 NS 后，旧 DNS 记录失效，新记录需要时间传播。对新搭建的服务器没有影响（还没有上线）。

如果域名原本已经在访问其他网站，可以先用 Cloudflare 的 **"开发模式"** 测试，或者等非高峰期操作。

### Q：改完 NS 后去哪里管理 DNS 记录？

改完后，所有的 DNS 记录（A 记录、CNAME 等）**都在 Cloudflare 后台管理**，原来的域名注册商后台不再负责 DNS 解析。

### Q：Cloudflare 上看到的 DNS 记录不全怎么办？

如果在扫描阶段没有自动导入所有记录，可以：

1. 在 Cloudflare 后台 → **DNS** → **添加记录**
2. 手动添加你需要的记录（比如 A 记录、CNAME 等）
3. 本项目的部署脚本会自动创建所需的 CNAME 记录

### Q：我可以在不改 NS 的情况下用 Cloudflare Tunnel 吗？

**不可以。** Cloudflare Tunnel 要求域名必须托管在 Cloudflare（使用 Cloudflare 的 NS），这样才能控制 DNS 路由。

---

## ✅ 确认清单

- [ ] 已在 Cloudflare 后台添加域名
- [ ] 已复制 Cloudflare 分配的 NS 地址
- [ ] 已在域名注册商修改 NS 为 Cloudflare 的地址
- [ ] Cloudflare 后台域名状态显示 **"活跃"（Active）**
- [ ] 至此，域名已成功托管到 Cloudflare ✅

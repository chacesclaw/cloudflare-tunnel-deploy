# 💻 如何使用 VMware 搭建 Linux 虚拟机（Windows / Mac 完整教程）

> 🆓 **重要：VMware Workstation Pro 已对个人用户完全免费！**
>
> 从 2024 年 11 月起，VMware（已被 Broadcom 收购）宣布 Workstation Pro **对所有用户免费**——个人、商业、教育均无需购买许可证。
>
> 你没有看错：**VMware Workstation Pro 现在免费了，功能没有任何阉割。**

---

## 📌 什么是 VMware？

VMware Workstation Pro 是一款桌面虚拟化软件，可以让你在 Windows 或 Mac 电脑上**运行一台或多台独立的虚拟机**。简单来说：

> 你在 Windows 桌面上开一个"窗口"，里面跑一台完整的 Linux 系统——就像拥有一台独立的电脑一样。

---

## 🧰 本教程需要的东西

| 项目 | 说明 | 获取方式 |
|------|------|---------|
| **VMware Workstation Pro** | 虚拟化软件 | 下方步骤 1️⃣ |
| **Ubuntu Server ISO** | Linux 系统镜像 | 下方步骤 2️⃣ |
| 一台电脑 | Windows 10/11 或 Intel Mac | 推荐 8GB 以上内存、50GB 以上空闲硬盘 |

---

## 📥 第一步：下载和安装 VMware

### 1.1 下载

访问 Broadcom 官方下载页面：

> https://support.broadcom.com/group/ecx/productdownloads

> ℹ️ 由于 Broadcom 官网经常改版，你也可以直接在搜索引擎搜索 **"VMware Workstation Pro download"**，找到 Broadcom 官方链接。

**Windows 用户下载：** `VMware-workstation-full-xxxx.exe`
**Mac 用户下载：** `VMware-Fusion-xxxx.dmg`

>   **关于版本**：建议下载最新的 26H1 或 25H2 版本，旧的 17.x 系列即将停止支持（2025 年 11 月）。

### 1.2 安装

**Windows：**
1. 双击下载的 `.exe` 文件
2. 一路点击 **"Next"**（下一步）
3. 勾选 **"接受许可协议"**
4. 选择安装路径（默认即可）
5. 点击 **"Install"** 等待完成
6. 安装完成后，**重启电脑**

**Mac（Intel）：**
1. 双击 `.dmg` 文件
2. 将 VMware Fusion 拖入 Applications 文件夹
3. 首次打开时，系统可能提示"来自未识别的开发者"——去 **系统设置 → 隐私与安全性** 中允许运行

### 1.3 验证免费授权

安装后首次启动 VMware，会出现激活窗口：

- ✅ 选择 **"用于个人用途"（Use for personal use）**
- 或者选择 **"Workstation Pro 自由使用许可"** 选项（不同版本文字可能略有差异）
- 无需输入序列号！

>   **如果提示需要许可证密钥**：在 VMware 菜单栏选择 **Help → Enter License Key**，输入以下通用密钥即可激活免费版（该密钥由 Broadcom 官方提供）：
> ```
> MC60H-DWHD5-H80U9-6V85M-828D0
> ```

---

## 📦 第二步：下载 Ubuntu Server 镜像

Ubuntu 有两个常见版本：

| 版本 | 特点 | 推荐场景 |
|------|------|---------|
| **Ubuntu Server** | 无桌面环境，节省资源 | 本教程推荐 👈 |
| **Ubuntu Desktop** | 带图形界面 | 新手友好但更耗资源 |

下载地址：

> https://ubuntu.com/download/server

点击 **"Download Ubuntu Server"** 下载最新的 LTS（长期支持）版本，当前最新为 **Ubuntu 24.04 LTS**（Noble Numbat）。

下载后的文件是 `.iso` 格式，大约 2.6GB 左右。

---

## 🖥️ 第三步：创建虚拟机

### 3.1 新建虚拟机

启动 VMware Workstation Pro，点击主页面的 **"创建新的虚拟机"（Create a New Virtual Machine）**

### 3.2 选择安装方式

```
 ○ 典型（推荐）(Typical) ← 选这个，简单
 ○ 自定义 (Custom)       ← 高级用户
```

点击 **"下一步" (Next)**

### 3.3 选择 ISO 镜像

```
 ○ 安装程序光盘 (Installer disc) 
 ○ 安装程序映像文件 (Installer disc image file) ← 选这个
    [Browse...] → 选择你刚才下载的 ubuntu-24.04-live-server-amd64.iso
```

点击 **"下一步"**

### 3.4 选择客户机操作系统

```
 客户机操作系统:   ○ Windows  ○ Linux ← 选 Linux
 版本:             Ubuntu 64-bit
```

点击 **"下一步"**

### 3.5 命名虚拟机

```
 虚拟机名称: Ubuntu Server 24.04
 位置:       C:\Users\你的用户名\Documents\Virtual Machines\Ubuntu Server 24.04
             ↑ 建议放在空间充足的盘
```

点击 **"下一步"**

### 3.6 指定磁盘容量

```
 最大磁盘大小: 20GB  →  建议改为 40~60GB
 ○ 将虚拟磁盘拆分为多个文件 ← 推荐（方便迁移）
 ○ 将虚拟磁盘存储为单个文件
```

点击 **"下一步"**

### 3.7 自定义硬件（关键！）

点击 **"自定义硬件" (Customize Hardware)**：

| 硬件 | 推荐设置 | 说明 |
|------|---------|------|
| **内存** | 4096 MB (4GB) | 至少 2GB，推荐 4GB+ |
| **处理器** | 2 核心 | 至少 1 核，推荐 2 核+ |
| **网络适配器** | **NAT 模式** | 默认就是 NAT，不要改！NAT 模式让虚拟机通过宿主机上网 |
| **新 CD/DVD** | 使用 ISO 镜像文件 | 确保指向 Ubuntu ISO |

> **为什么网络要用 NAT 模式？** NAT 模式下，虚拟机可以正常上网，同时与宿主机在同一内网段。这对于 Cloudflare Tunnel 的出站连接至关重要。
>
> 另外，可以再添加一个 **"网络适配器 → 桥接模式"** 作为选项，但至少保留一个 NAT。

点击 **"关闭"** → **"完成"**

### 3.8 创建完成！🎉

虚拟机已创建完成，在 VMware 主界面可以看到新创建的虚拟机。

---

## 🚀 第四步：安装 Ubuntu Server

### 4.1 启动虚拟机

在 VMware 主界面点击 **"开启此虚拟机" (Power on this virtual machine)**

>   **安装时鼠标被锁在虚拟机里怎么办？** 按 `Ctrl + Alt` 可以释放鼠标回到宿主机。

### 4.2 Ubuntu 安装向导

按照屏幕提示操作，主要步骤：

| 步骤 | 操作 |
|------|------|
| **选择语言** | English（后面可以安装中文支持） |
| **键盘布局** | 保持默认或选择 Chinese |
| **网络配置** | 默认（DHCP 自动获取 IP），确认显示网卡已连接 |
| **代理设置** | 留空（不需要跳过） |
| **镜像设置** | 默认即可，国内用户可改为 `mirrors.ustc.edu.cn` 或 `mirrors.aliyun.com` |
| **磁盘分区** | **"Use an entire disk"**（使用整个磁盘）→ 默认即可 |
| **用户名和密码** | 设置你的登录信息 |
| **SSH 配置** | **勾选 "Install OpenSSH server"**（必选！这让你以后可以远程登录） |
| **软件包** | 保持默认即可 |

### 4.3 等待安装

安装过程约 5~15 分钟，取决于你的电脑性能。安装完成后，点击 **"Reboot Now"**（立即重启）。

> 重启时如果提示 **"Please remove the installation medium"**，直接按回车即可。

---

## 🔌 第五步：登录并查看 IP

### 5.1 登录虚拟机

重启后，你会看到登录提示符：

```
ubuntu login: _
```

输入刚才设置的用户名和密码登录。

### 5.2 查看 IP 地址

```bash
ip addr show
```

或者

```bash
hostname -I
```

你会看到一个类似 `192.168.xxx.xxx` 的 IP 地址——这就是虚拟机的内网 IP。

> 记下这个 IP，后面如果要在宿主机通过 SSH 远程连接虚拟机，就靠它。

### 5.3 测试网络

```bash
ping -c 3 google.com
```

如果能 ping 通，说明网络正常，虚拟机已经可以上网了！

---

## 🛠️ 第六步：SSH 远程登录（可选但推荐）

在宿主机上打开终端（Windows 用 PowerShell 或 CMD，Mac 用 Terminal），运行：

```bash
ssh 你的用户名@192.168.xxx.xxx
```

输入密码后登录成功。以后你就可以关掉 VMware 的虚拟机窗口，用 SSH 来操作了。

---

## 📋 常见问题

### 虚拟机不能上网？

1. 检查 VMware 的网络设置：VMware 菜单 → **编辑 → 虚拟网络编辑器** → 确保 VMnet8 (NAT) 配置正确
2. 在虚拟机里运行 `ip a`，看看有没有获取到 IP
3. 尝试 `sudo dhclient` 重新获取 IP

### 虚拟机太卡？

- 调低内存：关闭虚拟机 → 编辑设置 → 内存改为 2GB
- 调低 CPU 核心数：改为 1 核
- 确保宿主机有足够空闲内存（建议 16GB+）

### 安装后找不到虚拟机（Mac）

VMware Fusion 的虚拟机默认存放在 `~/Virtual Machines/` 目录下。

### VMware 提示 "This product may not be used for commercial purposes"

选择 **"用于个人用途"** 即可。如果已经选了但未生效，去 **Help → Enter License Key** 输入通用密钥 `MC60H-DWHD5-H80U9-6V85M-828D0`。

### 安装后发现磁盘空间不够？

可以扩容：VMware 菜单 → **虚拟机 → 设置 → 硬盘 → 扩展**（Expand）→ 输入新大小。扩容后还需要在 Ubuntu 内扩展分区，具体命令请参考 [docs/troubleshooting.md](./troubleshooting.md)。

---

## ✅ 第六步完成后的状态确认

- [ ] VMware Workstation Pro 已安装并免费激活
- [ ] Ubuntu Server 24.04 虚拟机已创建
- [ ] 虚拟机网络正常（能 ping 通外网）
- [ ] 已获取虚拟机的 IP 地址
- [ ] （可选）SSH 可以连接虚拟机
- [ ] ✅ 环境就绪，可以继续下一步——部署 Cloudflare Tunnel 了！

---

## 📎 参考链接

- [VMware Workstation Pro 官方下载](https://support.broadcom.com/group/ecx/productdownloads)
- [Ubuntu Server 下载](https://ubuntu.com/download/server)
- [Broadcom 关于 VMware 免费的官方 FAQ](https://www.vmware.com/docs/desktop-hypervisor-faqs)
- [本项目的部署指南](./deploy-guide.md)

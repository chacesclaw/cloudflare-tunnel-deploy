#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Cloudflare Tunnel 一键部署脚本
# Cloudflare Tunnel Deploy — Expose your local server to the internet
# =============================================================================
# 版本: 1.0.0
# 协议: MIT
# =============================================================================

# ----- Color helpers -----
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

log_info()  { printf "${CYAN}[INFO]${NC}  %s\n" "$*"; }
log_ok()    { printf "${GREEN}[OK]${NC}    %s\n" "$*"; }
log_warn()  { printf "${YELLOW}[WARN]${NC}  %s\n" "$*"; }
log_error() { printf "${RED}[ERROR]${NC} %s\n" "$*"; }

# ----- Pre-flight checks -----
check_prerequisites() {
    log_info "检查前置条件..."

    # OS detection
    if [ ! -f /etc/os-release ]; then
        log_error "仅支持 Linux 系统。"
        exit 1
    fi
    . /etc/os-release

    # Root/sudo check
    if [ "$(id -u)" -ne 0 ] && ! command -v sudo &>/dev/null; then
        log_error "需要 root 权限。请以 root 用户执行或安装 sudo。"
        exit 1
    fi

    # curl check
    if ! command -v curl &>/dev/null; then
        log_warn "curl 未安装，正在安装..."
        apt-get update -qq && apt-get install -y -qq curl
    fi

    # python3 check
    if ! command -v python3 &>/dev/null; then
        log_warn "python3 未安装，正在安装..."
        apt-get update -qq && apt-get install -y -qq python3
    fi

    log_ok "前置检查通过"
}

# ----- Collect user input -----
collect_input() {
    echo ""
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    printf "${CYAN}  Cloudflare Tunnel 一键部署${NC}\n"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    echo ""

    read -r -p "Cloudflare 邮箱: " CF_EMAIL
    read -r -p "Global API Key: " CF_KEY
    read -r -p "域名 (例如 example.com): " CF_DOMAIN
    read -r -p "子域名 (例如 www，回车默认为 @): " CF_SUBDOMAIN
    CF_SUBDOMAIN="${CF_SUBDOMAIN:-@}"

    echo ""
    log_info "输入确认:"
    echo "  邮箱:      $CF_EMAIL"
    echo "  API Key:   ${CF_KEY:0:8}****${CF_KEY: -4}"
    echo "  域名:      $CF_DOMAIN"
    echo "  子域名:    $CF_SUBDOMAIN"

    if [ "$CF_SUBDOMAIN" = "@" ]; then
        FULL_DOMAIN="$CF_DOMAIN"
    else
        FULL_DOMAIN="$CF_SUBDOMAIN.$CF_DOMAIN"
    fi
    echo "  最终域名:  $FULL_DOMAIN"

    echo ""
    read -r -p "确认以上信息？(y/n): " CONFIRM
    if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
        log_error "已取消。"
        exit 1
    fi
}

# ----- Verify Cloudflare credentials -----
verify_credentials() {
    log_info "验证 Cloudflare 账户..."
    ZONE_ID=$(curl -s --noproxy "*" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_KEY" \
        "https://api.cloudflare.com/client/v4/zones?name=$CF_DOMAIN" | \
        python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result'][0]['id'] if d['success'] else '')" 2>/dev/null || true)

    if [ -z "$ZONE_ID" ]; then
        log_error "无法获取 Zone ID。请检查邮箱、API Key 和域名是否正确。"
        log_error "确保域名已在 Cloudflare 后台添加。"
        exit 1
    fi

    ACCOUNT_ID=$(curl -s --noproxy "*" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_KEY" \
        "https://api.cloudflare.com/client/v4/accounts" | \
        python3 -c "import sys,json; d=json.load(sys.stdin); print(d['result'][0]['id'] if d['success'] else '')" 2>/dev/null || true)

    if [ -z "$ACCOUNT_ID" ]; then
        log_error "无法获取 Account ID。"
        exit 1
    fi

    log_ok "Cloudflare 验证通过"
    echo "  Zone ID:    $ZONE_ID"
    echo "  Account ID: $ACCOUNT_ID"
}

# ----- Fix apt proxy issues -----
fix_apt_proxy() {
    if [ -f /etc/apt/apt.conf.d/99proxy ]; then
        log_warn "检测到 apt SOCKS5 代理（apt 不支持 socks5），正在备份并移除..."
        sudo mv /etc/apt/apt.conf.d/99proxy /etc/apt/apt.conf.d/99proxy.bak 2>/dev/null || true
    fi
}

# ----- Install Nginx -----
install_nginx() {
    log_info "安装 Nginx..."
    if ! command -v nginx &>/dev/null; then
        # Fix sources if using cn.archive
        if grep -q "cn.archive.ubuntu.com" /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null; then
            log_warn "检测到 cn.archive 源，切换到官方源..."
            sudo sed -i 's|http://cn.archive.ubuntu.com/ubuntu/|http://archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true
        fi
        sudo apt-get update -qq
        sudo apt-get install -y -qq nginx
        sudo systemctl enable nginx
        log_ok "Nginx 安装完成"
    else
        log_ok "Nginx 已安装，跳过"
    fi
    sudo systemctl start nginx 2>/dev/null || true
}

# ----- Install cloudflared -----
install_cloudflared() {
    log_info "安装 cloudflared..."
    if command -v cloudflared &>/dev/null; then
        log_ok "cloudflared 已安装 ($(cloudflared version 2>&1 | head -1))，跳过"
        return
    fi

    log_info "从 GitHub Release 下载 cloudflared..."
    VERSION="2026.6.1"

    # Try direct download first
    if curl -sI --connect-timeout 5 "https://github.com" >/dev/null 2>&1; then
        sudo curl -L --noproxy "*" -o /tmp/cloudflared.deb \
            "https://github.com/cloudflare/cloudflared/releases/download/$VERSION/cloudflared-linux-amd64.deb"
    else
        log_warn "GitHub 直连失败，尝试代理下载..."
        # Try common proxy ports
        for PORT in 10809 7890 8080; do
            if curl -x "http://127.0.0.1:$PORT" -s --connect-timeout 2 "https://github.com" -o /dev/null 2>/dev/null; then
                log_info "使用 HTTP 代理 127.0.0.1:$PORT"
                sudo curl -x "http://127.0.0.1:$PORT" -L -o /tmp/cloudflared.deb \
                    "https://github.com/cloudflare/cloudflared/releases/download/$VERSION/cloudflared-linux-amd64.deb"
                break
            fi
        done
    fi

    if [ ! -f /tmp/cloudflared.deb ] || [ ! -s /tmp/cloudflared.deb ]; then
        log_error "cloudflared 下载失败。请手动下载后重试。"
        log_error "下载地址: https://github.com/cloudflare/cloudflared/releases"
        exit 1
    fi

    sudo dpkg -i /tmp/cloudflared.deb
    log_ok "cloudflared 安装完成 ($(cloudflared version 2>&1 | head -1))"
}

# ----- Create Tunnel via API -----
create_tunnel() {
    log_info "创建 Cloudflare Tunnel..."

    TUNNEL_NAME="cf-tunnel-$(date +%s)"
    TUNNEL_SECRET=$(head -c 32 /dev/urandom | base64)

    CREATE_RESULT=$(curl -s --noproxy "*" -X POST \
        "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/cfd_tunnel" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_KEY" \
        -H "Content-Type: application/json" \
        -d "$(python3 -c "
import json, sys
print(json.dumps({'name': sys.argv[1], 'tunnel_secret': sys.argv[2]}))
" "$TUNNEL_NAME" "$TUNNEL_SECRET")")

    TUNNEL_ID=$(echo "$CREATE_RESULT" | python3 -c "
import sys, json; d=json.load(sys.stdin); print(d['result']['id'] if d.get('success') else '')
" 2>/dev/null || true)

    if [ -z "$TUNNEL_ID" ]; then
        log_error "Tunnel 创建失败:"
        echo "$CREATE_RESULT" | python3 -m json.tool 2>/dev/null || echo "$CREATE_RESULT"
        exit 1
    fi

    log_ok "Tunnel 创建成功"
    echo "  Tunnel ID:   $TUNNEL_ID"
    echo "  Tunnel 名称:  $TUNNEL_NAME"
}

# ----- Create credential files and config -----
configure_tunnel() {
    log_info "配置 Tunnel 凭证和设置..."

    mkdir -p ~/.cloudflared

    # Credential file
    cat > ~/.cloudflared/"$TUNNEL_ID".json << JSONEOF
{
  "AccountTag": "$ACCOUNT_ID",
  "TunnelID": "$TUNNEL_ID",
  "TunnelSecret": "$TUNNEL_SECRET"
}
JSONEOF

    # Config file
    python3 -c "
import json, os
cfg = {
    'tunnel': '$TUNNEL_ID',
    'credentials-file': f'/etc/cloudflared/$TUNNEL_ID.json',
    'ingress': [
        {'hostname': '$FULL_DOMAIN', 'service': 'http://localhost:80'},
        {'service': 'http_status:404'}
    ]
}
with open(os.path.expanduser('~/.cloudflared/config.yml'), 'w') as f:
    json.dump(cfg, f, indent=2)
"

    log_ok "Tunnel 配置完成"
}

# ----- Configure DNS -----
configure_dns() {
    log_info "配置 DNS 记录..."

    DNS_RECORD_NAME="@"
    if [ "$CF_SUBDOMAIN" != "@" ]; then
        DNS_RECORD_NAME="$CF_SUBDOMAIN"
    fi

    DNS_RESULT=$(curl -s --noproxy "*" -X POST \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"type\": \"CNAME\",
            \"name\": \"$DNS_RECORD_NAME\",
            \"content\": \"$TUNNEL_ID.cfargotunnel.com\",
            \"ttl\": 1,
            \"proxied\": true
        }")

    DNS_SUCCESS=$(echo "$DNS_RESULT" | python3 -c "
import sys, json; d=json.load(sys.stdin); print('true' if d.get('success') else 'false')
" 2>/dev/null || echo "false")

    if [ "$DNS_SUCCESS" = "true" ]; then
        log_ok "DNS 记录创建成功"
        echo "  $FULL_DOMAIN → $TUNNEL_ID.cfargotunnel.com (代理已开启)"
    else
        log_error "DNS 记录创建失败:"
        echo "$DNS_RESULT" | python3 -c "
import sys, json; d=json.load(sys.stdin)
for e in d.get('errors', []): print(f'  {e.get(\"message\")}')
" 2>/dev/null || echo "$DNS_RESULT"
        exit 1
    fi
}

# ----- Setup systemd service -----
setup_systemd() {
    log_info "安装系统服务..."

    # Copy configs to system path
    sudo mkdir -p /etc/cloudflared
    sudo cp ~/.cloudflared/"$TUNNEL_ID".json /etc/cloudflared/
    sudo cp ~/.cloudflared/config.yml /etc/cloudflared/
    sudo chmod 644 /etc/cloudflared/*

    # Install service
    sudo cloudflared service install 2>/dev/null || true

    # Restart service
    sudo systemctl restart cloudflared
    sudo systemctl enable cloudflared

    log_ok "系统服务安装完成"
}

# ----- Configure Nginx -----
configure_nginx() {
    log_info "配置 Nginx..."

    sudo tee /etc/nginx/sites-available/"$FULL_DOMAIN" > /dev/null << 'NGINXEOF'
server {
    listen 80;
    listen [::]:80;
    server_name FULL_DOMAIN_PLACEHOLDER;
    root /var/www/html;

    index index.html index.htm;

    # 保持相对重定向，浏览器不会丢失 HTTPS 协议
    absolute_redirect off;

    # 子路径示例（例如 /claude）
    # location /path/ {
    #     alias /var/www/html/path/;
    #     index index.html;
    # }
    # location = /path {
    #     return 301 /path/;
    # }

    location / {
        try_files $uri $uri/ =404;
    }
}
NGINXEOF

    sudo sed -i "s/FULL_DOMAIN_PLACEHOLDER/$FULL_DOMAIN/g" \
        /etc/nginx/sites-available/"$FULL_DOMAIN"

    # Enable site
    sudo ln -sf /etc/nginx/sites-available/"$FULL_DOMAIN" \
        /etc/nginx/sites-enabled/"$FULL_DOMAIN"

    # Disable default site
    sudo rm -f /etc/nginx/sites-enabled/default

    # Test and reload
    if sudo nginx -t 2>/dev/null; then
        sudo nginx -s reload
        log_ok "Nginx 配置完成"
    else
        log_warn "Nginx 配置测试失败，请检查配置"
        sudo nginx -t 2>&1 || true
    fi
}

# ----- Enable Always Use HTTPS -----
enable_https() {
    log_info "开启 Always Use HTTPS..."

    curl -s --noproxy "*" -X PATCH \
        "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/settings/always_use_https" \
        -H "X-Auth-Email: $CF_EMAIL" \
        -H "X-Auth-Key: $CF_KEY" \
        -H "Content-Type: application/json" \
        -d '{"value":"on"}' > /dev/null

    log_ok "Always Use HTTPS 已开启（HTTP 自动跳转 HTTPS）"
}

# ----- Verify -----
verify_deployment() {
    log_info "验证部署..."

    echo ""
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
    printf "${CYAN}  验证清单${NC}\n"
    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

    # Nginx
    if systemctl is-active nginx &>/dev/null; then
        echo "  ✅ Nginx: 运行中"
    else
        echo "  ❌ Nginx: 未运行"
    fi

    # cloudflared
    if systemctl is-active cloudflared &>/dev/null; then
        echo "  ✅ cloudflared: 运行中"
    else
        echo "  ❌ cloudflared: 未运行"
    fi

    # Local Nginx response
    if curl -sI http://localhost/ 2>/dev/null | grep -q "200"; then
        echo "  ✅ Nginx 本地响应: OK"
    else
        echo "  ❌ Nginx 本地响应: 异常"
    fi

    echo ""
    echo "  🌐 访问地址: https://$FULL_DOMAIN/"
    echo ""
    echo "  📁 网页目录: /var/www/html/"
    echo "  📁 Nginx 配置: /etc/nginx/sites-available/$FULL_DOMAIN"
    echo ""
    echo "  ⏱️ DNS 生效可能需要几分钟，请稍后测试。"
    echo ""

    printf "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# =============================================================================
# Main
# =============================================================================
main() {
    echo ""
    printf "${CYAN}┌─────────────────────────────────────────────────┐${NC}\n"
    printf "${CYAN}│  🔒 Cloudflare Tunnel 一键部署                   │${NC}\n"
    printf "${CYAN}│     将本地服务器暴露到公网，无需公网 IP           │${NC}\n"
    printf "${CYAN}└─────────────────────────────────────────────────┘${NC}\n"
    echo ""

    check_prerequisites
    collect_input
    verify_credentials
    fix_apt_proxy
    install_nginx
    install_cloudflared
    create_tunnel
    configure_tunnel
    configure_dns
    setup_systemd
    configure_nginx
    enable_https
    verify_deployment

    log_ok "🎉 部署完成！"
    echo ""
    echo "  浏览器访问 https://$FULL_DOMAIN/ 查看效果"
    echo "  上传网页到 /var/www/html/ 即可发布"
    echo ""
}

main "$@"

#!/bin/bash
set -euo pipefail  # 严格错误处理

# 确保脚本以 root 用户身份运行
if [[ $EUID -ne 0 ]]; then
    echo "此脚本必须以 root 用户身份运行"
    exit 1
fi

# 输入验证
read -p "请输入您的域名: " DOMAIN
if ! [[ "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "无效的域名格式"
    exit 1
fi

read -p "请输入您的电子邮件地址 (默认: test@test.com): " EMAIL
EMAIL=${EMAIL:-test@test.com}
if ! [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "无效的邮箱地址"
    exit 1
fi

read -p "请输入服务器端口号 (默认: 7001): " PORT
PORT=${PORT:-7001}
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || ((PORT < 1 || PORT > 65535)); then
    echo "无效的端口号"
    exit 1
fi

# 安装依赖
apt update
apt install -y ufw certbot python3-certbot-nginx nginx

# 配置防火墙（避免重复添加规则）
if ! ufw status | grep -q '80/tcp.*ALLOW'; then
    ufw allow 80/tcp
fi
if ! ufw status | grep -q '443/tcp.*ALLOW'; then
    ufw allow 443/tcp
fi
ufw --force reload

# 检查后端服务端口
check_service_port() {
    ss -tuln | grep -q ":$1\s"
}
if ! check_service_port $PORT; then
    echo "错误：端口 $PORT 无服务监听，请确保后端服务已启动！"
    exit 1
fi

# 备份 Nginx 配置
BACKUP_DIR="/etc/nginx.bak_$(date +%Y%m%d_%H%M%S)"
cp -r /etc/nginx $BACKUP_DIR

# 清理旧配置
rm -f /etc/nginx/sites-enabled/* /etc/nginx/conf.d/*

# 配置 Nginx 代理（精简版）
cat <<EOF > /etc/nginx/conf.d/${DOMAIN}.conf
server {
    listen 80;
    server_name $DOMAIN;
    location / {
        proxy_pass http://127.0.0.1:$PORT;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 443 ssl http2;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains";
}
EOF

# 申请证书（由 Certbot 插件自动配置）
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

# 检查并重载 Nginx
nginx -t && systemctl reload nginx

# 测试证书自动续期
echo "测试证书自动续期..."
certbot renew --dry-run || {
    echo "续期测试失败！请检查日志：/var/log/letsencrypt/letsencrypt.log"
    exit 1
}

echo "配置完成！证书路径：/etc/letsencrypt/live/$DOMAIN"
echo "自动续期命令已验证成功，请确保 cron 任务已配置："
echo "certbot renew --quiet --post-hook 'systemctl reload nginx'"
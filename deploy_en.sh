#!/bin/bash
set -euo pipefail  # Strict error handling

# Ensure script runs as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Input validation
read -p "Please enter your domain name: " DOMAIN
if ! [[ "$DOMAIN" =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid domain format"
    exit 1
fi

read -p "Please enter your email address (default: test@test.com): " EMAIL
EMAIL=${EMAIL:-test@test.com}
if ! [[ "$EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address"
    exit 1
fi

read -p "Please enter the server port number (default: 7001): " PORT
PORT=${PORT:-7001}
if ! [[ "$PORT" =~ ^[0-9]+$ ]] || ((PORT < 1 || PORT > 65535)); then
    echo "Invalid port number"
    exit 1
fi

# Install dependencies
apt update
apt install -y ufw certbot python3-certbot-nginx nginx

# Configure firewall (avoid duplicate rules)
if ! ufw status | grep -q '80/tcp.*ALLOW'; then
    ufw allow 80/tcp
fi
if ! ufw status | grep -q '443/tcp.*ALLOW'; then
    ufw allow 443/tcp
fi
ufw --force reload

# Check backend service port
check_service_port() {
    ss -tuln | grep -q ":$1\s"
}
if ! check_service_port $PORT; then
    echo "Error: No service listening on port $PORT, please ensure the backend service is running!"
    exit 1
fi

# Backup Nginx configuration
BACKUP_DIR="/etc/nginx.bak_$(date +%Y%m%d_%H%M%S)"
cp -r /etc/nginx $BACKUP_DIR

# Clean old configurations
rm -f /etc/nginx/sites-enabled/* /etc/nginx/conf.d/*

# Configure Nginx proxy (minimalist version)
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

# Request certificate (automatically configured by Certbot plugin)
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m $EMAIL

# Check and reload Nginx
nginx -t && systemctl reload nginx

# Test certificate auto-renewal
echo "Testing certificate auto-renewal..."
certbot renew --dry-run || {
    echo "Renewal test failed! Please check the log: /var/log/letsencrypt/letsencrypt.log"
    exit 1
}

echo "Configuration completed! Certificate path: /etc/letsencrypt/live/$DOMAIN"
echo "Auto-renewal command verified successfully, please ensure cron task is configured:"
echo "certbot renew --quiet --post-hook 'systemctl reload nginx'"
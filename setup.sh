#!/bin/bash
set -e

# Update and install packages
apt-get update -y
apt-get install -y nginx git

# Setup website directory
cd /var/www
rm -rf html
git clone https://github.com/sunil-tribble/website-refresh-2025.git html

# Fix permissions
chown -R www-data:www-data /var/www/html

# Configure nginx
cat > /etc/nginx/sites-available/default << 'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html;
    
    server_name _;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    location ~* \.(glb|gltf)$ {
        add_header Access-Control-Allow-Origin *;
        add_header Cache-Control "public, max-age=3600";
    }
}
NGINX

# Test and restart nginx
nginx -t
systemctl restart nginx

echo "Setup complete!"
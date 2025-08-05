#!/bin/bash

# Quick deployment script for Tribble website
# Run this after you've authenticated with doctl

echo "🚀 Deploying Tribble Website to Digital Ocean..."

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl CLI not found. Please install it first:"
    echo "brew install doctl"
    exit 1
fi

# Check if authenticated
if ! doctl account get &> /dev/null; then
    echo "❌ Not authenticated with Digital Ocean. Please run:"
    echo "doctl auth init"
    exit 1
fi

# Create droplet
echo "📦 Creating droplet..."
doctl compute droplet create tribble-website-$(date +%s) \
  --region nyc3 \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04-x64 \
  --ssh-keys $(doctl compute ssh-key list --format ID --no-header | head -1) \
  --user-data-file <(cat << 'USERDATA'
#!/bin/bash
apt-get update
apt-get install -y nginx git
cd /var/www
git clone https://github.com/sunil-tribble/website-refresh-2025.git html
cat > /etc/nginx/sites-available/default << 'NGINX'
server {
    listen 80 default_server;
    root /var/www/html;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
NGINX
systemctl restart nginx
USERDATA
) \
  --wait \
  --format ID,PublicIPv4,Name \
  --no-header

echo "✅ Deployment complete! Your website should be accessible at the IP address above."
echo "🌐 Visit: http://[IP-ADDRESS-SHOWN-ABOVE]"
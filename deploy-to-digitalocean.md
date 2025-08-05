# Deploy Tribble Website to Digital Ocean

## Quick Deploy Script

Save this as `deploy.sh` and run it on your local machine:

```bash
#!/bin/bash

# Variables
DROPLET_NAME="tribble-website"
REGION="nyc3"
SIZE="s-1vcpu-1gb"
IMAGE="ubuntu-22-04-x64"

# Create droplet
echo "Creating Digital Ocean droplet..."
doctl compute droplet create $DROPLET_NAME \
  --region $REGION \
  --size $SIZE \
  --image $IMAGE \
  --ssh-keys $(doctl compute ssh-key list --format ID --no-header) \
  --wait

# Get IP address
IP=$(doctl compute droplet get $DROPLET_NAME --format PublicIPv4 --no-header)
echo "Droplet created with IP: $IP"

# Wait for SSH to be ready
echo "Waiting for SSH to be ready..."
sleep 30

# Setup script
ssh root@$IP << 'ENDSSH'
# Update system
apt-get update
apt-get upgrade -y

# Install Nginx
apt-get install -y nginx git

# Clone repository
cd /var/www
git clone https://github.com/sunil-tribble/website-refresh-2025.git tribble

# Download the microchip file (optional - uncomment if you have a URL)
# cd /var/www/tribble/models
# wget YOUR_MICROCHIP_URL -O microchip_prototype.glb

# Configure Nginx
cat > /etc/nginx/sites-available/tribble << 'EOF'
server {
    listen 80;
    server_name _;
    
    root /var/www/tribble;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Enable CORS for 3D models
    location ~* \.(glb|gltf)$ {
        add_header Access-Control-Allow-Origin *;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|glb|gltf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable site
ln -s /etc/nginx/sites-available/tribble /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Test and reload Nginx
nginx -t
systemctl reload nginx

# Setup firewall
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable

echo "Deployment complete!"
ENDSSH

echo "Website deployed to: http://$IP"
```

## Manual Setup Instructions

### 1. Create a Droplet

```bash
# Using Digital Ocean CLI
doctl compute droplet create tribble-website \
  --region nyc3 \
  --size s-1vcpu-1gb \
  --image ubuntu-22-04-x64 \
  --ssh-keys YOUR_SSH_KEY_ID
```

Or use the Digital Ocean web interface:
- Ubuntu 22.04
- Basic plan ($6/month)
- 1 vCPU, 1GB RAM
- Any datacenter region

### 2. SSH into your droplet

```bash
ssh root@YOUR_DROPLET_IP
```

### 3. Install dependencies

```bash
# Update system
apt-get update && apt-get upgrade -y

# Install Nginx and Git
apt-get install -y nginx git
```

### 4. Clone and setup the website

```bash
# Clone repository
cd /var/www
git clone https://github.com/sunil-tribble/website-refresh-2025.git tribble

# Set permissions
chown -R www-data:www-data /var/www/tribble
```

### 5. Configure Nginx

```bash
# Create Nginx config
nano /etc/nginx/sites-available/tribble
```

Add this configuration:

```nginx
server {
    listen 80;
    server_name _;
    
    root /var/www/tribble;
    index index.html;
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Enable CORS for 3D models
    location ~* \.(glb|gltf)$ {
        add_header Access-Control-Allow-Origin *;
    }
    
    # Cache static assets
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|glb|gltf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Gzip compression
    gzip on;
    gzip_types text/plain text/css text/javascript application/javascript application/json model/gltf+json;
}
```

```bash
# Enable the site
ln -s /etc/nginx/sites-available/tribble /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# Test and reload
nginx -t
systemctl reload nginx
```

### 6. Setup firewall

```bash
ufw allow 22
ufw allow 80
ufw allow 443
ufw --force enable
```

### 7. (Optional) Setup SSL with Let's Encrypt

```bash
# Install Certbot
apt-get install -y certbot python3-certbot-nginx

# Get certificate (replace YOUR_DOMAIN with your actual domain)
certbot --nginx -d YOUR_DOMAIN
```

### 8. (Optional) Add the microchip file

If you have the microchip_prototype.glb file hosted somewhere:

```bash
cd /var/www/tribble/models
wget YOUR_MICROCHIP_URL -O microchip_prototype.glb
chown www-data:www-data microchip_prototype.glb
```

## Monitoring

Check if the site is running:
```bash
# Check Nginx status
systemctl status nginx

# Check error logs
tail -f /var/log/nginx/error.log

# Check access logs
tail -f /var/log/nginx/access.log
```

## Quick Test

Once deployed, visit:
```
http://YOUR_DROPLET_IP
```

The website should load with the 3D factory visualization!
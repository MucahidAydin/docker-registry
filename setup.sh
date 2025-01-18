#!/bin/bash

# Variables
USERNAME="<username>" # Change this to your desired username
PASSWORD="<password>" # Change this to your desired password
NGINX_CONF="conf/nginx.conf"
AUTH_DIR="conf/auth"
CONF_DIR="conf"
CERT_DIR="conf/certificates"
DAYS_VALID=365

echo "Creating necessary directories..."
mkdir -p "$CONF_DIR"
mkdir -p "$AUTH_DIR"
mkdir -p "$CERT_DIR"

# Generate htpasswd file using the apache/httpd image
echo "Generating authentication file..."
docker run --rm \
  --entrypoint htpasswd \
  httpd:2.4 -Bbn "$USERNAME" "$PASSWORD" > "$AUTH_DIR/htpasswd"

if [ $? -eq 0 ]; then
  echo "Authentication file created at $AUTH_DIR/htpasswd"
else
  echo "Failed to create authentication file. Exiting."
  exit 1
fi

# Generate SSL certificates
echo "Generating SSL certificates..."
openssl req \
  -newkey rsa:4096 -nodes -sha256 -keyout "$CERT_DIR/registry.key" \
  -x509 -days "$DAYS_VALID" -out "$CERT_DIR/registry.crt" \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

if [ $? -eq 0 ]; then
  echo "SSL certificates created in $CERT_DIR/registry.key and $CERT_DIR/registry.crt"
else
  echo "Failed to create SSL certificates. Exiting."
  exit 1
fi

# Create Nginx configuration
echo "Configuring Nginx..."
cat > "$NGINX_CONF" <<EOL
server {
    listen 80;
    listen 443 ssl;
    server_name 0.0.0.0;

    ssl_certificate /etc/nginx/certificates/registry.crt;
    ssl_certificate_key /etc/nginx/certificates/registry.key;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/auth/htpasswd;

    client_max_body_size 2G;  # Increase this to allow larger uploads

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    real_ip_header CF-Connecting-IP;
    add_header X-XSS-Protection "1; mode=block";
    server_tokens off;
    fastcgi_hide_header Server;
    fastcgi_hide_header X-Powered-By;

    location / {
        proxy_pass http://registry:5000/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

if [ $? -eq 0 ]; then
  echo "Nginx configuration created at $NGINX_CONF"
else
  echo "Failed to create Nginx configuration. Exiting."
  exit 1
fi

echo
echo "Setup complete. Run the following command to start your registry:"
echo "--------------------------------------------"
echo "  docker compose up -d"
echo "--------------------------------------------"
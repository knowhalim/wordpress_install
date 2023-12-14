#!/bin/bash

echo "Enter the domain name (e.g., example.com):"
read DOMAIN

sudo a2enmod rewrite
# Define variables
DOC_ROOT="/var/www/$DOMAIN/public_html"
DB_NAME="${DOMAIN//./_}_db"
DB_USER="${DOMAIN//./_}_user"
DB_PASS="$(openssl rand -base64 12)"

# Create document root, set permissions
sudo mkdir -p "$DOC_ROOT"
sudo chown -R www-data:www-data "$DOC_ROOT"

# Create Apache virtual host
VHOST_CONF="/etc/apache2/sites-available/$DOMAIN.conf"
sudo tee "$VHOST_CONF" <<EOF
<VirtualHost *:80>
    ServerAdmin admin@$DOMAIN
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $DOC_ROOT
    <Directory /var/www/$DOMAIN/public_html>
      Options -Indexes +FollowSymLinks
      AllowOverride All
  </Directory>
    ErrorLog \${APACHE_LOG_DIR}/$DOMAIN-error.log
    CustomLog \${APACHE_LOG_DIR}/$DOMAIN-access.log combined
</VirtualHost>
EOF

# Enable site and reload Apache
sudo a2ensite "$DOMAIN"
sudo systemctl reload apache2

# Install Certbot and setup SSL
sudo apt update
sudo apt install -y certbot python3-certbot-apache
sudo certbot --apache -d $DOMAIN -d www.$DOMAIN
sudo systemctl reload apache2

# Create MySQL database and user
echo "Enter MySQL root password:"
read -s ROOT_PASS

sudo mysql -u root -p"$ROOT_PASS" <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EOF

# Download and configure WordPress
cd "$DOC_ROOT"
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz
cp wp-config-sample.php wp-config.php

# Configure wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" wp-config.php
sudo sed -i "s/username_here/$DB_USER/" wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" wp-config.php

echo "WordPress installation for $DOMAIN is ready. Please complete the installation through the web interface."

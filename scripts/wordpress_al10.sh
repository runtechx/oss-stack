#!/bin/bash
set -e

# ============================================================
#  WordPress Deployment Script — AlmaLinux 10
#  Installs: Apache, MariaDB, PHP 8.3, WordPress
# ============================================================

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
WP_DB_NAME="wordpress"
WP_DB_USER="wpuser"
WP_DB_PASS=$(head -c 16 /dev/urandom | base64)
WP_DB_ROOT_PASS=$(head -c 16 /dev/urandom | base64)
#WP_DB_PASS=$(openssl rand -base64 16)
#WP_DB_ROOT_PASS=$(openssl rand -base64 16)
WP_DIR="/var/www/html/wordpress"
SERVER_IP=$(hostname -I | awk '{print $1}')
LOG="/var/log/deploy-wordpress.log"

echo "============================================================"
echo "  WordPress Deployment — AlmaLinux 10"
echo "============================================================"

# -----------------------------
# STEP 1: System Update
# -----------------------------
echo "[1/8] Updating system..."
dnf update -y >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install Apache
# -----------------------------
echo "[2/8] Installing Apache..."
dnf install -y httpd >> "$LOG" 2>&1
systemctl enable --now httpd
firewall-cmd --permanent --add-service=http >> "$LOG" 2>&1
firewall-cmd --permanent --add-service=https >> "$LOG" 2>&1
firewall-cmd --reload >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install MariaDB
# -----------------------------
echo "[3/8] Installing MariaDB..."
dnf install -y mariadb-server >> "$LOG" 2>&1
systemctl enable --now mariadb

# Secure MariaDB
mysql -u root << SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DB_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
SQL

# -----------------------------
# STEP 4: Create WordPress DB
# -----------------------------
echo "[4/8] Creating WordPress database..."
mysql -u root -p"${WP_DB_ROOT_PASS}" << SQL
CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

# -----------------------------
# STEP 5: Install PHP 8.3
# -----------------------------
echo "[5/8] Installing PHP 8.3..."
dnf install -y dnf-utils >> "$LOG" 2>&1
dnf install -y \
    php \
    php-mysqlnd \
    php-fpm \
    php-gd \
    php-xml \
    php-mbstring \
    php-curl \
    php-zip \
    php-intl \
    php-opcache \
    php-json >> "$LOG" 2>&1

systemctl enable --now php-fpm

# -----------------------------
# STEP 6: Download WordPress
# -----------------------------
echo "[6/8] Downloading WordPress..."
curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
tar -xzf /tmp/wordpress.tar.gz -C /tmp/
mkdir -p "$WP_DIR"
cp -r /tmp/wordpress/* "$WP_DIR"/
chown -R apache:apache "$WP_DIR"
chmod -R 755 "$WP_DIR"
rm -f /tmp/wordpress.tar.gz

# -----------------------------
# STEP 7: Configure WordPress
# -----------------------------
echo "[7/8] Configuring WordPress..."
cp "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"

# Set database credentials
sed -i "s/database_name_here/${WP_DB_NAME}/" "$WP_DIR/wp-config.php"
sed -i "s/username_here/${WP_DB_USER}/"      "$WP_DIR/wp-config.php"
sed -i "s/password_here/${WP_DB_PASS}/"      "$WP_DIR/wp-config.php"

# Generate security keys
WP_KEYS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/)
# Replace placeholder block with real keys
PHP_OPEN="<?php"
START="define( 'AUTH_KEY'"
END="define( 'NONCE_SALT'"
perl -i -0pe "s/define\( 'AUTH_KEY'.*?define\( 'NONCE_SALT'.*?;\n/${WP_KEYS}\n/s" "$WP_DIR/wp-config.php" >> "$LOG" 2>&1 || true

# -----------------------------
# STEP 8: Configure Apache VHost
# -----------------------------
echo "[8/8] Configuring Apache..."
cat > /etc/httpd/conf.d/wordpress.conf << VHOST
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot ${WP_DIR}
    ServerName ${SERVER_IP}

    <Directory ${WP_DIR}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/wordpress_error.log
    CustomLog /var/log/httpd/wordpress_access.log combined
</VirtualHost>
VHOST

# Enable mod_rewrite
sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf 2>/dev/null || true

# SELinux permissions
setsebool -P httpd_can_network_connect 1 >> "$LOG" 2>&1 || true
setsebool -P httpd_unified 1 >> "$LOG" 2>&1 || true
chcon -Rt httpd_sys_rw_content_t "$WP_DIR" >> "$LOG" 2>&1 || true

systemctl restart httpd

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
CRED_FILE="/root/wordpress-credentials.txt"
cat > "$CRED_FILE" << CREDS
============================================================
  WordPress Installation — Credentials
  Generated: $(date)
============================================================

  URL               : http://${SERVER_IP}/wordpress
  WP Setup Wizard   : http://${SERVER_IP}/wordpress/wp-admin/install.php

  -- Database --
  DB Name           : ${WP_DB_NAME}
  DB User           : ${WP_DB_USER}
  DB Password       : ${WP_DB_PASS}
  DB Root Password  : ${WP_DB_ROOT_PASS}
  DB Host           : localhost

  -- Server --
  Server IP         : ${SERVER_IP}
  WordPress Path    : ${WP_DIR}
  Apache Config     : /etc/httpd/conf.d/wordpress.conf
  Deploy Log        : ${LOG}
  This file         : ${CRED_FILE}

============================================================
  KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS
============================================================
CREDS

chmod 600 "$CRED_FILE"

# -----------------------------
# SUMMARY OUTPUT
# -----------------------------
echo ""
echo "============================================================"
echo "  WORDPRESS DEPLOYMENT COMPLETE"
echo "============================================================"
echo ""
echo "  URL             : http://${SERVER_IP}/wordpress"
echo "  Setup Wizard    : http://${SERVER_IP}/wordpress/wp-admin/install.php"
echo ""
echo "  DB Name         : ${WP_DB_NAME}"
echo "  DB User         : ${WP_DB_USER}"
echo "  DB Password     : ${WP_DB_PASS}"
echo "  DB Root Pass    : ${WP_DB_ROOT_PASS}"
echo ""
echo "  WordPress Path  : ${WP_DIR}"
echo "  Deploy Log      : ${LOG}"
echo "  Credentials     : ${CRED_FILE}"
echo ""
echo "  Next step: Open the setup wizard URL in your browser"
echo "============================================================"

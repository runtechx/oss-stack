#!/bin/bash
set -e

# ============================================================
#  Passbolt CE Deployment Script — AlmaLinux 10
#  Installs: Nginx, MariaDB, PHP 8.2, Passbolt CE (latest)
#  Note: Bypasses the official repo-setup script which does
#        not yet support AlmaLinux 10. Uses the EL9 RPM repo
#        directly, which is fully compatible with AL10.
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  Passbolt CE Deployment — AlmaLinux 10"
echo "============================================================"
echo ""
echo "  Select language / Selecione o idioma / Choisissez la langue:"
echo ""
echo "  1) Português (PT)"
echo "  2) English   (EN)"
echo "  3) Français  (FR)"
echo ""
read -rp "  > " LANG_CHOICE

case "$LANG_CHOICE" in
    1)
        MSG_TITLE="Instalação Passbolt CE — AlmaLinux 10"
        MSG_STEP1="[1/6] A instalar pré-requisitos e PHP 8.3..."
        MSG_STEP2="[2/6] A instalar e configurar o MariaDB..."
        MSG_STEP3="[3/6] A instalar o Passbolt CE (source/composer)..."
        MSG_STEP4="[4/6] A configurar o Nginx..."
        MSG_STEP5="[5/6] A aplicar políticas SELinux..."
        MSG_STEP6="[6/6] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO PASSBOLT CONCLUÍDA"
        MSG_URL="URL"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no browser e siga o assistente de configuração"
        MSG_CREDTITLE="Instalação Passbolt CE — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_DBSECTION="-- Base de Dados --"
        MSG_SRVSECTION="-- Servidor --"
        MSG_DBNAME="Nome da BD"
        MSG_DBUSER="Utilizador BD"
        MSG_DBPASS="Password BD"
        MSG_DBROOTPASS="Password Root BD"
        MSG_DBHOST="Servidor BD"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_PBVER="Versão Passbolt"
        MSG_INSTALLDIR="Directório de instalação"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        MSG_WARN_WIZARD="Configure o Passbolt através do browser após a instalação."
        ;;
    3)
        MSG_TITLE="Installation Passbolt CE — AlmaLinux 10"
        MSG_STEP1="[1/6] Installation des prérequis et PHP 8.3..."
        MSG_STEP2="[2/6] Installation et configuration de MariaDB..."
        MSG_STEP3="[3/6] Installation de Passbolt CE (source/composer)..."
        MSG_STEP4="[4/6] Configuration de Nginx..."
        MSG_STEP5="[5/6] Application des politiques SELinux..."
        MSG_STEP6="[6/6] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE PASSBOLT TERMINÉE"
        MSG_URL="URL"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans le navigateur et suivez l'assistant de configuration"
        MSG_CREDTITLE="Installation Passbolt CE — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_DBSECTION="-- Base de Données --"
        MSG_SRVSECTION="-- Serveur --"
        MSG_DBNAME="Nom de la BD"
        MSG_DBUSER="Utilisateur BD"
        MSG_DBPASS="Mot de passe BD"
        MSG_DBROOTPASS="Mot de passe Root BD"
        MSG_DBHOST="Hôte BD"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_PBVER="Version Passbolt"
        MSG_INSTALLDIR="Répertoire d'installation"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        MSG_WARN_WIZARD="Configurez Passbolt via le navigateur après l'installation."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Passbolt CE Deployment — AlmaLinux 10"
        MSG_STEP1="[1/6] Installing prerequisites and PHP 8.3..."
        MSG_STEP2="[2/6] Installing and configuring MariaDB..."
        MSG_STEP3="[3/6] Installing Passbolt CE (source/composer)..."
        MSG_STEP4="[4/6] Configuring Nginx..."
        MSG_STEP5="[5/6] Applying SELinux policies..."
        MSG_STEP6="[6/6] Configuring firewall..."
        MSG_DONE="PASSBOLT DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and follow the setup wizard"
        MSG_CREDTITLE="Passbolt CE Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_DBSECTION="-- Database --"
        MSG_SRVSECTION="-- Server --"
        MSG_DBNAME="DB Name"
        MSG_DBUSER="DB User"
        MSG_DBPASS="DB Password"
        MSG_DBROOTPASS="DB Root Password"
        MSG_DBHOST="DB Host"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_PBVER="Passbolt Version"
        MSG_INSTALLDIR="Install Directory"
        MSG_NGINXCONF="Nginx Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        MSG_WARN_WIZARD="Configure Passbolt via the browser after installation."
        ;;
esac

# -----------------------------
# CONFIGURATION
# -----------------------------
INSTALL_DIR="/usr/share/php/passbolt"
DB_NAME="passbolt"
DB_USER="passbolt"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
MYSQL_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-passbolt.log"
CRED_FILE="/root/passbolt-credentials.txt"

# Helper: log a section header
log_section() {
    echo "" >> "$LOG"
    echo "============================================================" >> "$LOG"
    echo "  $1" >> "$LOG"
    echo "============================================================" >> "$LOG"
}

echo ""
echo "============================================================"
echo "  ${MSG_TITLE}"
echo "============================================================"
echo ""
echo "  ${MSG_WARN_TIME}"
echo "  ${MSG_WARN_WIZARD}"
log_section "${MSG_TITLE} — $(date)"

# -----------------------------
# USER PROMPTS
# -----------------------------
echo ""
read -rp "  ${MSG_PROMPT_IP} ($(hostname -I | awk '{print $1}')): " SERVER_IP
SERVER_IP=${SERVER_IP:-$(hostname -I | awk '{print $1}')}

read -rp "  ${MSG_PROMPT_URL} ($(hostname -f)): " ACCESS_URL
ACCESS_URL=${ACCESS_URL:-$(hostname -f)}

echo "  ${MSG_SERVERIP}: ${SERVER_IP}" | tee -a "$LOG"
echo "  ${MSG_ACCESSURL}: ${ACCESS_URL}" | tee -a "$LOG"
echo ""

# -----------------------------
# STEP 1: Prerequisites & PHP 8.2
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: Prerequisites & PHP 8.2"
{
    # Ensure locale is available (avoids the LC_ALL warning from official script)
    dnf install -y glibc-all-langpacks langpacks-en
    localectl set-locale LANG=en_US.UTF-8

    dnf install -y epel-release
    dnf install -y wget curl tar unzip gnupg2 \
        policycoreutils-python-utils nginx certbot python3-certbot-nginx

    # PHP 8.3 from Remi — AL10 uses DNF5 which dropped modularity,
    # so AppStream "module enable" no longer works. Remi PHP 8.3 is
    # fully compatible with Passbolt CE.
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-10.rpm
    dnf install -y php83 php83-php-fpm php83-php-cli \
        php83-php-mysqlnd php83-php-intl php83-php-xml php83-php-mbstring \
        php83-php-curl php83-php-gd php83-php-zip php83-php-opcache \
        php83-php-gnupg php83-php-ldap php83-php-pecl-apcu \
        php83-php-process php83-php-sodium php83-php-pdo

    # Symlink so bare "php" command works system-wide
    ln -sf /usr/bin/php83 /usr/local/bin/php

    # Persist Remi paths for use in later steps
    cat > /etc/deploy-passbolt.env << 'ENVEOF'
PHP_FPM_SERVICE=php83-php-fpm
PHP_FPM_SOCK=/var/opt/remi/php83/run/php-fpm/www.sock
PHP_FPM_CONF=/etc/opt/remi/php83/php-fpm.d/www.conf
ENVEOF

    php -v
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install MariaDB
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install MariaDB"
{
    dnf install -y mariadb-server
    systemctl enable --now mariadb
    sleep 5

    # Secure and set root password
    mysql <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
SQL

    # Create Passbolt database and user
    mysql -uroot -p"${MYSQL_ROOT_PASS}" <<EOF
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE OR REPLACE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

    # Test connectivity
    mysql -u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" -e "SELECT 1;" > /dev/null
    echo "  Database connectivity confirmed."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install Passbolt CE
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install Passbolt CE (source)"
{
    source /etc/deploy-passbolt.env

    # Install additional system deps needed by Passbolt
    dnf install -y gnupg2 git php83-php-pecl-gnupg

    # Install Composer
    curl -fsSL https://getcomposer.org/installer | php83 -- --install-dir=/usr/local/bin --filename=composer
    chmod +x /usr/local/bin/composer

    # Detect latest Passbolt CE release tag from GitHub
    PB_VERSION=$(curl -fsSL https://api.github.com/repos/passbolt/passbolt_api/releases/latest \
        | grep '"tag_name"' | cut -d '"' -f4 | sed 's/^v//')
    if [ -z "$PB_VERSION" ]; then
        echo "  ERROR: Could not detect latest Passbolt version."
        exit 1
    fi
    echo "  Version detected: ${PB_VERSION}"

    # Download and extract
    wget -q -P /tmp "https://github.com/passbolt/passbolt_api/archive/refs/tags/v${PB_VERSION}.tar.gz"
    mkdir -p /var/www/passbolt
    tar -xzf "/tmp/v${PB_VERSION}.tar.gz" -C /var/www/passbolt --strip-components=1
    rm -f "/tmp/v${PB_VERSION}.tar.gz"

    # Install PHP dependencies via Composer (no dev, optimised autoloader)
    cd /var/www/passbolt
    composer install --no-dev --optimize-autoloader --no-interaction --ignore-platform-req=ext-posix

    # Create required directories
    mkdir -p /var/www/passbolt/tmp/{cache,logs,sessions,tests}
    mkdir -p /var/www/passbolt/logs
    mkdir -p /var/www/passbolt/webroot/img/public

    # Write app config (datasource)
    cp /var/www/passbolt/config/app.default.php /var/www/passbolt/config/app.php

    # Write passbolt.php datasource config
    cat > /var/www/passbolt/config/passbolt.php << PBCONF
<?php
return [
    'App' => [
        'fullBaseUrl' => 'http://${ACCESS_URL}',
    ],
    'Datasources' => [
        'default' => [
            'host' => 'localhost',
            'username' => '${DB_USER}',
            'password' => '${DB_PASS}',
            'database' => '${DB_NAME}',
        ],
    ],
    'passbolt' => [
        'registration' => ['public' => false],
        'ssl' => ['force' => false],
    ],
];
PBCONF

    # Generate GPG server key for Passbolt
    export GNUPGHOME=/var/www/passbolt/.gnupg
    mkdir -p "${GNUPGHOME}"
    chmod 700 "${GNUPGHOME}"

    gpg --batch --gen-key << GPGEOF
%no-protection
Key-Type: RSA
Key-Length: 3072
Subkey-Type: RSA
Subkey-Length: 3072
Name-Real: Passbolt Server
Name-Email: passbolt@${ACCESS_URL}
Expire-Date: 0
GPGEOF

    GPG_FINGERPRINT=$(gpg --list-secret-keys --with-colons 2>/dev/null | grep '^fpr' | head -1 | cut -d: -f10)
    gpg --armor --export "${GPG_FINGERPRINT}" > /var/www/passbolt/config/gpg/serverkey.asc
    gpg --armor --export-secret-keys "${GPG_FINGERPRINT}" > /var/www/passbolt/config/gpg/serverkey_private.asc

    # Add GPG key config to passbolt.php
    sed -i "s|'passbolt' => \[|'passbolt' => [\n        'gpg' => [\n            'serverKey' => [\n                'fingerprint' => '${GPG_FINGERPRINT}',\n                'public' => CONFIG . 'gpg/serverkey.asc',\n                'private' => CONFIG . 'gpg/serverkey_private.asc',\n            ],\n        ],|" /var/www/passbolt/config/passbolt.php

    # Ownership
    chown -R nginx:nginx /var/www/passbolt
    chmod -R 750 /var/www/passbolt
    chmod -R 770 /var/www/passbolt/tmp
    chmod -R 770 /var/www/passbolt/logs
    chmod 640 /var/www/passbolt/config/passbolt.php
    chmod 640 /var/www/passbolt/config/gpg/serverkey_private.asc

    echo "  Passbolt CE ${PB_VERSION} installed at /var/www/passbolt"
} >> "$LOG" 2>&1

# Capture version for credentials
PB_VERSION=$(curl -fsSL https://api.github.com/repos/passbolt/passbolt_api/releases/latest \
    | grep '"tag_name"' | cut -d '"' -f4 | sed 's/^v//' 2>/dev/null || echo "unknown")

# -----------------------------
# STEP 4: Configure Nginx
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure Nginx"
{
    # Load Remi PHP paths written in Step 1
    source /etc/deploy-passbolt.env

    NGINX_CONF="/etc/nginx/conf.d/passbolt.conf"
    rm -f /etc/nginx/conf.d/default.conf

    cat > "${NGINX_CONF}" << NGINXEOF
server {
    listen 80;
    listen [::]:80;

    server_name ${SERVER_IP} ${ACCESS_URL};

    root /var/www/passbolt/webroot;
    index index.php;

    client_max_body_size 5m;
    client_body_buffer_size 128k;

    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy "same-origin";

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php\$ {
        fastcgi_pass unix:${PHP_FPM_SOCK};
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_read_timeout 300;
    }

    location ~* \.(ini|log|conf)\$ {
        deny all;
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINXEOF

    # Configure Remi PHP-FPM pool to use correct socket and run as nginx.
    # Important: listen.acl_users overrides listen.owner/group when set —
    # nginx must be added to the ACL or it cannot access the socket.
    sed -i \
        -e "s|^listen = .*|listen = ${PHP_FPM_SOCK}|" \
        -e 's|^;listen.owner = .*|listen.owner = nginx|' \
        -e 's|^;listen.group = .*|listen.group = nginx|' \
        -e 's|^;listen.mode = .*|listen.mode = 0660|' \
        -e 's|^listen.acl_users = apache$|listen.acl_users = apache,nginx|' \
        -e 's|^user = apache|user = nginx|' \
        -e 's|^group = apache|group = nginx|' \
        "${PHP_FPM_CONF}"

    # Ensure the socket directory exists and is owned by nginx
    PHP_FPM_SOCK_DIR=$(dirname "${PHP_FPM_SOCK}")
    mkdir -p "${PHP_FPM_SOCK_DIR}"
    chown nginx:nginx "${PHP_FPM_SOCK_DIR}"

    # Config already written by Step 3 — just reference it
    PB_CONFIG="/var/www/passbolt/config/passbolt.php"

    chown -R nginx:nginx /var/www/passbolt
    chmod 750 /var/www/passbolt
    chmod 640 "${PB_CONFIG}" 2>/dev/null || true

    nginx -t
    systemctl enable --now "${PHP_FPM_SERVICE}" nginx
    systemctl restart "${PHP_FPM_SERVICE}" nginx
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: SELinux
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: SELinux"
{
    if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
        echo "  Applying SELinux contexts and booleans..."

        # Restore default contexts
        restorecon -Rv /var/www/passbolt

        # Passbolt needs to write to tmp/, logs/, webroot/
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/passbolt/tmp(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/passbolt/logs(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/passbolt/config(/.*)?"
        restorecon -Rv /var/www/passbolt/tmp  2>/dev/null || true
        restorecon -Rv /var/www/passbolt/logs 2>/dev/null || true
        restorecon -Rv /var/www/passbolt/config

        # Required booleans
        setsebool -P httpd_can_network_connect on        # Outbound HTTP (email, etc.)
        setsebool -P httpd_can_network_connect_db on     # MariaDB TCP
        setsebool -P httpd_can_sendmail on               # Email notifications
        setsebool -P httpd_unified on                    # AL10 general httpd access

        echo "  SELinux policies applied."
    else
        echo "  SELinux is disabled — skipping."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# STEP 6: Configure Firewall
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Configure Firewall"
{
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
    else
        echo "  firewalld not running — skipping firewall rules."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
log_section "Credentials Saved"

cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}: http://${ACCESS_URL}
  ${MSG_URL}: http://${SERVER_IP}

  NOTE: Complete setup via the browser wizard on first visit.
        You will create the admin account during that step.

  ${MSG_DBSECTION}
  ${MSG_DBNAME}: ${DB_NAME}
  ${MSG_DBUSER}: ${DB_USER}
  ${MSG_DBPASS}: ${DB_PASS}
  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}
  ${MSG_DBHOST}: localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}: ${SERVER_IP}
  ${MSG_ACCESSURL}: ${ACCESS_URL}
  ${MSG_PBVER}: ${PB_VERSION}
  ${MSG_INSTALLDIR}: /var/www/passbolt
  ${MSG_NGINXCONF}: /etc/nginx/conf.d/passbolt.conf
  Passbolt Config: /var/www/passbolt/config/passbolt.php
  ${MSG_LOG}: ${LOG}
  ${MSG_CREDS}: ${CRED_FILE}

============================================================
  ${MSG_KEEPFILE}
============================================================
CREDS

chmod 600 "$CRED_FILE"
echo "  Credentials saved to: $CRED_FILE" >> "$LOG"
log_section "Deployment Finished — $(date)"

# -----------------------------
# SUMMARY OUTPUT
# -----------------------------
echo ""
echo "============================================================"
echo "  ${MSG_DONE}"
echo "============================================================"
echo ""
echo "  ${MSG_URL}: http://${ACCESS_URL}"
echo "  ${MSG_URL}: http://${SERVER_IP}"
echo ""
echo "  NOTE: Open the URL to run the setup wizard."
echo "        Your admin account is created during that step."
echo ""
echo "  ${MSG_DBNAME}: ${DB_NAME}"
echo "  ${MSG_DBUSER}: ${DB_USER}"
echo "  ${MSG_DBPASS}: ${DB_PASS}"
echo "  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}"
echo ""
echo "  ${MSG_PBVER}: ${PB_VERSION}"
echo "  ${MSG_INSTALLDIR}: /var/www/passbolt"
echo "  ${MSG_NGINXCONF}: /etc/nginx/conf.d/passbolt.conf"
echo "  Passbolt Config: /var/www/passbolt/config/passbolt.php"
echo "  ${MSG_LOG}: ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

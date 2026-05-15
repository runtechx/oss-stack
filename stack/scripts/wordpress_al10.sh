#!/bin/bash
set -e

# ============================================================
#  WordPress Deployment Script — AlmaLinux 10
#  Installs: Apache, MariaDB, PHP 8.3, WordPress
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  WordPress Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação WordPress — AlmaLinux 10"
        MSG_STEP1="[1/8] A actualizar o sistema..."
        MSG_STEP2="[2/8] A instalar o Apache..."
        MSG_STEP3="[3/8] A instalar o MariaDB..."
        MSG_STEP4="[4/8] A criar a base de dados WordPress..."
        MSG_STEP5="[5/8] A instalar o PHP 8.3..."
        MSG_STEP6="[6/8] A descarregar o WordPress..."
        MSG_STEP7="[7/8] A configurar o WordPress..."
        MSG_STEP8="[8/8] A configurar o Apache..."
        MSG_DONE="INSTALAÇÃO DO WORDPRESS CONCLUÍDA"
        MSG_URL="URL"
        MSG_WIZARD="Assistente de configuração"
        MSG_WPPATH="Directório WordPress"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL do assistente no seu browser"
        MSG_CREDTITLE="Instalação WordPress — Credenciais"
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
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        ;;
    3)
        MSG_TITLE="Installation WordPress — AlmaLinux 10"
        MSG_STEP1="[1/8] Mise à jour du système..."
        MSG_STEP2="[2/8] Installation d'Apache..."
        MSG_STEP3="[3/8] Installation de MariaDB..."
        MSG_STEP4="[4/8] Création de la base de données WordPress..."
        MSG_STEP5="[5/8] Installation de PHP 8.3..."
        MSG_STEP6="[6/8] Téléchargement de WordPress..."
        MSG_STEP7="[7/8] Configuration de WordPress..."
        MSG_STEP8="[8/8] Configuration d'Apache..."
        MSG_DONE="INSTALLATION DE WORDPRESS TERMINÉE"
        MSG_URL="URL"
        MSG_WIZARD="Assistant de configuration"
        MSG_WPPATH="Répertoire WordPress"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL de l'assistant dans votre navigateur"
        MSG_CREDTITLE="Installation WordPress — Identifiants"
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
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="WordPress Deployment — AlmaLinux 10"
        MSG_STEP1="[1/8] Updating system..."
        MSG_STEP2="[2/8] Installing Apache..."
        MSG_STEP3="[3/8] Installing MariaDB..."
        MSG_STEP4="[4/8] Creating WordPress database..."
        MSG_STEP5="[5/8] Installing PHP 8.3..."
        MSG_STEP6="[6/8] Downloading WordPress..."
        MSG_STEP7="[7/8] Configuring WordPress..."
        MSG_STEP8="[8/8] Configuring Apache..."
        MSG_DONE="WORDPRESS DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_WIZARD="Setup Wizard"
        MSG_WPPATH="WordPress Path"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the setup wizard URL in your browser"
        MSG_CREDTITLE="WordPress Installation — Credentials"
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
        MSG_APACHECONF="Apache Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
WP_DB_NAME="wordpress"
WP_DB_USER="wpuser"
WP_DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
WP_DB_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
WP_DIR="/var/www/html/wordpress"
LOG="/var/log/deploy-wordpress.log"
CRED_FILE="/root/wordpress-credentials.txt"

# Helper: log a section header to the log file
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
# STEP 1: System Update
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update"
{
    dnf update -y
    dnf install -y tar curl
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install Apache
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install Apache"
{
    dnf install -y httpd
    systemctl enable --now httpd
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install MariaDB
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install MariaDB"
{
    dnf install -y mariadb-server
    systemctl enable --now mariadb

    echo "  Securing MariaDB..."
    mysql -u root << SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_DB_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
SQL
} >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Create WordPress DB
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Create WordPress Database"
{
    mysql -u root -p"${WP_DB_ROOT_PASS}" << SQL
CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Install PHP 8.3
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Install PHP 8.3"
{
    dnf install -y dnf-utils
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
        php-json
    systemctl enable --now php-fpm
} >> "$LOG" 2>&1

# -----------------------------
# STEP 6: Download WordPress
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Download WordPress"
{
    curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz
    tar -xzf /tmp/wordpress.tar.gz -C /tmp/
    mkdir -p "$WP_DIR"
    cp -r /tmp/wordpress/* "$WP_DIR"/
    chown -R apache:apache "$WP_DIR"
    chmod -R 755 "$WP_DIR"
    rm -f /tmp/wordpress.tar.gz
    echo "  WordPress files placed at: $WP_DIR"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 7: Configure WordPress
# -----------------------------
echo "${MSG_STEP7}"
log_section "STEP 7: Configure WordPress"
{
    cp "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"

    sed -i "s/database_name_here/${WP_DB_NAME}/" "$WP_DIR/wp-config.php"
    sed -i "s/username_here/${WP_DB_USER}/"      "$WP_DIR/wp-config.php"
    sed -i "s/password_here/${WP_DB_PASS}/"      "$WP_DIR/wp-config.php"
    echo "  Database credentials written to wp-config.php"

    echo "  Fetching WordPress security keys..."
    WP_KEYS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/)
    perl -i -0pe "s/define\( 'AUTH_KEY'.*?define\( 'NONCE_SALT'.*?;\n/${WP_KEYS}\n/s" "$WP_DIR/wp-config.php" || true
    echo "  Security keys injected into wp-config.php"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 8: Configure Apache VHost
# -----------------------------
echo "${MSG_STEP8}"
log_section "STEP 8: Configure Apache VHost"
{
    cat > /etc/httpd/conf.d/wordpress.conf << VHOST
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot ${WP_DIR}
    ServerName ${SERVER_IP}
    ServerAlias ${ACCESS_URL}

    <Directory ${WP_DIR}>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/wordpress_error.log
    CustomLog /var/log/httpd/wordpress_access.log combined
</VirtualHost>
VHOST
    echo "  VHost config written to /etc/httpd/conf.d/wordpress.conf"

    sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf || true

    echo "  Applying SELinux permissions..."
    setsebool -P httpd_can_network_connect 1 || true
    setsebool -P httpd_unified 1 || true
    chcon -Rt httpd_sys_rw_content_t "$WP_DIR" || true

    systemctl restart httpd
    echo "  Apache restarted successfully"
} >> "$LOG" 2>&1

# -----------------------------
# CONFIGURE FIREWALL
# -----------------------------
log_section "STEP 9: Configure Firewall"
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
WPVERSION=$(rpm -q wordpress --qf '%{VERSION}-%{RELEASE}\n' 2>/dev/null || echo "latest")

cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}:
  http://${ACCESS_URL}/wordpress
  http://${SERVER_IP}/wordpress
  ${MSG_WIZARD}:
  http://${ACCESS_URL}/wordpress/wp-admin/install.php
  http://${SERVER_IP}/wordpress/wp-admin/install.php

  ${MSG_DBSECTION}
  ${MSG_DBNAME}:
  ${WP_DB_NAME}
  ${MSG_DBUSER}:
  ${WP_DB_USER}
  ${MSG_DBPASS}:
  ${WP_DB_PASS}
  ${MSG_DBROOTPASS}:
  ${WP_DB_ROOT_PASS}
  ${MSG_DBHOST}:
  localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  ${ACCESS_URL}
  ${MSG_WPPATH}:
  ${WP_DIR}
  ${MSG_APACHECONF}:
  /etc/httpd/conf.d/wordpress.conf
  ${MSG_LOG}:
  ${LOG}
  ${MSG_CREDS}:
  ${CRED_FILE}

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
echo "  ${MSG_URL}:"
echo "  http://${ACCESS_URL}/"
echo "  http://${SERVER_IP}/"
echo "  ${MSG_WIZARD}:"
echo "  http://${SERVER_IP}/wp-admin/install.php"
echo ""
echo "  ${MSG_DBNAME}:"
echo "  ${WP_DB_NAME}"
echo "  ${MSG_DBUSER}:"
echo "  ${WP_DB_USER}"
echo "  ${MSG_DBPASS}:"
echo "  ${WP_DB_PASS}"
echo "  ${MSG_DBROOTPASS}:"
echo "  ${WP_DB_ROOT_PASS}"
echo ""
echo "  ${MSG_WPPATH}:"
echo "  ${WP_DIR}"
echo "  ${MSG_LOG}:"
echo "  ${LOG}"
echo "  ${MSG_CREDS}:"
echo "  ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

#!/bin/bash
set -e

# ============================================================
#  GLPI Deployment Script — AlmaLinux 10
#  Installs: Apache, MariaDB, PHP 8.5 (Remi), GLPI (latest)
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  GLPI Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação GLPI — AlmaLinux 10"
        MSG_STEP1="[1/5] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/5] A instalar e configurar o MariaDB..."
        MSG_STEP3="[3/5] A instalar o GLPI..."
        MSG_STEP4="[4/5] A configurar o Apache..."
        MSG_STEP5="[5/5] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO GLPI CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com glpi / glpi"
        MSG_CREDTITLE="Instalação GLPI — Credenciais"
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
        MSG_GLPIVER="Versão GLPI"
        MSG_DEFLOGIN="Login padrão"
        MSG_DEFPASS="Password padrão"
        MSG_APACHECONF="Config Apache"
        MSG_INSTALLDIR="Directório de instalação"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        ;;
    3)
        MSG_TITLE="Installation GLPI — AlmaLinux 10"
        MSG_STEP1="[1/5] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/5] Installation et configuration de MariaDB..."
        MSG_STEP3="[3/5] Installation de GLPI..."
        MSG_STEP4="[4/5] Configuration d'Apache..."
        MSG_STEP5="[5/5] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE GLPI TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec glpi / glpi"
        MSG_CREDTITLE="Installation GLPI — Identifiants"
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
        MSG_GLPIVER="Version GLPI"
        MSG_DEFLOGIN="Login par défaut"
        MSG_DEFPASS="Mot de passe par défaut"
        MSG_APACHECONF="Config Apache"
        MSG_INSTALLDIR="Répertoire d'installation"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="GLPI Deployment — AlmaLinux 10"
        MSG_STEP1="[1/5] Updating system and installing prerequisites..."
        MSG_STEP2="[2/5] Installing and configuring MariaDB..."
        MSG_STEP3="[3/5] Installing GLPI..."
        MSG_STEP4="[4/5] Configuring Apache..."
        MSG_STEP5="[5/5] Configuring firewall..."
        MSG_DONE="GLPI DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with glpi / glpi"
        MSG_CREDTITLE="GLPI Installation — Credentials"
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
        MSG_GLPIVER="GLPI Version"
        MSG_DEFLOGIN="Default Login"
        MSG_DEFPASS="Default Password"
        MSG_APACHECONF="Apache Config"
        MSG_INSTALLDIR="Install Directory"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
INSTALL_DIR="/var/www/html/glpi"
DB_NAME="glpi"
DB_USER="glpi"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
MYSQL_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-glpi.log"
CRED_FILE="/root/glpi-credentials.txt"

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
echo ""
echo "  ${MSG_WARN_TIME}"
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
# STEP 1: Prerequisites & PHP
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update & Prerequisites"
{
    dnf install -y epel-release
    dnf install -y wget tar unzip net-tools bzip2 policycoreutils-python-utils httpd mod_ssl
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-10.rpm
    dnf module reset php -y
    dnf module enable php:remi-8.5 -y
    dnf install -y php php-{mbstring,mysqli,xml,cli,ldap,openssl,xmlrpc,pecl-apcu,zip,curl,gd,json,session,imap,intl,zlib,redis,bcmath}
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

    # Secure installation — set root password and harden defaults
    mysql <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
SQL

    # Create GLPI database and user
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
# STEP 3: Install GLPI
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install GLPI"
{
    # Detect latest release from GitHub API
    GLPI_VERSION=$(curl -fsSL https://api.github.com/repos/glpi-project/glpi/releases/latest \
        | grep '"tag_name"' \
        | cut -d '"' -f4 \
        | sed 's/^v//')

    if [ -z "$GLPI_VERSION" ]; then
        echo "  ERROR: Could not detect latest GLPI version."
        exit 1
    fi
    echo "  Version detected: ${GLPI_VERSION}"

    # Download and extract
    wget -q -P /tmp "https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz"
    tar -xzf "/tmp/glpi-${GLPI_VERSION}.tgz" -C /var/www/html/
    rm -f "/tmp/glpi-${GLPI_VERSION}.tgz"

    # Fix ownership before db:install so PHP can write config/
    chown -R apache:apache /var/www/html/glpi
    chmod -R 755 /var/www/html/glpi

    # Wait for MariaDB to be fully ready before running the installer
    echo "  Waiting for MariaDB to be ready..."
    for i in $(seq 1 12); do
        if mysql -u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" -e "SELECT 1;" > /dev/null 2>&1; then
            echo "  MariaDB is ready."
            break
        fi
        sleep 5
    done

    # Run console installer (non-interactive)
    php /var/www/html/glpi/bin/console db:install \
        --db-host=localhost \
        --db-name="${DB_NAME}" \
        --db-user="${DB_USER}" \
        --db-password="${DB_PASS}" \
        --no-interaction \
        --lang=en_GB

    echo "  GLPI installed at: /var/www/html/glpi"
    echo "  Version: ${GLPI_VERSION}"
} >> "$LOG" 2>&1

# Capture version outside the log block for use in credentials
GLPI_VERSION=$(curl -fsSL https://api.github.com/repos/glpi-project/glpi/releases/latest \
    | grep '"tag_name"' | cut -d '"' -f4 | sed 's/^v//' 2>/dev/null || echo "unknown")

# -----------------------------
# STEP 4: Configure Apache & SELinux
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure Apache & SELinux"
{
    systemctl enable --now httpd

    # Write virtual host configuration
    cat > /etc/httpd/conf.d/glpi.conf << EOF
<VirtualHost *:80>
    ServerName ${SERVER_IP}
    ServerAlias ${ACCESS_URL}
    DocumentRoot /var/www/html/glpi/public

    <Directory /var/www/html/glpi/public>
        AllowOverride All
        RewriteEngine On
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteRule ^(.*)$ index.php [QSA,L]
    </Directory>

    ErrorLog /var/log/httpd/glpi_error.log
    CustomLog /var/log/httpd/glpi_access.log combined
</VirtualHost>
EOF

    # Harden PHP session cookie
    cp /etc/php.ini /etc/php.ini.bak
    sed -i 's/^session.cookie_httponly =.*/session.cookie_httponly = 1/' /etc/php.ini

    # Fix file ownership (re-apply after db:install may have written files as root)
    chown -R apache:apache /var/www/html/glpi
    chmod -R 755 /var/www/html/glpi

    # Remove the web installer once console install is done
    rm -f /var/www/html/glpi/install/install.php

    # SELinux — full set of required policies for GLPI on AlmaLinux 10
    if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
        echo "  Applying SELinux contexts and booleans..."

        # Restore default contexts on the web root
        restorecon -Rv /var/www/html/glpi

        # GLPI writes to files/ — needs httpd_sys_rw_content_t
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/glpi/files(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/glpi/config(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/glpi/marketplace(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/glpi/plugins(/.*)?"
        restorecon -Rv /var/www/html/glpi/files
        restorecon -Rv /var/www/html/glpi/config
        restorecon -Rv /var/www/html/glpi/marketplace
        restorecon -Rv /var/www/html/glpi/plugins

        # Required booleans
        setsebool -P httpd_can_network_connect on       # PHP-FPM socket / outbound HTTP
        setsebool -P httpd_can_network_connect_db on    # MariaDB TCP connection
        setsebool -P httpd_can_sendmail on              # GLPI email notifications
        setsebool -P httpd_unified on                   # Needed on some AL10 builds

        echo "  SELinux policies applied."
    else
        echo "  SELinux is disabled — skipping."
    fi

    # Load MariaDB timezone tables (fixes GLPI timezone warning)
    echo "  Loading timezone data into MariaDB..."
    mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -uroot -p"${MYSQL_ROOT_PASS}" mysql 2>/dev/null || true
    mysql -uroot -p"${MYSQL_ROOT_PASS}" \
        -e "GRANT SELECT ON mysql.time_zone_name TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;" 2>/dev/null || true
    echo "  Timezone data loaded."

    systemctl restart mariadb php-fpm httpd
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Configure Firewall
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Configure Firewall"
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

  ${MSG_DEFLOGIN}: glpi
  ${MSG_DEFPASS}: glpi

  ${MSG_DBSECTION}
  ${MSG_DBNAME}: ${DB_NAME}
  ${MSG_DBUSER}: ${DB_USER}
  ${MSG_DBPASS}: ${DB_PASS}
  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}
  ${MSG_DBHOST}: localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}: ${SERVER_IP}
  ${MSG_ACCESSURL}: ${ACCESS_URL}
  ${MSG_GLPIVER}: ${GLPI_VERSION}
  ${MSG_INSTALLDIR}: ${INSTALL_DIR}
  ${MSG_APACHECONF}: /etc/httpd/conf.d/glpi.conf
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
echo "  ${MSG_URL}:"
echo "  http://${ACCESS_URL}"
echo "  http://${SERVER_IP}"
echo ""
echo "  ${MSG_DEFLOGIN}: glpi"
echo "  ${MSG_DEFPASS}: glpi"
echo ""
echo "  ${MSG_DBNAME}: ${DB_NAME}"
echo "  ${MSG_DBUSER}: ${DB_USER}"
echo "  ${MSG_DBPASS}: ${DB_PASS}"
echo "  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}"
echo ""
echo "  ${MSG_GLPIVER}: ${GLPI_VERSION}"
echo "  ${MSG_INSTALLDIR}: ${INSTALL_DIR}"
echo "  ${MSG_APACHECONF}: /etc/httpd/conf.d/glpi.conf"
echo "  ${MSG_LOG}: ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

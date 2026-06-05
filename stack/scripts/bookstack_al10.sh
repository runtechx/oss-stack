#!/bin/bash
set -e

# ============================================================
#  BookStack Deployment Script — AlmaLinux 10
#  Installs: Nginx, MariaDB, PHP 8.5 (Remi), BookStack (latest)
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  BookStack Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação BookStack — AlmaLinux 10"
        MSG_STEP1="[1/5] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/5] A instalar e configurar o MariaDB..."
        MSG_STEP3="[3/5] A instalar o BookStack..."
        MSG_STEP4="[4/5] A configurar o Nginx..."
        MSG_STEP5="[5/5] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO BOOKSTACK CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com admin@admin.com / password"
        MSG_CREDTITLE="Instalação BookStack — Credenciais"
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
        MSG_BSVER="Versão BookStack"
        MSG_DEFLOGIN="Login padrão"
        MSG_DEFPASS="Password padrão"
        MSG_NGINXCONF="Config Nginx"
        MSG_INSTALLDIR="Directório de instalação"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        ;;
    3)
        MSG_TITLE="Installation BookStack — AlmaLinux 10"
        MSG_STEP1="[1/5] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/5] Installation et configuration de MariaDB..."
        MSG_STEP3="[3/5] Installation de BookStack..."
        MSG_STEP4="[4/5] Configuration de Nginx..."
        MSG_STEP5="[5/5] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE BOOKSTACK TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec admin@admin.com / password"
        MSG_CREDTITLE="Installation BookStack — Identifiants"
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
        MSG_BSVER="Version BookStack"
        MSG_DEFLOGIN="Login par défaut"
        MSG_DEFPASS="Mot de passe par défaut"
        MSG_NGINXCONF="Config Nginx"
        MSG_INSTALLDIR="Répertoire d'installation"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="BookStack Deployment — AlmaLinux 10"
        MSG_STEP1="[1/5] Updating system and installing prerequisites..."
        MSG_STEP2="[2/5] Installing and configuring MariaDB..."
        MSG_STEP3="[3/5] Installing BookStack..."
        MSG_STEP4="[4/5] Configuring Nginx..."
        MSG_STEP5="[5/5] Configuring firewall..."
        MSG_DONE="BOOKSTACK DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with admin@admin.com / password"
        MSG_CREDTITLE="BookStack Installation — Credentials"
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
        MSG_BSVER="BookStack Version"
        MSG_DEFLOGIN="Default Login"
        MSG_DEFPASS="Default Password"
        MSG_NGINXCONF="Nginx Config"
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
INSTALL_DIR="/var/www/bookstack"
DB_NAME="bookstack"
DB_USER="bookstack"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
MYSQL_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-bookstack.log"
CRED_FILE="/root/bookstack-credentials.txt"

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
    dnf install -y wget curl tar unzip git policycoreutils-python-utils
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-10.rpm
    dnf module reset php -y
    dnf module enable php:remi-8.5 -y
    dnf install -y php php-fpm php-{cli,mbstring,mysqlnd,xml,gd,bcmath,ldap,zip,curl,pecl-zip}
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

    # Create BookStack database and user
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
# STEP 3: Install BookStack
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install BookStack"
{
    # Clone latest release branch
    git clone https://github.com/BookStackApp/BookStack.git \
        --branch release --single-branch "${INSTALL_DIR}"

    # Install Composer dependencies via bundled CLI tool
    cd "${INSTALL_DIR}"
    php bookstack-system-cli download-vendor

    # Configure environment
    cp .env.example .env
    sed -i "s@APP_URL=.*\$@APP_URL=http://${ACCESS_URL}@"   .env
    sed -i "s/DB_DATABASE=.*$/DB_DATABASE=${DB_NAME}/"      .env
    sed -i "s/DB_USERNAME=.*$/DB_USERNAME=${DB_USER}/"      .env
    sed -i "s/DB_PASSWORD=.*\$/DB_PASSWORD=${DB_PASS}/"     .env

    # Generate application key
    php artisan key:generate --no-interaction --force

    # Run database migrations
    php artisan migrate --no-interaction --force

    # Set ownership and permissions
    chown -R nginx:nginx "${INSTALL_DIR}"
    chmod -R 755 "${INSTALL_DIR}"
    chmod -R 775 "${INSTALL_DIR}/bootstrap/cache" \
                 "${INSTALL_DIR}/public/uploads" \
                 "${INSTALL_DIR}/storage"
    chmod 740 "${INSTALL_DIR}/.env"

    # Tell git to ignore permission changes
    git -C "${INSTALL_DIR}" config core.fileMode false

    echo "  BookStack installed at: ${INSTALL_DIR}"
} >> "$LOG" 2>&1

# Capture version outside the log block for use in credentials
BS_VERSION=$(cat "${INSTALL_DIR}/version" 2>/dev/null || echo "unknown")

# -----------------------------
# STEP 4: Configure Nginx, PHP-FPM & SELinux
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure Nginx, PHP-FPM & SELinux"
{
    dnf install -y nginx

    # Write virtual host configuration
    cat > /etc/nginx/conf.d/bookstack.conf << EOF
server {
    listen 80;
    listen [::]:80;

    server_name ${SERVER_IP} ${ACCESS_URL};

    root ${INSTALL_DIR}/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass unix:/run/php-fpm/www.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?)$ {
        expires max;
        log_not_found off;
    }

    error_log  /var/log/nginx/bookstack_error.log;
    access_log /var/log/nginx/bookstack_access.log combined;
}
EOF

    # Harden PHP session cookie
    cp /etc/php.ini /etc/php.ini.bak
    sed -i 's/^session.cookie_httponly =.*/session.cookie_httponly = 1/' /etc/php.ini

    # SELinux — required policies for BookStack on AlmaLinux 10
    if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" != "Disabled" ]; then
        echo "  Applying SELinux contexts and booleans..."

        semanage fcontext -a -t httpd_sys_content_t    "${INSTALL_DIR}(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/storage(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/bootstrap/cache(/.*)?"
        semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/public/uploads(/.*)?"
        restorecon -Rv "${INSTALL_DIR}"

        setsebool -P httpd_can_network_connect on
        setsebool -P httpd_can_network_connect_db on
        setsebool -P httpd_can_sendmail on

        echo "  SELinux policies applied."
    else
        echo "  SELinux is disabled — skipping."
    fi

    nginx -t
    systemctl enable --now php-fpm nginx
    systemctl restart php-fpm nginx
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

  ${MSG_DEFLOGIN}: admin@admin.com
  ${MSG_DEFPASS}: password

  ${MSG_DBSECTION}
  ${MSG_DBNAME}: ${DB_NAME}
  ${MSG_DBUSER}: ${DB_USER}
  ${MSG_DBPASS}: ${DB_PASS}
  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}
  ${MSG_DBHOST}: localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}: ${SERVER_IP}
  ${MSG_ACCESSURL}: ${ACCESS_URL}
  ${MSG_BSVER}: ${BS_VERSION}
  ${MSG_INSTALLDIR}: ${INSTALL_DIR}
  ${MSG_NGINXCONF}: /etc/nginx/conf.d/bookstack.conf
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
echo "  ${MSG_DEFLOGIN}: admin@admin.com"
echo "  ${MSG_DEFPASS}: password"
echo ""
echo "  ${MSG_DBNAME}: ${DB_NAME}"
echo "  ${MSG_DBUSER}: ${DB_USER}"
echo "  ${MSG_DBPASS}: ${DB_PASS}"
echo "  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}"
echo ""
echo "  ${MSG_BSVER}: ${BS_VERSION}"
echo "  ${MSG_INSTALLDIR}: ${INSTALL_DIR}"
echo "  ${MSG_NGINXCONF}: /etc/nginx/conf.d/bookstack.conf"
echo "  ${MSG_LOG}: ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

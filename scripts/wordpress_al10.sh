#!/bin/bash
set -e

# ============================================================
#  WordPress Stack Deployment Script — AlmaLinux 10
#  Installs: Apache, MariaDB, PHP 8.5 (Remi), WordPress
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  WordPress Stack Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação WordPress Stack — AlmaLinux 10"
        MSG_STEP1="[1/6] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/6] A instalar o Apache..."
        MSG_STEP3="[3/6] A instalar o PHP 8.5..."
        MSG_STEP4="[4/6] A instalar o MariaDB e a criar a base de dados..."
        MSG_STEP5="[5/6] A descarregar e a configurar o WordPress..."
        MSG_STEP6="[6/6] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO WORDPRESS CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser para concluir a configuração"
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
        MSG_WPVER="Versão WordPress"
        MSG_WPPATH="Directório WordPress"
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        ;;
    3)
        MSG_TITLE="Installation WordPress Stack — AlmaLinux 10"
        MSG_STEP1="[1/6] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/6] Installation d'Apache..."
        MSG_STEP3="[3/6] Installation de PHP 8.5..."
        MSG_STEP4="[4/6] Installation de MariaDB et création de la base de données..."
        MSG_STEP5="[5/6] Téléchargement et configuration de WordPress..."
        MSG_STEP6="[6/6] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE WORDPRESS TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur pour terminer la configuration"
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
        MSG_WPVER="Version WordPress"
        MSG_WPPATH="Répertoire WordPress"
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="WordPress Stack Deployment — AlmaLinux 10"
        MSG_STEP1="[1/6] Updating system and installing prerequisites..."
        MSG_STEP2="[2/6] Installing Apache..."
        MSG_STEP3="[3/6] Installing PHP 8.5..."
        MSG_STEP4="[4/6] Installing MariaDB and creating database..."
        MSG_STEP5="[5/6] Downloading and configuring WordPress..."
        MSG_STEP6="[6/6] Configuring firewall..."
        MSG_DONE="WORDPRESS DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser to complete the setup"
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
        MSG_WPVER="WordPress Version"
        MSG_WPPATH="WordPress Path"
        MSG_APACHECONF="Apache Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
TMP_DIR="/tmp"
INSTALL_DIR="/var/www/html"
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
MYSQL_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-wordpress-stack.log"
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
# STEP 1: Prerequisites
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update & Prerequisites"
{
    dnf install -y epel-release
    dnf config-manager --set-enabled crb
    dnf install -y wget curl tar
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install Apache
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install Apache"
{
    dnf install -y httpd httpd-tools
    systemctl enable --now httpd
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install PHP 8.5
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install PHP 8.5"
{
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm
    dnf install -y https://rpms.remirepo.net/enterprise/remi-release-10.rpm
    dnf module -y switch-to php:remi-8.5
    dnf module install -y php:remi-8.5
    dnf install -y php-{fpm,gd,json,mbstring,mysqlnd,xml,xmlrpc,opcache,cli,zip,soap,intl,bcmath,curl,ssh2}
    systemctl restart httpd
} >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Install MariaDB & Create Database
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Install MariaDB & Create Database"
{
    dnf install -y mariadb-server mariadb
    systemctl enable --now mariadb

    # Create DB and user before setting root password (socket auth)
    mysql -e "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
    mysql -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"

    # Secure root and remove defaults
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';"
    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "DELETE FROM mysql.user WHERE User='';"
    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "DROP DATABASE IF EXISTS test;"
    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e "FLUSH PRIVILEGES;"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Download & Configure WordPress
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Download & Configure WordPress"
{
    # Download and extract
    cd "${TMP_DIR}"
    curl -fsSL https://wordpress.org/latest.tar.gz -o wordpress.tar.gz
    tar xf wordpress.tar.gz
    cp -r wordpress "${INSTALL_DIR}/"

    # Permissions
    chown -R apache:apache "${INSTALL_DIR}/wordpress"

    # SELinux
    if [ "$(getenforce 2>/dev/null)" = "Enforcing" ] || \
       [ "$(getenforce 2>/dev/null)" = "Permissive" ]; then
        chcon -t httpd_sys_rw_content_t "${INSTALL_DIR}/wordpress" -R
        setsebool -P httpd_can_network_connect true
    fi

    # Apache VirtualHost
    tee /etc/httpd/conf.d/wordpress.conf << EOF
<VirtualHost *:80>
    ServerName ${ACCESS_URL}
    ServerAlias ${SERVER_IP}
    DocumentRoot ${INSTALL_DIR}/wordpress
    <Directory ${INSTALL_DIR}/wordpress>
        AllowOverride All
        Require all granted
    </Directory>
    ErrorLog /var/log/httpd/wordpress_error.log
    CustomLog /var/log/httpd/wordpress_access.log combined
</VirtualHost>
EOF

    systemctl restart httpd
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

WP_VERSION="unknown"
if [[ -f "${INSTALL_DIR}/wordpress/wp-includes/version.php" ]]; then
    WP_VERSION=$(sed -n "s/^[[:space:]]*\$wp_version[[:space:]]*=[[:space:]]*'\([^']*\)'.*/\1/p" \
        "${INSTALL_DIR}/wordpress/wp-includes/version.php")
fi

cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}:
  http://${ACCESS_URL}/wordpress
  http://${SERVER_IP}/wordpress

  ${MSG_DBSECTION}
  ${MSG_DBNAME}:
  ${DB_NAME}
  ${MSG_DBUSER}:
  ${DB_USER}
  ${MSG_DBPASS}:
  ${DB_PASS}
  ${MSG_DBROOTPASS}:
  ${MYSQL_ROOT_PASS}
  ${MSG_DBHOST}:
  localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  ${ACCESS_URL}
  ${MSG_WPVER}:
  ${WP_VERSION}
  ${MSG_WPPATH}:
  ${INSTALL_DIR}/wordpress
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
echo "  http://${ACCESS_URL}/wordpress"
echo "  http://${SERVER_IP}/wordpress"
echo ""
echo "  ${MSG_DBNAME}:"
echo "  ${DB_NAME}"
echo "  ${MSG_DBUSER}:"
echo "  ${DB_USER}"
echo "  ${MSG_DBPASS}:"
echo "  ${DB_PASS}"
echo "  ${MSG_DBROOTPASS}:"
echo "  ${MYSQL_ROOT_PASS}"
echo ""
echo "  ${MSG_WPVER}:"
echo "  ${WP_VERSION}"
echo "  ${MSG_WPPATH}:"
echo "  ${INSTALL_DIR}/wordpress"
echo "  ${MSG_LOG}:"
echo "  ${LOG}"
echo "  ${MSG_CREDS}:"
echo "  ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

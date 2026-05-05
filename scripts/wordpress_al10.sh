#!/bin/bash
set -e

# ============================================================
#  WordPress Deployment Script — AlmaLinux 10
#  Installs: Apache, MariaDB, PHP 8.3, WordPress
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
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
        MSG_CREDS="Credenciais"
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
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
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
        MSG_CREDS="Identifiants"
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
        MSG_APACHECONF="Config Apache"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
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
        MSG_CREDS="Credentials"
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
        MSG_APACHECONF="Apache Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        ;;
esac

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
# STEP 1: System Update
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update"
dnf update -y >> "$LOG" 2>&1
dnf install -y tar curl >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install Apache
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install Apache"
dnf install -y httpd >> "$LOG" 2>&1
systemctl enable --now httpd >> "$LOG" 2>&1
firewall-cmd --permanent --add-service=http >> "$LOG" 2>&1
firewall-cmd --permanent --add-service=https >> "$LOG" 2>&1
firewall-cmd --reload >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install MariaDB
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install MariaDB"
dnf install -y mariadb-server >> "$LOG" 2>&1
systemctl enable --now mariadb >> "$LOG" 2>&1

echo "  Securing MariaDB..." >> "$LOG"
mysql -u root << SQL >> "$LOG" 2>&1
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
echo "${MSG_STEP4}"
log_section "STEP 4: Create WordPress Database"
mysql -u root -p"${WP_DB_ROOT_PASS}" << SQL >> "$LOG" 2>&1
CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${WP_DB_USER}'@'localhost' IDENTIFIED BY '${WP_DB_PASS}';
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

# -----------------------------
# STEP 5: Install PHP 8.3
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Install PHP 8.3"
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

systemctl enable --now php-fpm >> "$LOG" 2>&1

# -----------------------------
# STEP 6: Download WordPress
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Download WordPress"
curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz 2>> "$LOG"
tar -xzf /tmp/wordpress.tar.gz -C /tmp/ >> "$LOG" 2>&1
mkdir -p "$WP_DIR"
cp -r /tmp/wordpress/* "$WP_DIR"/ >> "$LOG" 2>&1
chown -R apache:apache "$WP_DIR" >> "$LOG" 2>&1
chmod -R 755 "$WP_DIR" >> "$LOG" 2>&1
rm -f /tmp/wordpress.tar.gz
echo "  WordPress files placed at: $WP_DIR" >> "$LOG"

# -----------------------------
# STEP 7: Configure WordPress
# -----------------------------
echo "${MSG_STEP7}"
log_section "STEP 7: Configure WordPress"
cp "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"

sed -i "s/database_name_here/${WP_DB_NAME}/" "$WP_DIR/wp-config.php"
sed -i "s/username_here/${WP_DB_USER}/"      "$WP_DIR/wp-config.php"
sed -i "s/password_here/${WP_DB_PASS}/"      "$WP_DIR/wp-config.php"
echo "  Database credentials written to wp-config.php" >> "$LOG"

echo "  Fetching WordPress security keys..." >> "$LOG"
WP_KEYS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/ 2>> "$LOG")
perl -i -0pe "s/define\( 'AUTH_KEY'.*?define\( 'NONCE_SALT'.*?;\n/${WP_KEYS}\n/s" "$WP_DIR/wp-config.php" >> "$LOG" 2>&1 || true
echo "  Security keys injected into wp-config.php" >> "$LOG"

# -----------------------------
# STEP 8: Configure Apache VHost
# -----------------------------
echo "${MSG_STEP8}"
log_section "STEP 8: Configure Apache VHost"
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
echo "  VHost config written to /etc/httpd/conf.d/wordpress.conf" >> "$LOG"

sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/httpd/conf.modules.d/00-base.conf 2>> "$LOG" || true

echo "  Applying SELinux permissions..." >> "$LOG"
setsebool -P httpd_can_network_connect 1 >> "$LOG" 2>&1 || true
setsebool -P httpd_unified 1 >> "$LOG" 2>&1 || true
chcon -Rt httpd_sys_rw_content_t "$WP_DIR" >> "$LOG" 2>&1 || true

systemctl restart httpd >> "$LOG" 2>&1
echo "  Apache restarted successfully" >> "$LOG"

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
log_section "Credentials Saved"
CRED_FILE="/root/wordpress-credentials.txt"
cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}               : http://${SERVER_IP}/wordpress
  ${MSG_WIZARD}            : http://${SERVER_IP}/wordpress/wp-admin/install.php

  ${MSG_DBSECTION}
  ${MSG_DBNAME}            : ${WP_DB_NAME}
  ${MSG_DBUSER}            : ${WP_DB_USER}
  ${MSG_DBPASS}            : ${WP_DB_PASS}
  ${MSG_DBROOTPASS}        : ${WP_DB_ROOT_PASS}
  ${MSG_DBHOST}            : localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}          : ${SERVER_IP}
  ${MSG_WPPATH}            : ${WP_DIR}
  ${MSG_APACHECONF}        : /etc/httpd/conf.d/wordpress.conf
  ${MSG_LOG}               : ${LOG}
  ${MSG_CREDS}             : ${CRED_FILE}

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
echo "  ${MSG_URL}             : http://${SERVER_IP}/wordpress"
echo "  ${MSG_WIZARD}          : http://${SERVER_IP}/wordpress/wp-admin/install.php"
echo ""
echo "  ${MSG_DBNAME}          : ${WP_DB_NAME}"
echo "  ${MSG_DBUSER}          : ${WP_DB_USER}"
echo "  ${MSG_DBPASS}          : ${WP_DB_PASS}"
echo "  ${MSG_DBROOTPASS}      : ${WP_DB_ROOT_PASS}"
echo ""
echo "  ${MSG_WPPATH}          : ${WP_DIR}"
echo "  ${MSG_LOG}             : ${LOG}"
echo "  ${MSG_CREDS}           : ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

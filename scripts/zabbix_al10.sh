#!/bin/bash
set -e

# ============================================================
#  Zabbix Deployment Script — AlmaLinux 10
#  Installs: PostgreSQL, Zabbix Server, Zabbix Frontend,
#            Zabbix Agent, Apache
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
echo "============================================================"
echo "  Zabbix Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação Zabbix — AlmaLinux 10"
        MSG_STEP1="[1/9] A actualizar o sistema..."
        MSG_STEP2="[2/9] A instalar o PostgreSQL..."
        MSG_STEP3="[3/9] A configurar a base de dados Zabbix..."
        MSG_STEP4="[4/9] A adicionar o repositório Zabbix..."
        MSG_STEP5="[5/9] A instalar o Zabbix Server e Frontend..."
        MSG_STEP6="[6/9] A importar o esquema da base de dados..."
        MSG_STEP7="[7/9] A configurar o Zabbix Server..."
        MSG_STEP8="[8/9] A configurar o Apache e o Frontend..."
        MSG_STEP9="[9/9] A iniciar os serviços..."
        MSG_DONE="INSTALAÇÃO DO ZABBIX CONCLUÍDA"
        MSG_NEXTSTEP="Próximo passo: Abra o URL do frontend no seu browser e faça login"
        MSG_CREDTITLE="Instalação Zabbix — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_ZBXSECTION="-- Zabbix --"
        MSG_DBSECTION="-- Base de Dados (PostgreSQL) --"
        MSG_SRVSECTION="-- Servidor --"
        MSG_ZBXURL="URL do Frontend"
        MSG_ZBXUSER="Utilizador Web (padrão)"
        MSG_ZBXPASS="Password Web (padrão)"
        MSG_DBNAME="Nome da BD"
        MSG_DBUSER="Utilizador BD"
        MSG_DBPASS="Password BD"
        MSG_SERVERIP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Credenciais"
        MSG_APACHECONF="Config Apache"
        MSG_ZBXCONF="Config Zabbix Server"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        ;;
    3)
        MSG_TITLE="Installation Zabbix — AlmaLinux 10"
        MSG_STEP1="[1/9] Mise à jour du système..."
        MSG_STEP2="[2/9] Installation de PostgreSQL..."
        MSG_STEP3="[3/9] Configuration de la base de données Zabbix..."
        MSG_STEP4="[4/9] Ajout du dépôt Zabbix..."
        MSG_STEP5="[5/9] Installation de Zabbix Server et Frontend..."
        MSG_STEP6="[6/9] Import du schéma de base de données..."
        MSG_STEP7="[7/9] Configuration de Zabbix Server..."
        MSG_STEP8="[8/9] Configuration d'Apache et du Frontend..."
        MSG_STEP9="[9/9] Démarrage des services..."
        MSG_DONE="INSTALLATION DE ZABBIX TERMINÉE"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL du frontend dans votre navigateur et connectez-vous"
        MSG_CREDTITLE="Installation Zabbix — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_ZBXSECTION="-- Zabbix --"
        MSG_DBSECTION="-- Base de Données (PostgreSQL) --"
        MSG_SRVSECTION="-- Serveur --"
        MSG_ZBXURL="URL du Frontend"
        MSG_ZBXUSER="Utilisateur Web (défaut)"
        MSG_ZBXPASS="Mot de passe Web (défaut)"
        MSG_DBNAME="Nom de la BD"
        MSG_DBUSER="Utilisateur BD"
        MSG_DBPASS="Mot de passe BD"
        MSG_SERVERIP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Identifiants"
        MSG_APACHECONF="Config Apache"
        MSG_ZBXCONF="Config Zabbix Server"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Zabbix Deployment — AlmaLinux 10"
        MSG_STEP1="[1/9] Updating system..."
        MSG_STEP2="[2/9] Installing PostgreSQL..."
        MSG_STEP3="[3/9] Configuring Zabbix database..."
        MSG_STEP4="[4/9] Adding Zabbix repository..."
        MSG_STEP5="[5/9] Installing Zabbix Server and Frontend..."
        MSG_STEP6="[6/9] Importing database schema..."
        MSG_STEP7="[7/9] Configuring Zabbix Server..."
        MSG_STEP8="[8/9] Configuring Apache and Frontend..."
        MSG_STEP9="[9/9] Starting services..."
        MSG_DONE="ZABBIX DEPLOYMENT COMPLETE"
        MSG_NEXTSTEP="Next step: Open the frontend URL in your browser and log in"
        MSG_CREDTITLE="Zabbix Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_ZBXSECTION="-- Zabbix --"
        MSG_DBSECTION="-- Database (PostgreSQL) --"
        MSG_SRVSECTION="-- Server --"
        MSG_ZBXURL="Frontend URL"
        MSG_ZBXUSER="Web User (default)"
        MSG_ZBXPASS="Web Password (default)"
        MSG_DBNAME="DB Name"
        MSG_DBUSER="DB User"
        MSG_DBPASS="DB Password"
        MSG_SERVERIP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials"
        MSG_APACHECONF="Apache Config"
        MSG_ZBXCONF="Zabbix Server Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
ZBX_DB_NAME="zabbix"
ZBX_DB_USER="zabbix"
ZBX_DB_PASS=$(head -c 16 /dev/urandom | base64)
#ZBX_DB_PASS=$(openssl rand -base64 16)
ZBX_VERSION="7.0"                          # Zabbix LTS version
ZBX_REPO_URL="https://repo.zabbix.com/zabbix/${ZBX_VERSION}/alma/10/x86_64/zabbix-release-latest-${ZBX_VERSION}.el10.noarch.rpm"
ZBX_WEB_USER="Admin"
ZBX_WEB_PASS="zabbix"                      # Change after first login!
SERVER_IP=$(hostname -I | awk '{print $1}')
LOG="/var/log/deploy-zabbix.log"

# -----------------------------
# HELPERS
# -----------------------------
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
# STEP 2: Install PostgreSQL
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install PostgreSQL"
dnf install -y postgresql-server postgresql-contrib >> "$LOG" 2>&1
postgresql-setup --initdb >> "$LOG" 2>&1
systemctl enable --now postgresql >> "$LOG" 2>&1
echo "  PostgreSQL initialised and started" >> "$LOG"

# -----------------------------
# STEP 3: Configure Zabbix DB
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Configure Zabbix Database"
sudo -u postgres psql << SQL >> "$LOG" 2>&1
CREATE USER ${ZBX_DB_USER} WITH PASSWORD '${ZBX_DB_PASS}';
CREATE DATABASE ${ZBX_DB_NAME} OWNER ${ZBX_DB_USER} ENCODING 'UTF8' LC_COLLATE='en_US.UTF-8' LC_CTYPE='en_US.UTF-8' TEMPLATE template0;
GRANT ALL PRIVILEGES ON DATABASE ${ZBX_DB_NAME} TO ${ZBX_DB_USER};
SQL
echo "  Database '${ZBX_DB_NAME}' and user '${ZBX_DB_USER}' created" >> "$LOG"

# Allow password auth for the zabbix user in pg_hba.conf
PG_HBA=$(sudo -u postgres psql -t -c "SHOW hba_file;" 2>/dev/null | tr -d ' ')
if ! grep -q "^host.*${ZBX_DB_NAME}.*${ZBX_DB_USER}" "$PG_HBA" 2>/dev/null; then
    echo "host    ${ZBX_DB_NAME}    ${ZBX_DB_USER}    127.0.0.1/32    md5" >> "$PG_HBA"
    echo "host    ${ZBX_DB_NAME}    ${ZBX_DB_USER}    ::1/128         md5" >> "$PG_HBA"
    echo "  pg_hba.conf updated for zabbix user" >> "$LOG"
fi
systemctl reload postgresql >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Add Zabbix Repository
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Add Zabbix Repository"
rpm -Uvh "${ZBX_REPO_URL}" >> "$LOG" 2>&1 || true
dnf clean all >> "$LOG" 2>&1
echo "  Zabbix ${ZBX_VERSION} repository added" >> "$LOG"

# -----------------------------
# STEP 5: Install Zabbix Packages
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Install Zabbix Server, Frontend, Agent"
dnf install -y \
    zabbix-server-pgsql \
    zabbix-web-pgsql \
    zabbix-apache-conf \
    zabbix-sql-scripts \
    zabbix-selinux-policy \
    zabbix-agent >> "$LOG" 2>&1
echo "  Zabbix packages installed" >> "$LOG"

# -----------------------------
# STEP 6: Import DB Schema
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Import Database Schema"
# The schema file is gzipped; pipe directly into psql
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | \
    PGPASSWORD="${ZBX_DB_PASS}" psql -h 127.0.0.1 -U "${ZBX_DB_USER}" "${ZBX_DB_NAME}" >> "$LOG" 2>&1
echo "  Schema imported successfully" >> "$LOG"

# -----------------------------
# STEP 7: Configure Zabbix Server
# -----------------------------
echo "${MSG_STEP7}"
log_section "STEP 7: Configure Zabbix Server"
ZBX_CONF="/etc/zabbix/zabbix_server.conf"

# Set database connection parameters
sed -i "s/^# DBPassword=/DBPassword=${ZBX_DB_PASS}/" "$ZBX_CONF"
sed -i "s/^DBHost=localhost/DBHost=127.0.0.1/"        "$ZBX_CONF"
sed -i "s/^DBName=zabbix/DBName=${ZBX_DB_NAME}/"      "$ZBX_CONF"
sed -i "s/^DBUser=zabbix/DBUser=${ZBX_DB_USER}/"      "$ZBX_CONF"
echo "  zabbix_server.conf updated" >> "$LOG"

# -----------------------------
# STEP 8: Configure Apache & Frontend
# -----------------------------
echo "${MSG_STEP8}"
log_section "STEP 8: Configure Apache and Frontend"
dnf install -y httpd >> "$LOG" 2>&1
systemctl enable --now httpd >> "$LOG" 2>&1

# Set timezone in Zabbix PHP config
ZBX_PHP_CONF="/etc/zabbix/web/zabbix.conf.php"
# If the PHP config doesn't exist yet (first run), the web installer will create it.
# Pre-seed the Apache timezone config instead.
ZBX_APACHE_CONF="/etc/httpd/conf.d/zabbix.conf"
if [ -f "$ZBX_APACHE_CONF" ]; then
    sed -i 's/.*php_value date.timezone.*/        php_value date.timezone Africa\/Luanda/' "$ZBX_APACHE_CONF" 2>/dev/null || true
    echo "  Timezone set in Apache conf" >> "$LOG"
fi

# Firewall rules
firewall-cmd --permanent --add-service=http  >> "$LOG" 2>&1
firewall-cmd --permanent --add-service=https >> "$LOG" 2>&1
firewall-cmd --permanent --add-port=10051/tcp >> "$LOG" 2>&1   # Zabbix trapper
firewall-cmd --reload >> "$LOG" 2>&1
echo "  Firewall rules applied (http, https, 10051/tcp)" >> "$LOG"

# SELinux
setsebool -P httpd_can_network_connect 1 >> "$LOG" 2>&1 || true
setsebool -P zabbix_can_network 1        >> "$LOG" 2>&1 || true
echo "  SELinux booleans set" >> "$LOG"

systemctl restart httpd >> "$LOG" 2>&1

# -----------------------------
# STEP 9: Start Zabbix Services
# -----------------------------
echo "${MSG_STEP9}"
log_section "STEP 9: Start Zabbix Services"
systemctl enable --now zabbix-server zabbix-agent >> "$LOG" 2>&1
systemctl restart zabbix-server zabbix-agent httpd >> "$LOG" 2>&1
echo "  zabbix-server, zabbix-agent and httpd restarted" >> "$LOG"

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
log_section "Credentials Saved"
CRED_FILE="/root/zabbix-credentials.txt"
cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_ZBXSECTION}
  ${MSG_ZBXURL}            : http://${SERVER_IP}/zabbix
  ${MSG_ZBXUSER}           : ${ZBX_WEB_USER}
  ${MSG_ZBXPASS}           : ${ZBX_WEB_PASS}

  ${MSG_DBSECTION}
  ${MSG_DBNAME}            : ${ZBX_DB_NAME}
  ${MSG_DBUSER}            : ${ZBX_DB_USER}
  ${MSG_DBPASS}            : ${ZBX_DB_PASS}

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}          : ${SERVER_IP}
  ${MSG_ZBXCONF}           : /etc/zabbix/zabbix_server.conf
  ${MSG_APACHECONF}        : /etc/httpd/conf.d/zabbix.conf
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
echo "  ${MSG_ZBXURL}          : http://${SERVER_IP}/zabbix"
echo "  ${MSG_ZBXUSER}         : ${ZBX_WEB_USER}"
echo "  ${MSG_ZBXPASS}         : ${ZBX_WEB_PASS}"
echo ""
echo "  ${MSG_DBNAME}          : ${ZBX_DB_NAME}"
echo "  ${MSG_DBUSER}          : ${ZBX_DB_USER}"
echo "  ${MSG_DBPASS}          : ${ZBX_DB_PASS}"
echo ""
echo "  ${MSG_SERVERIP}        : ${SERVER_IP}"
echo "  ${MSG_LOG}             : ${LOG}"
echo "  ${MSG_CREDS}           : ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

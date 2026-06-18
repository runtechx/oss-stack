#!/bin/bash
set -e

# ============================================================
#  Zabbix Deployment Script — AlmaLinux 10
#  Installs: Nginx, PostgreSQL 18, PHP-FPM, Zabbix 7.4
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
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
        MSG_STEP1="[1/4] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/4] A instalar o PostgreSQL 18..."
        MSG_STEP3="[3/4] A instalar o Zabbix 7.4..."
        MSG_STEP4="[4/4] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO ZABBIX CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_WPPATH="Directório Zabbix"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com Admin / zabbix"
        MSG_CREDTITLE="Instalação Zabbix — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_DBSECTION="-- Base de Dados --"
        MSG_SRVSECTION="-- Servidor --"
        MSG_DBNAME="Nome da BD"
        MSG_DBUSER="Utilizador BD"
        MSG_DBPASS="Password BD"
        MSG_DBHOST="Servidor BD"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_ZBXVER="Versão Zabbix"
        MSG_DEFLOGIN="Login padrão"
        MSG_DEFPASS="Password padrão"
        MSG_APACHECONF="Config Nginx"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        ;;
    3)
        MSG_TITLE="Installation Zabbix — AlmaLinux 10"
        MSG_STEP1="[1/4] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/4] Installation de PostgreSQL 18..."
        MSG_STEP3="[3/4] Installation de Zabbix 7.4..."
        MSG_STEP4="[4/4] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE ZABBIX TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_WPPATH="Répertoire Zabbix"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec Admin / zabbix"
        MSG_CREDTITLE="Installation Zabbix — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_DBSECTION="-- Base de Données --"
        MSG_SRVSECTION="-- Serveur --"
        MSG_DBNAME="Nom de la BD"
        MSG_DBUSER="Utilisateur BD"
        MSG_DBPASS="Mot de passe BD"
        MSG_DBHOST="Hôte BD"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_ZBXVER="Version Zabbix"
        MSG_DEFLOGIN="Login par défaut"
        MSG_DEFPASS="Mot de passe par défaut"
        MSG_APACHECONF="Config Nginx"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Zabbix Deployment — AlmaLinux 10"
        MSG_STEP1="[1/4] Updating system and installing prerequisites..."
        MSG_STEP2="[2/4] Installing PostgreSQL 18..."
        MSG_STEP3="[3/4] Installing Zabbix 7.4..."
        MSG_STEP4="[4/4] Configuring firewall..."
        MSG_DONE="ZABBIX DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_WPPATH="Zabbix Path"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with Admin / zabbix"
        MSG_CREDTITLE="Zabbix Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_DBSECTION="-- Database --"
        MSG_SRVSECTION="-- Server --"
        MSG_DBNAME="DB Name"
        MSG_DBUSER="DB User"
        MSG_DBPASS="DB Password"
        MSG_DBHOST="DB Host"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_ZBXVER="Zabbix Version"
        MSG_DEFLOGIN="Default Login"
        MSG_DEFPASS="Default Password"
        MSG_APACHECONF="Nginx Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
PORT=10051
DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-zabbix.log"
CRED_FILE="/root/zabbix-credentials.txt"

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
    dnf install -y wget curl tar policycoreutils-python-utils nginx
    dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-10-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    dnf install -y glibc-all-langpacks
    localectl set-locale LANG=en_US.UTF-8
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install PostgreSQL 18
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install PostgreSQL 18"
{
    dnf install -y postgresql18-server
    /usr/pgsql-18/bin/postgresql-18-setup initdb
    systemctl enable --now postgresql-18
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install Zabbix 7.4
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install Zabbix 7.4"
{
    # Exclude Zabbix packages from EPEL (skip if EPEL repo file not present)
    if [ -f /etc/yum.repos.d/epel.repo ]; then
        if grep -q '^\[epel\]' /etc/yum.repos.d/epel.repo; then
            sed -i '/^\[epel\]/,/^\[/ s/^excludepkgs=.*/excludepkgs=zabbix*/' /etc/yum.repos.d/epel.repo
            grep -q 'excludepkgs=zabbix' /etc/yum.repos.d/epel.repo || \
                sed -i '/^\[epel\]/a excludepkgs=zabbix*' /etc/yum.repos.d/epel.repo
        fi
    else
        echo "  EPEL repo file not found — skipping Zabbix exclusion."
    fi

    # Add Zabbix repository
    rpm -Uvh https://repo.zabbix.com/zabbix/7.4/release/alma/10/noarch/zabbix-release-latest-7.4.el10.noarch.rpm
    dnf clean all

    # Install Zabbix components
    dnf install -y zabbix-server-pgsql zabbix-web-pgsql zabbix-nginx-conf \
        zabbix-sql-scripts zabbix-selinux-policy zabbix-agent

    # Create database and user
    sudo -u postgres psql -c "CREATE USER ${DB_USER} WITH ENCRYPTED PASSWORD '${DB_PASS}';"
    sudo -u postgres createdb -O "${DB_USER}" "${DB_NAME}"
    zcat /usr/share/zabbix/sql-scripts/postgresql/server.sql.gz | sudo -u "${DB_USER}" psql "${DB_NAME}"

    # Test DB connectivity
    PGPASSWORD="${DB_PASS}" psql -U "${DB_USER}" -d "${DB_NAME}" -h localhost -c "\conninfo"

    # Write DB password to Zabbix server config
    sed -i "s|^# DBPassword=.*|DBPassword=${DB_PASS}|" /etc/zabbix/zabbix_server.conf

    # Fix permissions
    chown -R zabbix:zabbix /var/log/zabbix
    chown -R zabbix:zabbix /run/zabbix

    # SELinux contexts
    semanage fcontext -a -t zabbix_log_t "/var/log/zabbix(/.*)?"
    restorecon -Rv /var/log/zabbix
    semanage fcontext -a -t zabbix_var_run_t "/run/zabbix(/.*)?"
    restorecon -Rv /run/zabbix

    # Configure Nginx virtual host
    sed -i \
        -e 's|^[[:space:]]*listen[[:space:]]\+8080;|    listen 80;|' \
        -e "s|^[[:space:]]*server_name[[:space:]]\+[^;]\+;|    server_name ${SERVER_IP} ${ACCESS_URL};|" \
        /etc/nginx/conf.d/zabbix.conf

    setsebool -P httpd_can_network_connect 1
    nginx -t

    # Enable and start services
    systemctl enable --now zabbix-server zabbix-agent nginx php-fpm
    systemctl restart zabbix-server zabbix-agent nginx php-fpm

} >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Configure Firewall
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure Firewall"
{
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --permanent --add-port=${PORT}/tcp
        firewall-cmd --reload
    else
        echo "  firewalld not running — skipping firewall rules."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
log_section "Credentials Saved"
XVERSION=$(rpm -q zabbix-release --qf '%{VERSION}-%{RELEASE}\n' 2>/dev/null || echo "unknown")

cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}:
  http://${ACCESS_URL}
  http://${SERVER_IP}

  ${MSG_DEFLOGIN}:
  Admin
  ${MSG_DEFPASS}:
  zabbix

  ${MSG_DBSECTION}
  ${MSG_DBNAME}:
  ${DB_NAME}
  ${MSG_DBUSER}:
  ${DB_USER}
  ${MSG_DBPASS}:
  ${DB_PASS}
  ${MSG_DBHOST}:
  localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  ${ACCESS_URL}
  ${MSG_ZBXVER}:
  ${XVERSION}
  ${MSG_APACHECONF}:
  /etc/nginx/conf.d/zabbix.conf
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
echo "  http://${ACCESS_URL}"
echo "  http://${SERVER_IP}"
echo ""
echo "  ${MSG_DEFLOGIN}: Admin"
echo "  ${MSG_DEFPASS}: zabbix"
echo ""
echo "  ${MSG_DBNAME}:"
echo "  ${DB_NAME}"
echo "  ${MSG_DBUSER}:"
echo "  ${DB_USER}"
echo "  ${MSG_DBPASS}:"
echo "  ${DB_PASS}"
echo ""
echo "  ${MSG_ZBXVER}:"
echo "  ${XVERSION}"
echo "  ${MSG_LOG}:"
echo "  ${LOG}"
echo "  ${MSG_CREDS}:"
echo "  ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

#!/bin/bash
set -e

# ============================================================
#  Keycloak Deployment Script — AlmaLinux 10
#  Installs: Java 21 (OpenJDK), PostgreSQL, Keycloak (latest)
#  Keycloak runs as a systemd service under a dedicated user
#  Requirements: 2 GB RAM minimum, 4 GB recommended
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  Keycloak Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação Keycloak — AlmaLinux 10"
        MSG_STEP1="[1/5] A instalar pré-requisitos e Java 21..."
        MSG_STEP2="[2/5] A instalar e configurar o PostgreSQL..."
        MSG_STEP3="[3/5] A instalar o Keycloak..."
        MSG_STEP4="[4/5] A configurar o serviço systemd..."
        MSG_STEP5="[5/5] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO KEYCLOAK CONCLUÍDA"
        MSG_URL="URL"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com admin e a password definida"
        MSG_CREDTITLE="Instalação Keycloak — Credenciais"
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
        MSG_DEFLOGIN="Login padrão"
        MSG_ADMINPASS="Password Admin"
        MSG_INSTALLDIR="Directório de instalação"
        MSG_KCVER="Versão Keycloak"
        MSG_KCCONF="Config Keycloak"
        MSG_KCSVC="Serviço systemd"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        ;;
    3)
        MSG_TITLE="Installation Keycloak — AlmaLinux 10"
        MSG_STEP1="[1/5] Installation des prérequis et Java 21..."
        MSG_STEP2="[2/5] Installation et configuration de PostgreSQL..."
        MSG_STEP3="[3/5] Installation de Keycloak..."
        MSG_STEP4="[4/5] Configuration du service systemd..."
        MSG_STEP5="[5/5] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE KEYCLOAK TERMINÉE"
        MSG_URL="URL"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec admin et le mot de passe défini"
        MSG_CREDTITLE="Installation Keycloak — Identifiants"
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
        MSG_DEFLOGIN="Login par défaut"
        MSG_ADMINPASS="Mot de passe Admin"
        MSG_INSTALLDIR="Répertoire d'installation"
        MSG_KCVER="Version Keycloak"
        MSG_KCCONF="Config Keycloak"
        MSG_KCSVC="Service systemd"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Keycloak Deployment — AlmaLinux 10"
        MSG_STEP1="[1/5] Installing prerequisites and Java 21..."
        MSG_STEP2="[2/5] Installing and configuring PostgreSQL..."
        MSG_STEP3="[3/5] Installing Keycloak..."
        MSG_STEP4="[4/5] Configuring systemd service..."
        MSG_STEP5="[5/5] Configuring firewall..."
        MSG_DONE="KEYCLOAK DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with admin and the password you set"
        MSG_CREDTITLE="Keycloak Installation — Credentials"
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
        MSG_DEFLOGIN="Default Login"
        MSG_ADMINPASS="Admin Password"
        MSG_INSTALLDIR="Install Directory"
        MSG_KCVER="Keycloak Version"
        MSG_KCCONF="Keycloak Config"
        MSG_KCSVC="systemd Service"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        ;;
esac

# -----------------------------
# CONFIGURATION — CHANGE ME
# -----------------------------
KC_DB_NAME="keycloak"
KC_DB_USER="keycloak"
KC_DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
KC_PG_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
KC_ADMIN_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
KC_INSTALL_DIR="/opt/keycloak"
KC_PORT=8080
KC_MGMT_PORT=9000
LOG="/var/log/deploy-keycloak.log"
CRED_FILE="/root/keycloak-credentials.txt"

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
# STEP 1: Prerequisites & Java 21
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: Prerequisites & Java 21"
{
    dnf update -y
    dnf install -y curl wget tar unzip java-21-openjdk-headless
    java -version
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install PostgreSQL
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install PostgreSQL"
{
    dnf install -y postgresql-server postgresql
    postgresql-setup --initdb
    systemctl enable --now postgresql

    # Set postgres superuser password while peer auth is still active (socket)
    echo "  Setting postgres superuser password..."
    sudo -u postgres psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD '${KC_PG_ROOT_PASS}';"

    # Replace ALL auth methods (peer + ident) with md5 — covers both
    # local socket lines and host/TCP lines (IPv4 + IPv6)
    echo "  Configuring PostgreSQL for password authentication..."
    sed -i 's/\bpeer\b/md5/g; s/\bident\b/md5/g' /var/lib/pgsql/data/pg_hba.conf
    systemctl restart postgresql

    echo "  Creating Keycloak database and user..."
    PGPASSWORD="${KC_PG_ROOT_PASS}" psql -U postgres -h localhost \
        -c "CREATE USER ${KC_DB_USER} WITH ENCRYPTED PASSWORD '${KC_DB_PASS}';"
    PGPASSWORD="${KC_PG_ROOT_PASS}" psql -U postgres -h localhost \
        -c "CREATE DATABASE ${KC_DB_NAME} OWNER ${KC_DB_USER};"

    # Test connectivity
    PGPASSWORD="${KC_DB_PASS}" psql -U "${KC_DB_USER}" -d "${KC_DB_NAME}" -h localhost -c "\conninfo"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Install Keycloak
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Install Keycloak"
{
    # Detect latest release from GitHub API
    KC_VERSION=$(curl -fsSL https://api.github.com/repos/keycloak/keycloak/releases/latest \
        | grep '"tag_name"' \
        | cut -d '"' -f4)

    if [ -z "$KC_VERSION" ]; then
        echo "  ERROR: Could not detect latest Keycloak version."
        exit 1
    fi
    echo "  Version detected: ${KC_VERSION}"

    # Download and extract
    wget -q -P /tmp \
        "https://github.com/keycloak/keycloak/releases/download/${KC_VERSION}/keycloak-${KC_VERSION}.tar.gz"
    mkdir -p "${KC_INSTALL_DIR}"
    tar -xzf "/tmp/keycloak-${KC_VERSION}.tar.gz" -C "${KC_INSTALL_DIR}" --strip-components=1
    rm -f "/tmp/keycloak-${KC_VERSION}.tar.gz"

    # Create dedicated system user
    id keycloak &>/dev/null || useradd -r -d "${KC_INSTALL_DIR}" -s /sbin/nologin keycloak

    # Write keycloak.conf
    cat > "${KC_INSTALL_DIR}/conf/keycloak.conf" << EOF
# Database
db=postgres
db-username=${KC_DB_USER}
db-password=${KC_DB_PASS}
db-url=jdbc:postgresql://localhost/${KC_DB_NAME}

# HTTP
http-enabled=true
http-port=${KC_PORT}
hostname=${ACCESS_URL}
hostname-strict=false

# Health & Metrics
health-enabled=true
metrics-enabled=true
http-management-port=${KC_MGMT_PORT}

# Proxy
proxy-headers=xforwarded
EOF

    # Build Keycloak with the chosen configuration (required before first start)
    "${KC_INSTALL_DIR}/bin/kc.sh" build

    # Set permissions
    chown -R keycloak:keycloak "${KC_INSTALL_DIR}"
    chmod -R 750 "${KC_INSTALL_DIR}"

    echo "  Keycloak installed at: ${KC_INSTALL_DIR}"
    echo "  Version: ${KC_VERSION}"
} >> "$LOG" 2>&1

# Capture version outside the log block for use in credentials
KC_VERSION=$(curl -fsSL https://api.github.com/repos/keycloak/keycloak/releases/latest \
    | grep '"tag_name"' | cut -d '"' -f4 2>/dev/null || echo "unknown")

# -----------------------------
# STEP 4: Configure systemd Service
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure systemd Service"
{
    cat > /etc/systemd/system/keycloak.service << EOF
[Unit]
Description=Keycloak Identity and Access Management
After=network.target postgresql.service

[Service]
Type=exec
User=keycloak
Group=keycloak
WorkingDirectory=${KC_INSTALL_DIR}
Environment=KEYCLOAK_ADMIN=admin
Environment=KEYCLOAK_ADMIN_PASSWORD=${KC_ADMIN_PASS}
ExecStart=${KC_INSTALL_DIR}/bin/kc.sh start --optimized
ExecStop=${KC_INSTALL_DIR}/bin/kc.sh stop
Restart=on-failure
RestartSec=10
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable --now keycloak

    # Wait for Keycloak to become healthy (up to 2 minutes)
    echo "  Waiting for Keycloak to start..."
    for i in $(seq 1 24); do
        if curl -sf "http://localhost:${KC_MGMT_PORT}/health/ready" > /dev/null 2>&1; then
            echo "  Keycloak is ready."
            break
        fi
        sleep 5
    done
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Configure Firewall
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Configure Firewall"
{
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-port=${KC_PORT}/tcp
        firewall-cmd --permanent --add-port=${KC_MGMT_PORT}/tcp
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

  ${MSG_URL}:
  http://${ACCESS_URL}:${KC_PORT}
  http://${SERVER_IP}:${KC_PORT}

  ${MSG_DEFLOGIN}:
  admin
  ${MSG_ADMINPASS}:
  ${KC_ADMIN_PASS}

  ${MSG_DBSECTION}
  ${MSG_DBNAME}:
  ${KC_DB_NAME}
  ${MSG_DBUSER}:
  ${KC_DB_USER}
  ${MSG_DBPASS}:
  ${KC_DB_PASS}
  ${MSG_DBROOTPASS}:
  ${KC_PG_ROOT_PASS}
  ${MSG_DBHOST}:
  localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  ${ACCESS_URL}
  ${MSG_KCVER}:
  ${KC_VERSION}
  ${MSG_INSTALLDIR}:
  ${KC_INSTALL_DIR}
  ${MSG_KCCONF}:
  ${KC_INSTALL_DIR}/conf/keycloak.conf
  ${MSG_KCSVC}:
  /etc/systemd/system/keycloak.service
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
echo "  http://${ACCESS_URL}:${KC_PORT}"
echo "  http://${SERVER_IP}:${KC_PORT}"
echo ""
echo "  ${MSG_DEFLOGIN}: admin"
echo "  ${MSG_ADMINPASS}: ${KC_ADMIN_PASS}"
echo ""
echo "  ${MSG_DBNAME}:"
echo "  ${KC_DB_NAME}"
echo "  ${MSG_DBUSER}:"
echo "  ${KC_DB_USER}"
echo "  ${MSG_DBPASS}:"
echo "  ${KC_DB_PASS}"
echo "  ${MSG_DBROOTPASS}:"
echo "  ${KC_PG_ROOT_PASS}"
echo ""
echo "  ${MSG_KCVER}:"
echo "  ${KC_VERSION}"
echo "  ${MSG_INSTALLDIR}:"
echo "  ${KC_INSTALL_DIR}"
echo "  ${MSG_KCCONF}:"
echo "  ${KC_INSTALL_DIR}/conf/keycloak.conf"
echo "  ${MSG_KCSVC}:"
echo "  /etc/systemd/system/keycloak.service"
echo "  ${MSG_LOG}:"
echo "  ${LOG}"
echo "  ${MSG_CREDS}:"
echo "  ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

#!/bin/bash
set -e

# ============================================================
#  NetBox Deployment Script — AlmaLinux 10
#  Installs: NetBox + PostgreSQL + Valkey (Redis-compatible) + Nginx reverse proxy
#  Access via HTTPS (self-signed cert) on port 443
#
#  Usage: sudo bash netbox_al10.sh
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  NetBox Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação NetBox — AlmaLinux 10"
        MSG_STEP1="[1/9] A actualizar o sistema e instalar pré-requisitos..."
        MSG_STEP2="[2/9] A instalar e configurar o PostgreSQL..."
        MSG_STEP3="[3/9] A instalar e configurar o Valkey (Redis-compatible)..."
        MSG_STEP4="[4/9] A criar utilizador de sistema e directórios..."
        MSG_STEP5="[5/9] A descarregar o NetBox do GitHub..."
        MSG_STEP6="[6/9] A criar ambiente virtual Python e instalar dependências..."
        MSG_STEP7="[7/9] A criar configuração do NetBox..."
        MSG_STEP8="[8/9] A inicializar base de dados e criar super-utilizador..."
        MSG_STEP9="[9/9] A configurar Gunicorn, Nginx e serviços systemd..."
        MSG_DONE="INSTALAÇÃO DO NETBOX CONCLUÍDA"
        MSG_URL="URL de Acesso"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão"
        MSG_CREDTITLE="Instalação NetBox — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_SRVSECTION="-- Servidor --"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_ADMINUSER="Utilizador Admin"
        MSG_ADMINPASS="Password Admin"
        MSG_DBPASS="Password Base de Dados"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_DOMAIN="Domínio / FQDN (ex: netbox.empresa.local)"
        MSG_SELFSIGNED="A gerar certificado SSL auto-assinado (válido 10 anos)..."
        MSG_SELFSIGNED_WARN="Certificado auto-assinado. Aceite a excepção no browser. Use Let's Encrypt para produção."
        MSG_HOSTS_NOTE="Noutras máquinas da rede, adicione ao ficheiro hosts:"
        MSG_CHECKSTATUS="A verificar estado dos serviços..."
        MSG_RUNNING="activo"
        MSG_NOTRUNNING="NÃO está activo"
        MSG_USEFUL_CMDS="Comandos úteis"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        ;;
    3)
        MSG_TITLE="Installation NetBox — AlmaLinux 10"
        MSG_STEP1="[1/9] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/9] Installation et configuration de PostgreSQL..."
        MSG_STEP3="[3/9] Installation et configuration de Valkey (Redis-compatible)..."
        MSG_STEP4="[4/9] Création de l'utilisateur système et des répertoires..."
        MSG_STEP5="[5/9] Téléchargement de NetBox depuis GitHub..."
        MSG_STEP6="[6/9] Création de l'environnement Python et installation des dépendances..."
        MSG_STEP7="[7/9] Création de la configuration NetBox..."
        MSG_STEP8="[8/9] Initialisation de la base de données et création du super-utilisateur..."
        MSG_STEP9="[9/9] Configuration de Gunicorn, Nginx et services systemd..."
        MSG_DONE="INSTALLATION DE NETBOX TERMINÉE"
        MSG_URL="URL d'accès"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous"
        MSG_CREDTITLE="Installation NetBox — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_SRVSECTION="-- Serveur --"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_ADMINUSER="Utilisateur Admin"
        MSG_ADMINPASS="Mot de passe Admin"
        MSG_DBPASS="Mot de passe Base de données"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_DOMAIN="Domaine / FQDN (ex: netbox.entreprise.local)"
        MSG_SELFSIGNED="Génération d'un certificat SSL auto-signé (valable 10 ans)..."
        MSG_SELFSIGNED_WARN="Certificat auto-signé. Acceptez l'exception dans le navigateur. Utilisez Let's Encrypt en production."
        MSG_HOSTS_NOTE="Sur les autres machines du réseau, ajoutez au fichier hosts :"
        MSG_CHECKSTATUS="Vérification de l'état des services..."
        MSG_RUNNING="actif"
        MSG_NOTRUNNING="N'est PAS actif"
        MSG_USEFUL_CMDS="Commandes utiles"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        ;;
    *)
        MSG_TITLE="NetBox Deployment — AlmaLinux 10"
        MSG_STEP1="[1/9] Updating system and installing prerequisites..."
        MSG_STEP2="[2/9] Installing and configuring PostgreSQL..."
        MSG_STEP3="[3/9] Installing and configuring Valkey (Redis-compatible)..."
        MSG_STEP4="[4/9] Creating system user and directories..."
        MSG_STEP5="[5/9] Downloading NetBox from GitHub..."
        MSG_STEP6="[6/9] Creating Python virtual environment and installing dependencies..."
        MSG_STEP7="[7/9] Creating NetBox configuration..."
        MSG_STEP8="[8/9] Initialising database and creating superuser..."
        MSG_STEP9="[9/9] Configuring Gunicorn, Nginx and systemd services..."
        MSG_DONE="NETBOX DEPLOYMENT COMPLETE"
        MSG_URL="Access URL"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in"
        MSG_CREDTITLE="NetBox Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_SRVSECTION="-- Server --"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_ADMINUSER="Admin User"
        MSG_ADMINPASS="Admin Password"
        MSG_DBPASS="Database Password"
        MSG_NGINXCONF="Nginx Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_DOMAIN="Domain / FQDN (e.g. netbox.company.local)"
        MSG_SELFSIGNED="Generating self-signed SSL certificate (valid 10 years)..."
        MSG_SELFSIGNED_WARN="Self-signed certificate. Accept the browser exception. Use Let's Encrypt for production."
        MSG_HOSTS_NOTE="On other machines on the network, add to their hosts file:"
        MSG_CHECKSTATUS="Checking service status..."
        MSG_RUNNING="running"
        MSG_NOTRUNNING="NOT running"
        MSG_USEFUL_CMDS="Useful commands"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        ;;
esac

# -----------------------------
# CONFIGURATION
# -----------------------------
NETBOX_VERSION="v4.2.0"          # pin to a stable release; update as needed
NETBOX_INSTALL_DIR="/opt/netbox"
NETBOX_VENV_DIR="${NETBOX_INSTALL_DIR}/venv"
NETBOX_DB_NAME="netbox"
NETBOX_DB_USER="netbox"
LOG="/var/log/deploy-netbox.log"
CRED_FILE="/root/netbox-credentials.txt"

log_section() {
    echo ""                                                    >> "$LOG"
    echo "============================================================" >> "$LOG"
    echo "  $1"                                               >> "$LOG"
    echo "============================================================" >> "$LOG"
}

# -----------------------------
# ROOT CHECK
# -----------------------------
if [[ $EUID -ne 0 ]]; then
    echo "  ERROR: This script must be run as root (sudo)."
    exit 1
fi

# Generate random credentials using /dev/urandom — no dependencies needed
NETBOX_DB_PASS="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)"
NETBOX_SECRET_KEY="$(tr -dc 'A-Za-z0-9!@#^&*_+-' </dev/urandom | head -c 50)"

# -----------------------------
# -----------------------------
# AUTO-GENERATED CREDENTIALS
# -----------------------------
ADMIN_USER="admin"
ADMIN_EMAIL="admin@localhost"
ADMIN_PASS="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 16)"

echo ""
echo "============================================================"
echo "  ${MSG_TITLE}"
echo "============================================================"
echo ""
echo "  ${MSG_WARN_TIME}"
echo ""

read -rp "  ${MSG_PROMPT_IP} ($(hostname -I | awk '{print $1}')): " SERVER_IP
SERVER_IP=${SERVER_IP:-$(hostname -I | awk '{print $1}')}

read -rp "  ${MSG_PROMPT_DOMAIN} ($(hostname -f 2>/dev/null || echo netbox.local)): " NB_DOMAIN
NB_DOMAIN=${NB_DOMAIN:-$(hostname -f 2>/dev/null || echo netbox.local)}

echo ""
echo "  ${MSG_SERVERIP}: ${SERVER_IP}"   | tee -a "$LOG"
echo "  ${MSG_ACCESSURL}: https://${NB_DOMAIN}" | tee -a "$LOG"
echo ""


# -----------------------------
# STEP 1: System update + prerequisites
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update & Prerequisites"
{
    dnf update -y
    dnf groupinstall -y "Development Tools"
    dnf install -y \
        curl wget git \
        openssl openssl-devel \
        python3 python3-pip python3-devel \
        libffi-devel \
        libpq-devel \
        nginx \
        policycoreutils-python-utils
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: PostgreSQL
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: PostgreSQL"
{
    dnf install -y postgresql postgresql-server

    if [[ ! -f /var/lib/pgsql/data/PG_VERSION ]]; then
        postgresql-setup --initdb
    fi

    # AlmaLinux 10 / PostgreSQL 16 uses scram-sha-256 by default.
    # Temporarily set all local connections to trust so we can run psql
    # as the postgres OS user without a password, create the netbox role,
    # then restore scram-sha-256 for all connections.
    PG_HBA="/var/lib/pgsql/data/pg_hba.conf"
    cp "${PG_HBA}" "${PG_HBA}.bak"

    # Set ALL local/loopback entries to trust (handles peer, ident, scram-sha-256)
    sed -i -E 's/^(local[[:space:]]+all[[:space:]]+all[[:space:]]+)[^[:space:]]+$/\1trust/' "${PG_HBA}" 
    sed -i -E 's/^(host[[:space:]]+all[[:space:]]+all[[:space:]]+127\.0\.0\.1\/32[[:space:]]+)[^[:space:]]+$/\1trust/' "${PG_HBA}" 
    sed -i -E 's/^(host[[:space:]]+all[[:space:]]+all[[:space:]]+::1\/128[[:space:]]+)[^[:space:]]+$/\1trust/' "${PG_HBA}" 

    systemctl enable postgresql --now
    systemctl restart postgresql

    # Create DB user and database (trust auth active — no password needed)
    sudo -u postgres psql <<PSQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '${NETBOX_DB_USER}') THEN
    CREATE USER ${NETBOX_DB_USER} WITH PASSWORD '${NETBOX_DB_PASS}';
  END IF;
END
\$\$;
SELECT 'CREATE DATABASE ${NETBOX_DB_NAME} OWNER ${NETBOX_DB_USER}'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${NETBOX_DB_NAME}')\gexec
GRANT ALL PRIVILEGES ON DATABASE ${NETBOX_DB_NAME} TO ${NETBOX_DB_USER};
PSQL

    # PostgreSQL 15+ requires explicit schema grant
    sudo -u postgres psql -d "${NETBOX_DB_NAME}" \
        -c "GRANT ALL ON SCHEMA public TO ${NETBOX_DB_USER};" 2>/dev/null || true

    # Restore secure auth — scram-sha-256 for all local connections
    sed -i -E 's/^(local[[:space:]]+all[[:space:]]+all[[:space:]]+)trust$/\1scram-sha-256/' "${PG_HBA}" 
    sed -i -E 's/^(host[[:space:]]+all[[:space:]]+all[[:space:]]+127\.0\.0\.1\/32[[:space:]]+)trust$/\1scram-sha-256/' "${PG_HBA}" 
    sed -i -E 's/^(host[[:space:]]+all[[:space:]]+all[[:space:]]+::1\/128[[:space:]]+)trust$/\1scram-sha-256/' "${PG_HBA}" 

    systemctl restart postgresql
    echo "  PostgreSQL configured."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Valkey (Redis-compatible, replaces Redis on AlmaLinux 10)
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Valkey (Redis-compatible)"
{
    dnf install -y valkey

    # Valkey listens on 127.0.0.1 by default on AlmaLinux 10 — no extra config needed
    systemctl enable valkey --now
    echo "  Valkey configured (listening on 127.0.0.1:6379)."

} >> "$LOG" 2>&1
# -----------------------------
# STEP 4: NetBox system user + directories
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: System User & Directories"
{
    # Create system user without --create-home so git clone can create the dir cleanly
    id netbox &>/dev/null || \
        useradd --system --shell /bin/bash \
                --home-dir "${NETBOX_INSTALL_DIR}" \
                --no-create-home netbox

    mkdir -p "${NETBOX_INSTALL_DIR}"/{media,reports,scripts}
    chown -R netbox:netbox "${NETBOX_INSTALL_DIR}"
    chmod 750 "${NETBOX_INSTALL_DIR}"
    echo "  User and directories ready."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Clone NetBox
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: Clone NetBox"
{
    if [[ -d "${NETBOX_INSTALL_DIR}/.git" ]]; then
        # Already cloned — just pull latest
        sudo -u netbox git -C "${NETBOX_INSTALL_DIR}" pull
        echo "  Repository updated."
    else
        # Remove any leftover empty dir (from useradd or a failed run)
        rm -rf "${NETBOX_INSTALL_DIR}"
        # Clone as root into /opt — netbox user has no write access to /opt itself
        git clone -b "${NETBOX_VERSION}" \
            https://github.com/netbox-community/netbox.git \
            "${NETBOX_INSTALL_DIR}"
        # Create extra subdirs and hand ownership to netbox
        mkdir -p "${NETBOX_INSTALL_DIR}"/{media,reports,scripts}
        chown -R netbox:netbox "${NETBOX_INSTALL_DIR}"
        chmod 750 "${NETBOX_INSTALL_DIR}"
        echo "  Repository cloned."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# STEP 6: Python venv + dependencies
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Python venv & dependencies"
{
    sudo -u netbox python3 -m venv "${NETBOX_VENV_DIR}"
    sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install --upgrade pip wheel setuptools
    sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install \
        "psycopg[c]" \
        -r "${NETBOX_INSTALL_DIR}/requirements.txt"
    sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install gunicorn
    echo "  Python dependencies installed."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 7: NetBox configuration
# -----------------------------
echo "${MSG_STEP7}"
log_section "STEP 7: NetBox Configuration"
{
    NETBOX_CONF="${NETBOX_INSTALL_DIR}/netbox/netbox/configuration.py"

    # Write configuration.py directly as a heredoc — no fragile regex needed
    cat > "${NETBOX_CONF}" << NBCONF
###############################################################
#  NetBox configuration — generated by install script
###############################################################

ALLOWED_HOSTS = ['${NB_DOMAIN}', '${SERVER_IP}', 'localhost', '127.0.0.1']

DATABASE = {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': '${NETBOX_DB_NAME}',
    'USER': '${NETBOX_DB_USER}',
    'PASSWORD': '${NETBOX_DB_PASS}',
    'HOST': 'localhost',
    'PORT': '',
    'CONN_MAX_AGE': 300,
}

REDIS = {
    'tasks': {
        'HOST': 'localhost',
        'PORT': 6379,
        'PASSWORD': '',
        'DATABASE': 0,
        'SSL': False,
    },
    'caching': {
        'HOST': 'localhost',
        'PORT': 6379,
        'PASSWORD': '',
        'DATABASE': 1,
        'SSL': False,
    },
}

SECRET_KEY = '${NETBOX_SECRET_KEY}'

# Media / static
MEDIA_ROOT   = '${NETBOX_INSTALL_DIR}/media'
REPORTS_ROOT = '${NETBOX_INSTALL_DIR}/reports'
SCRIPTS_ROOT = '${NETBOX_INSTALL_DIR}/scripts'

# Plugins (none by default)
PLUGINS = []
NBCONF

    chown netbox:netbox "${NETBOX_CONF}"
    chmod 640 "${NETBOX_CONF}"
    echo "  configuration.py written."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 8: DB migration + static files + superuser
# -----------------------------
echo "${MSG_STEP8}"
log_section "STEP 8: Database Migration & Superuser"
{
    MANAGE="${NETBOX_VENV_DIR}/bin/python3 ${NETBOX_INSTALL_DIR}/netbox/manage.py"

    sudo -u netbox ${MANAGE} migrate
    sudo -u netbox ${MANAGE} collectstatic --no-input
    sudo -u netbox ${MANAGE} remove_stale_contenttypes --no-input 2>/dev/null || true

    sudo -u netbox ${MANAGE} shell <<PYEOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='${ADMIN_USER}').exists():
    User.objects.create_superuser('${ADMIN_USER}', '${ADMIN_EMAIL}', '${ADMIN_PASS}')
    print("  Superuser created: ${ADMIN_USER}")
else:
    print("  Superuser already exists.")
PYEOF

    echo "  Database ready."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 9: Gunicorn + Nginx + systemd + SSL
# -----------------------------
echo "${MSG_STEP9}"
log_section "STEP 9: Gunicorn / Nginx / systemd / SSL"
{
    # --- Gunicorn config ---
    mkdir -p /etc/netbox
    cat > /etc/netbox/gunicorn.py << 'GCFG'
bind          = "127.0.0.1:8001"
workers       = 5
threads       = 3
timeout       = 120
max_requests  = 5000
max_requests_jitter = 500
GCFG

    # --- netbox.service ---
    cat > /etc/systemd/system/netbox.service << SVCEOF
[Unit]
Description=NetBox WSGI Service
Documentation=https://docs.netbox.dev/
After=network-online.target postgresql.service valkey.service
Wants=network-online.target

[Service]
User=netbox
Group=netbox
WorkingDirectory=${NETBOX_INSTALL_DIR}/netbox
Environment=PYTHONPATH=${NETBOX_INSTALL_DIR}/netbox
ExecStart=${NETBOX_VENV_DIR}/bin/gunicorn \
    --pid /var/tmp/netbox.pid \
    --pythonpath ${NETBOX_INSTALL_DIR}/netbox \
    -c /etc/netbox/gunicorn.py \
    netbox.wsgi
Restart=on-failure
RestartSec=10
PrivateTmp=true
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
SVCEOF

    # --- netbox-rq.service ---
    cat > /etc/systemd/system/netbox-rq.service << RQEOF
[Unit]
Description=NetBox Request Queue Worker
Documentation=https://docs.netbox.dev/
After=network-online.target netbox.service
Wants=network-online.target

[Service]
User=netbox
Group=netbox
WorkingDirectory=${NETBOX_INSTALL_DIR}/netbox
Environment=PYTHONPATH=${NETBOX_INSTALL_DIR}/netbox
ExecStart=${NETBOX_VENV_DIR}/bin/python3 \
    ${NETBOX_INSTALL_DIR}/netbox/manage.py rqworker
Restart=on-failure
RestartSec=10
PrivateTmp=true
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
RQEOF

    # --- Self-signed SSL certificate ---
    echo "  ${MSG_SELFSIGNED}"
    SSL_DIR="/etc/nginx/ssl/netbox"
    mkdir -p "${SSL_DIR}"
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -keyout "${SSL_DIR}/netbox.key" \
        -out    "${SSL_DIR}/netbox.crt" \
        -subj "/C=PT/ST=Local/L=Local/O=NetBox/CN=${NB_DOMAIN}" \
        -addext "subjectAltName=DNS:${NB_DOMAIN},IP:${SERVER_IP}" 2>/dev/null
    chmod 600 "${SSL_DIR}/netbox.key"
    chmod 644 "${SSL_DIR}/netbox.crt"

    # --- Nginx config ---
    rm -f /etc/nginx/conf.d/default.conf
    cat > /etc/nginx/conf.d/netbox.conf << NGINXEOF
# Redirect HTTP -> HTTPS
server {
    listen 80;
    server_name ${NB_DOMAIN} ${SERVER_IP};
    return 301 https://\$host\$request_uri;
}

# NetBox HTTPS reverse proxy
server {
    listen 443 ssl;
    http2  on;
    server_name ${NB_DOMAIN} ${SERVER_IP};

    ssl_certificate     ${SSL_DIR}/netbox.crt;
    ssl_certificate_key ${SSL_DIR}/netbox.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 1d;

    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Frame-Options            "SAMEORIGIN"      always;
    add_header X-Content-Type-Options     "nosniff"         always;

    client_max_body_size 25m;

    location /static/ {
        alias ${NETBOX_INSTALL_DIR}/netbox/static/;
    }

    location / {
        proxy_pass         http://127.0.0.1:8001;
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
        proxy_read_timeout 120;
        proxy_connect_timeout 120;
        proxy_send_timeout 120;
    }
}
NGINXEOF

    # --- SELinux ---
    setsebool -P httpd_can_network_connect 1 2>/dev/null || true
    setsebool -P httpd_execmem 1             2>/dev/null || true
    semanage fcontext -a -t httpd_exec_t \
        "${NETBOX_VENV_DIR}/bin/python3" 2>/dev/null || true
    restorecon -Rv "${NETBOX_INSTALL_DIR}" 2>/dev/null || true

    # --- Firewall ---
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-service=http
        firewall-cmd --permanent --add-service=https
        firewall-cmd --reload
    fi
    # --- Housekeeping cron ---
    cat > /etc/cron.d/netbox << CRONEOF
# NetBox daily housekeeping
0 0 * * * netbox ${NETBOX_VENV_DIR}/bin/python3 \
    ${NETBOX_INSTALL_DIR}/netbox/manage.py housekeeping
CRONEOF

    echo "  Setup complete."
} >> "$LOG" 2>&1

# --- Enable & start services (outside log redirect so failures are visible) ---
systemctl daemon-reload
systemctl enable netbox netbox-rq nginx >> "$LOG" 2>&1

echo "  A iniciar netbox..."
systemctl start netbox
sleep 5
if ! systemctl is-active --quiet netbox; then
    echo ""
    echo "  !! netbox failed to start — last 30 lines of journal:"
    journalctl -u netbox -n 30 --no-pager
    echo ""
fi

echo "  A iniciar netbox-rq..."
systemctl start netbox-rq
sleep 3
if ! systemctl is-active --quiet netbox-rq; then
    echo ""
    echo "  !! netbox-rq failed to start — last 20 lines of journal:"
    journalctl -u netbox-rq -n 20 --no-pager
    echo ""
fi

systemctl reload nginx >> "$LOG" 2>&1 || systemctl restart nginx >> "$LOG" 2>&1

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
  https://${NB_DOMAIN}
  https://${SERVER_IP}

  ${MSG_ADMINUSER}:  ${ADMIN_USER}
  ${MSG_ADMINPASS}: ${ADMIN_PASS}
  ${MSG_DBPASS}:  ${NETBOX_DB_PASS}

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:  ${SERVER_IP}
  ${MSG_ACCESSURL}: https://${NB_DOMAIN}

  Install Dir:  ${NETBOX_INSTALL_DIR}
  Config File:  ${NETBOX_INSTALL_DIR}/netbox/netbox/configuration.py
  Data Dir:     ${NETBOX_INSTALL_DIR}/netbox
  ${MSG_NGINXCONF}: /etc/nginx/conf.d/netbox.conf
  SSL Cert:     /etc/nginx/ssl/netbox/netbox.crt
  Gunicorn Cfg: /etc/netbox/gunicorn.py

  Systemd Services:
  netbox       — Gunicorn WSGI server
  netbox-rq    — Background task worker
  nginx        — Reverse proxy / SSL termination

  ${MSG_LOG}:   ${LOG}
  ${MSG_CREDS}: ${CRED_FILE}

  ${MSG_USEFUL_CMDS}:
  systemctl status  netbox
  systemctl restart netbox
  systemctl status  netbox-rq
  journalctl -u netbox -f
  journalctl -u netbox-rq -f

  ${MSG_SELFSIGNED_WARN}
  To replace with Let's Encrypt:
  dnf install -y certbot python3-certbot-nginx
  certbot --nginx -d ${NB_DOMAIN}

  ${MSG_HOSTS_NOTE}
  ${SERVER_IP}  ${NB_DOMAIN}

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
echo "  https://${NB_DOMAIN}"
echo "  https://${SERVER_IP}"
echo ""
echo "  ${MSG_ADMINUSER}:  ${ADMIN_USER}"
echo "  ${MSG_ADMINPASS}: ${ADMIN_PASS}"
echo ""
echo "  ${MSG_CHECKSTATUS}"
for svc in netbox netbox-rq nginx; do
    if systemctl is-active --quiet "${svc}"; then
        echo "  ✔ ${svc}: ${MSG_RUNNING}"
    else
        echo "  ✘ ${svc}: ${MSG_NOTRUNNING}"
    fi
done
echo ""
echo "  Install Dir:  ${NETBOX_INSTALL_DIR}"
echo "  ${MSG_LOG}:   ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_SELFSIGNED_WARN}"
echo "  To use Let's Encrypt:"
echo "  dnf install -y certbot python3-certbot-nginx"
echo "  certbot --nginx -d ${NB_DOMAIN}"
echo ""
echo "  ${MSG_HOSTS_NOTE}"
echo "  ${SERVER_IP}  ${NB_DOMAIN}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

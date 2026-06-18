#!/bin/bash
set -e

# ============================================================
#  OpenCloud Deployment Script — AlmaLinux 10
#  Installs: OpenCloud (Go binary) + Nginx reverse proxy
#  No PHP, no database — OpenCloud is fully self-contained
#  Listens internally on port 9200, proxied via Nginx on 443
#
#  IMPORTANT: OpenCloud requires HTTPS and a valid FQDN.
#  Access via IP address will NOT work — always use the domain.
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  OpenCloud Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação OpenCloud — AlmaLinux 10"
        MSG_STEP1="[1/5] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/5] A descarregar e instalar o binário OpenCloud..."
        MSG_STEP3="[3/5] A criar o serviço systemd..."
        MSG_STEP4="[4/5] A configurar o Nginx como proxy reverso..."
        MSG_STEP5="[5/5] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO OPENCLOUD CONCLUÍDA"
        MSG_URL="URL"
        MSG_OCPATH="Directório OpenCloud"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão"
        MSG_CREDTITLE="Instalação OpenCloud — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_SRVSECTION="-- Servidor --"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_ADMINUSER="Utilizador Admin"
        MSG_ADMINPASS="Password Admin"
        MSG_OCVER="Versão OpenCloud"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_DOMAIN="Domínio / FQDN (ex: cloud.empresa.local)"
        MSG_PROMPT_ADMINPASS="Password admin do OpenCloud"
        MSG_WARN_DOMAIN="ATENÇÃO: Use sempre o FQDN para aceder — o IP não funciona com OpenCloud."
        MSG_SELFSIGNED="A gerar certificado auto-assinado (válido 10 anos)..."
        MSG_SELFSIGNED_WARN="Certificado auto-assinado. Aceite a excepção no browser. Use Let's Encrypt para produção."
        MSG_HOSTS_NOTE="Noutras máquinas da rede, adicione ao ficheiro hosts:"
        ;;
    3)
        MSG_TITLE="Installation OpenCloud — AlmaLinux 10"
        MSG_STEP1="[1/5] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/5] Téléchargement et installation du binaire OpenCloud..."
        MSG_STEP3="[3/5] Création du service systemd..."
        MSG_STEP4="[4/5] Configuration de Nginx en tant que proxy inverse..."
        MSG_STEP5="[5/5] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION D'OPENCLOUD TERMINÉE"
        MSG_URL="URL"
        MSG_OCPATH="Répertoire OpenCloud"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous"
        MSG_CREDTITLE="Installation OpenCloud — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_SRVSECTION="-- Serveur --"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_ADMINUSER="Utilisateur Admin"
        MSG_ADMINPASS="Mot de passe Admin"
        MSG_OCVER="Version OpenCloud"
        MSG_NGINXCONF="Config Nginx"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_DOMAIN="Domaine / FQDN (ex: cloud.entreprise.local)"
        MSG_PROMPT_ADMINPASS="Mot de passe admin OpenCloud"
        MSG_WARN_DOMAIN="ATTENTION : Utilisez toujours le FQDN — l'accès par IP ne fonctionne pas avec OpenCloud."
        MSG_SELFSIGNED="Génération d'un certificat auto-signé (valable 10 ans)..."
        MSG_SELFSIGNED_WARN="Certificat auto-signé. Acceptez l'exception dans le navigateur. Utilisez Let's Encrypt en production."
        MSG_HOSTS_NOTE="Sur les autres machines du réseau, ajoutez au fichier hosts :"
        ;;
    *)
        MSG_TITLE="OpenCloud Deployment — AlmaLinux 10"
        MSG_STEP1="[1/5] Updating system and installing prerequisites..."
        MSG_STEP2="[2/5] Downloading and installing OpenCloud binary..."
        MSG_STEP3="[3/5] Creating systemd service..."
        MSG_STEP4="[4/5] Configuring Nginx as reverse proxy..."
        MSG_STEP5="[5/5] Configuring firewall..."
        MSG_DONE="OPENCLOUD DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_OCPATH="OpenCloud Path"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in"
        MSG_CREDTITLE="OpenCloud Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_SRVSECTION="-- Server --"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_ADMINUSER="Admin User"
        MSG_ADMINPASS="Admin Password"
        MSG_OCVER="OpenCloud Version"
        MSG_NGINXCONF="Nginx Config"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_DOMAIN="Domain / FQDN (e.g. cloud.company.local)"
        MSG_PROMPT_ADMINPASS="OpenCloud admin password"
        MSG_WARN_DOMAIN="WARNING: Always use the FQDN to access OpenCloud — IP access will NOT work."
        MSG_SELFSIGNED="Generating self-signed certificate (valid 10 years)..."
        MSG_SELFSIGNED_WARN="Self-signed certificate. Accept the browser exception. Use Let's Encrypt for production."
        MSG_HOSTS_NOTE="On other machines on the network, add to their hosts file:"
        ;;
esac

# -----------------------------
# CONFIGURATION
# -----------------------------
OC_VERSION="6.1.0"
OC_BIN_URL="https://github.com/opencloud-eu/opencloud/releases/download/v${OC_VERSION}/opencloud-${OC_VERSION}-linux-amd64"
OC_BIN_DIR="/opt/opencloud"
OC_DATA_DIR="/var/lib/opencloud/data"
OC_CONFIG_DIR="/var/lib/opencloud/config"
OC_USER="opencloud"
LOG="/var/log/deploy-opencloud.log"
CRED_FILE="/root/opencloud-credentials.txt"

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
echo "  !! ${MSG_WARN_DOMAIN} !!"
echo ""

read -rp "  ${MSG_PROMPT_IP} ($(hostname -I | awk '{print $1}')): " SERVER_IP
SERVER_IP=${SERVER_IP:-$(hostname -I | awk '{print $1}')}

read -rp "  ${MSG_PROMPT_DOMAIN} ($(hostname -f)): " OC_DOMAIN
OC_DOMAIN=${OC_DOMAIN:-$(hostname -f)}

read -rsp "  ${MSG_PROMPT_ADMINPASS}: " OC_ADMIN_PASS
echo ""
if [[ -z "$OC_ADMIN_PASS" ]]; then
    OC_ADMIN_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
    echo "  (generated admin password)"
fi

echo "  ${MSG_SERVERIP}: ${SERVER_IP}" | tee -a "$LOG"
echo "  ${MSG_ACCESSURL}: https://${OC_DOMAIN}" | tee -a "$LOG"
echo ""

# -----------------------------
# STEP 1: Prerequisites
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update & Prerequisites"
{
    dnf update -y
    dnf install -y wget curl tar nginx openssl policycoreutils-python-utils
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Download & initialise OpenCloud
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Download OpenCloud ${OC_VERSION}"
{
    useradd --system --no-create-home --shell /usr/sbin/nologin "${OC_USER}" 2>/dev/null || true

    mkdir -p "${OC_BIN_DIR}"
    mkdir -p "${OC_DATA_DIR}"
    mkdir -p "${OC_CONFIG_DIR}"
    chown -R "${OC_USER}:${OC_USER}" /var/lib/opencloud
    chmod 700 /var/lib/opencloud

    wget -q "${OC_BIN_URL}" -O "${OC_BIN_DIR}/opencloud"
    chmod +x "${OC_BIN_DIR}/opencloud"
    echo "  Binary downloaded to ${OC_BIN_DIR}/opencloud"

    # Runtime environment:
    # PROXY_TLS=false   — TLS is terminated at Nginx, not inside OpenCloud
    # OC_INSECURE=true  — allows internal OIDC calls through the self-signed cert
    cat > "${OC_CONFIG_DIR}/opencloud.env" << OCENV
OC_CONFIG_DIR=${OC_CONFIG_DIR}
OC_BASE_DATA_PATH=${OC_DATA_DIR}
OC_URL=https://${OC_DOMAIN}
PROXY_HTTP_ADDR=0.0.0.0:9200
PROXY_TLS=false
OC_INSECURE=true
PROXY_LOG_LEVEL=warn
OCENV

    # Initialise OpenCloud — generates opencloud.yaml and all secrets
    sudo -u "${OC_USER}" env \
        OC_CONFIG_DIR="${OC_CONFIG_DIR}" \
        OC_BASE_DATA_PATH="${OC_DATA_DIR}" \
        OC_URL="https://${OC_DOMAIN}" \
        OC_INSECURE=true \
        "${OC_BIN_DIR}/opencloud" init --insecure true --admin-password "${OC_ADMIN_PASS}"

    # Patch generated yaml — it defaults insecure: false and overrides the env var
    OCYAML="${OC_CONFIG_DIR}/opencloud.yaml"
    if [[ -f "${OCYAML}" ]]; then
        sed -i 's/insecure: false/insecure: true/g' "${OCYAML}"
        echo "  Patched insecure: true in opencloud.yaml"
    fi

    echo "  OpenCloud initialised."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: systemd service
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Create systemd service"
{
    cat > /etc/systemd/system/opencloud.service << 'SVCEOF'
[Unit]
Description=OpenCloud Service
After=network.target

[Service]
Type=simple
User=opencloud
Group=opencloud
WorkingDirectory=/opt/opencloud
EnvironmentFile=/var/lib/opencloud/config/opencloud.env
ExecStart=/opt/opencloud/opencloud server
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
SVCEOF

    systemctl daemon-reload
    systemctl enable --now opencloud.service

    echo "  Waiting 12 seconds for OpenCloud to fully start..."
    sleep 12
    systemctl is-active --quiet opencloud.service && \
        echo "  opencloud.service is running." || \
        echo "  WARNING: opencloud.service may not have started. Check: journalctl -u opencloud"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Nginx reverse proxy + self-signed TLS + OIDC loopback fix
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure Nginx reverse proxy"
{
    SSL_DIR="/etc/nginx/ssl/opencloud"
    mkdir -p "${SSL_DIR}"

    echo "  ${MSG_SELFSIGNED}"
    openssl req -x509 -nodes -days 3650 -newkey rsa:4096 \
        -keyout "${SSL_DIR}/opencloud.key" \
        -out    "${SSL_DIR}/opencloud.crt" \
        -subj "/C=PT/ST=Local/L=Local/O=OpenCloud/CN=${OC_DOMAIN}" \
        -addext "subjectAltName=DNS:${OC_DOMAIN},IP:${SERVER_IP}" 2>/dev/null

    chmod 600 "${SSL_DIR}/opencloud.key"
    chmod 644 "${SSL_DIR}/opencloud.crt"

    # Note: server_name is the FQDN only — IP access intentionally excluded
    # because OpenCloud's OIDC issuer is bound to OC_URL (the FQDN) and
    # will return a blank page if accessed via IP.
    cat > /etc/nginx/conf.d/opencloud.conf << NGINXEOF
# Redirect HTTP -> HTTPS
server {
    listen 80;
    server_name ${OC_DOMAIN};
    return 301 https://\$host\$request_uri;
}

# OpenCloud reverse proxy
server {
    listen 443 ssl;
    http2  on;
    server_name ${OC_DOMAIN};

    ssl_certificate     ${SSL_DIR}/opencloud.crt;
    ssl_certificate_key ${SSL_DIR}/opencloud.key;
    ssl_protocols       TLSv1.2 TLSv1.3;
    ssl_ciphers         HIGH:!aNULL:!MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 1d;

    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Frame-Options            "SAMEORIGIN"    always;
    add_header X-Content-Type-Options     "nosniff"       always;
    add_header Referrer-Policy            "no-referrer"   always;

    # No upload size limit
    client_max_body_size 0;

    # Disable buffering — required for SSE (server-sent events)
    proxy_buffering         off;
    proxy_request_buffering off;

    # Long timeouts for large file syncs
    proxy_read_timeout 3600s;
    proxy_send_timeout 3600s;
    keepalive_requests 100000;
    keepalive_timeout  5m;

    # Do not retry other upstreams — breaks SSE streams
    proxy_next_upstream off;

    location / {
        proxy_pass         http://127.0.0.1:9200;
        proxy_http_version 1.1;
        proxy_set_header   Host              \$host;
        proxy_set_header   X-Real-IP         \$remote_addr;
        proxy_set_header   X-Forwarded-For   \$proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto \$scheme;
        # WebSocket support — required by the OpenCloud web UI
        proxy_set_header   Upgrade           \$http_upgrade;
        proxy_set_header   Connection        "upgrade";
    }
}
NGINXEOF

    # SELinux: allow nginx to reach upstream on port 9200
    setsebool -P httpd_can_network_connect 1

    nginx -t
    systemctl enable --now nginx
    systemctl reload nginx

    # -----------------------------------------------------------------
    # OIDC loopback fix
    # OpenCloud's embedded identity provider must be able to call back
    # to its own public URL (https://OC_DOMAIN) to validate OIDC tokens.
    # Without this entry the login page loads but stays permanently blank
    # after the authentication redirect, because the internal request
    # cannot route back through Nginx using the public domain.
    # -----------------------------------------------------------------
    if ! grep -q "${OC_DOMAIN}" /etc/hosts; then
        echo "127.0.0.1 ${OC_DOMAIN}" >> /etc/hosts
        echo "  OIDC loopback fix applied: 127.0.0.1 ${OC_DOMAIN} added to /etc/hosts"
    else
        echo "  OIDC loopback entry already present in /etc/hosts — skipping."
    fi

    # Restart so OpenCloud picks up the now-reachable OIDC endpoint
    systemctl restart opencloud.service
    sleep 8
    echo "  OpenCloud restarted with OIDC loopback active."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: Firewall
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

  ${MSG_URL}:
  https://${OC_DOMAIN}

  !! ${MSG_WARN_DOMAIN} !!

  ${MSG_ADMINUSER}:
  admin
  ${MSG_ADMINPASS}:
  ${OC_ADMIN_PASS}

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  https://${OC_DOMAIN}
  ${MSG_OCVER}:
  ${OC_VERSION}
  Binary:
  ${OC_BIN_DIR}/opencloud
  Config Dir:
  ${OC_CONFIG_DIR}
  Data Dir:
  ${OC_DATA_DIR}
  ${MSG_NGINXCONF}:
  /etc/nginx/conf.d/opencloud.conf
  SSL Certificate:
  /etc/nginx/ssl/opencloud/opencloud.crt
  Systemd Service:
  /etc/systemd/system/opencloud.service
  ${MSG_LOG}:
  ${LOG}
  ${MSG_CREDS}:
  ${CRED_FILE}

  Service logs:
  journalctl -u opencloud -f

  ${MSG_SELFSIGNED_WARN}
  To replace with Let's Encrypt:
  dnf install -y certbot python3-certbot-nginx
  certbot --nginx -d ${OC_DOMAIN}

  ${MSG_HOSTS_NOTE}
  ${SERVER_IP}  ${OC_DOMAIN}

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
echo "  https://${OC_DOMAIN}"
echo ""
echo "  !! ${MSG_WARN_DOMAIN} !!"
echo ""
echo "  ${MSG_ADMINUSER}: admin"
echo "  ${MSG_ADMINPASS}: ${OC_ADMIN_PASS}"
echo ""
echo "  ${MSG_OCVER}: ${OC_VERSION}"
echo "  Binary:      ${OC_BIN_DIR}/opencloud"
echo "  Config Dir:  ${OC_CONFIG_DIR}"
echo "  Data Dir:    ${OC_DATA_DIR}"
echo ""
echo "  Service logs:"
echo "  journalctl -u opencloud -f"
echo ""
echo "  ${MSG_LOG}:   ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_SELFSIGNED_WARN}"
echo "  To use Let's Encrypt:"
echo "  dnf install -y certbot python3-certbot-nginx"
echo "  certbot --nginx -d ${OC_DOMAIN}"
echo ""
echo "  ${MSG_HOSTS_NOTE}"
echo "  ${SERVER_IP}  ${OC_DOMAIN}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

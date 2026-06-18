#!/bin/bash
set -e

# ============================================================
#  FreeIPA Server Deployment Script — AlmaLinux 10
#  Installs: FreeIPA Server + DNS (AppStream — no extra repo)
#  Components: 389-DS, Kerberos KDC, Dogtag CA, BIND DNS,
#              Apache httpd, Chrony NTP
#  Requirements: FQDN hostname set, 2 GB RAM minimum
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  FreeIPA Server Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação FreeIPA Server — AlmaLinux 10"
        MSG_STEP1="[1/5] A preparar o sistema (hostname, hosts, chrony)..."
        MSG_STEP2="[2/5] A instalar os pacotes FreeIPA..."
        MSG_STEP3="[3/5] A executar o instalador FreeIPA..."
        MSG_STEP4="[4/5] A verificar os serviços..."
        MSG_STEP5="[5/5] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO FREEIPA CONCLUÍDA"
        MSG_URL="URL"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com admin e a password definida"
        MSG_CREDTITLE="Instalação FreeIPA — Credenciais"
        MSG_GENERATED="Gerado em"
        MSG_SRVSECTION="-- Servidor --"
        MSG_IPASECTION="-- FreeIPA --"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_HOSTNAME="Hostname (FQDN)"
        MSG_DOMAIN="Domínio"
        MSG_REALM="Realm Kerberos"
        MSG_DEFLOGIN="Login padrão"
        MSG_ADMINPASS="Password Admin IPA"
        MSG_DMPASS="Password Directory Manager"
        MSG_IPACONF="Config FreeIPA"
        MSG_IPALOG="Log de instalação IPA"
        MSG_IPAVER="Versão FreeIPA"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_FQDN="Hostname FQDN (ex: ipa.empresa.local)"
        MSG_PROMPT_DOMAIN="Domínio (ex: empresa.local)"
        MSG_PROMPT_REALM="Realm Kerberos (ex: EMPRESA.LOCAL)"
        MSG_PROMPT_ADMINPASS="Password do administrador IPA (mín. 8 caracteres)"
        MSG_PROMPT_DMPASS="Password do Directory Manager (mín. 8 caracteres)"
        MSG_WARN_REQS="ATENÇÃO: O FreeIPA requer um FQDN válido configurado antes da instalação."
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        MSG_ERR_PASS="ERRO: A password deve ter pelo menos 8 caracteres."
        ;;
    3)
        MSG_TITLE="Installation FreeIPA Server — AlmaLinux 10"
        MSG_STEP1="[1/5] Préparation du système (hostname, hosts, chrony)..."
        MSG_STEP2="[2/5] Installation des paquets FreeIPA..."
        MSG_STEP3="[3/5] Exécution de l'installateur FreeIPA..."
        MSG_STEP4="[4/5] Vérification des services..."
        MSG_STEP5="[5/5] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE FREEIPA TERMINÉE"
        MSG_URL="URL"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec admin et le mot de passe défini"
        MSG_CREDTITLE="Installation FreeIPA — Identifiants"
        MSG_GENERATED="Généré le"
        MSG_SRVSECTION="-- Serveur --"
        MSG_IPASECTION="-- FreeIPA --"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_HOSTNAME="Hostname (FQDN)"
        MSG_DOMAIN="Domaine"
        MSG_REALM="Realm Kerberos"
        MSG_DEFLOGIN="Login par défaut"
        MSG_ADMINPASS="Mot de passe Admin IPA"
        MSG_DMPASS="Mot de passe Directory Manager"
        MSG_IPACONF="Config FreeIPA"
        MSG_IPALOG="Journal d'installation IPA"
        MSG_IPAVER="Version FreeIPA"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_FQDN="Hostname FQDN (ex: ipa.entreprise.local)"
        MSG_PROMPT_DOMAIN="Domaine (ex: entreprise.local)"
        MSG_PROMPT_REALM="Realm Kerberos (ex: ENTREPRISE.LOCAL)"
        MSG_PROMPT_ADMINPASS="Mot de passe administrateur IPA (min. 8 caractères)"
        MSG_PROMPT_DMPASS="Mot de passe Directory Manager (min. 8 caractères)"
        MSG_WARN_REQS="ATTENTION : FreeIPA nécessite un FQDN valide configuré avant l'installation."
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        MSG_ERR_PASS="ERREUR : Le mot de passe doit contenir au moins 8 caractères."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="FreeIPA Server Deployment — AlmaLinux 10"
        MSG_STEP1="[1/5] Preparing system (hostname, hosts, chrony)..."
        MSG_STEP2="[2/5] Installing FreeIPA packages..."
        MSG_STEP3="[3/5] Running FreeIPA installer..."
        MSG_STEP4="[4/5] Verifying services..."
        MSG_STEP5="[5/5] Configuring firewall..."
        MSG_DONE="FREEIPA DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with admin and the password you set"
        MSG_CREDTITLE="FreeIPA Installation — Credentials"
        MSG_GENERATED="Generated"
        MSG_SRVSECTION="-- Server --"
        MSG_IPASECTION="-- FreeIPA --"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_HOSTNAME="Hostname (FQDN)"
        MSG_DOMAIN="Domain"
        MSG_REALM="Kerberos Realm"
        MSG_DEFLOGIN="Default Login"
        MSG_ADMINPASS="IPA Admin Password"
        MSG_DMPASS="Directory Manager Password"
        MSG_IPACONF="FreeIPA Config"
        MSG_IPALOG="IPA Install Log"
        MSG_IPAVER="FreeIPA Version"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_FQDN="FQDN hostname (e.g. ipa.company.local)"
        MSG_PROMPT_DOMAIN="Domain name (e.g. company.local)"
        MSG_PROMPT_REALM="Kerberos realm (e.g. COMPANY.LOCAL)"
        MSG_PROMPT_ADMINPASS="IPA admin password (min. 8 characters)"
        MSG_PROMPT_DMPASS="Directory Manager password (min. 8 characters)"
        MSG_WARN_REQS="WARNING: FreeIPA requires a valid FQDN hostname configured before installation."
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        MSG_ERR_PASS="ERROR: Password must be at least 8 characters."
        ;;
esac

# -----------------------------
# CONFIGURATION
# -----------------------------
LOG="/var/log/deploy-freeipa.log"
CRED_FILE="/root/freeipa-credentials.txt"

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
echo "  ${MSG_WARN_REQS}"
echo "  ${MSG_WARN_TIME}"
log_section "${MSG_TITLE} — $(date)"

# -----------------------------
# USER PROMPTS
# -----------------------------
echo ""

read -rp "  ${MSG_PROMPT_IP} ($(hostname -I | awk '{print $1}')): " SERVER_IP
SERVER_IP=${SERVER_IP:-$(hostname -I | awk '{print $1}')}

read -rp "  ${MSG_PROMPT_FQDN} ($(hostname -f)): " IPA_FQDN
IPA_FQDN=${IPA_FQDN:-$(hostname -f)}

# Derive domain and realm defaults from the FQDN
DEFAULT_DOMAIN=$(echo "$IPA_FQDN" | cut -d'.' -f2-)
DEFAULT_REALM=$(echo "$DEFAULT_DOMAIN" | tr '[:lower:]' '[:upper:]')

read -rp "  ${MSG_PROMPT_DOMAIN} (${DEFAULT_DOMAIN}): " IPA_DOMAIN
IPA_DOMAIN=${IPA_DOMAIN:-${DEFAULT_DOMAIN}}

read -rp "  ${MSG_PROMPT_REALM} (${DEFAULT_REALM}): " IPA_REALM
IPA_REALM=${IPA_REALM:-${DEFAULT_REALM}}

# Admin password (with length validation)
while true; do
    read -rsp "  ${MSG_PROMPT_ADMINPASS}: " IPA_ADMIN_PASS
    echo ""
    if [ ${#IPA_ADMIN_PASS} -ge 8 ]; then break; fi
    echo "  ${MSG_ERR_PASS}"
done

# Directory Manager password (with length validation)
while true; do
    read -rsp "  ${MSG_PROMPT_DMPASS}: " IPA_DM_PASS
    echo ""
    if [ ${#IPA_DM_PASS} -ge 8 ]; then break; fi
    echo "  ${MSG_ERR_PASS}"
done

echo ""
echo "  ${MSG_SERVERIP}: ${SERVER_IP}"  | tee -a "$LOG"
echo "  ${MSG_HOSTNAME}: ${IPA_FQDN}"   | tee -a "$LOG"
echo "  ${MSG_DOMAIN}: ${IPA_DOMAIN}"   | tee -a "$LOG"
echo "  ${MSG_REALM}: ${IPA_REALM}"     | tee -a "$LOG"
echo ""

# -----------------------------
# STEP 1: Prepare System
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: Prepare System"
{
    dnf update -y
    dnf install -y chrony

    # Set hostname
    hostnamectl set-hostname "${IPA_FQDN}"

    # Ensure /etc/hosts has the server entry
    sed -i "/^${SERVER_IP}/d" /etc/hosts
    echo "${SERVER_IP}  ${IPA_FQDN}  $(echo "${IPA_FQDN}" | cut -d'.' -f1)" >> /etc/hosts
    echo "  /etc/hosts updated: ${SERVER_IP} -> ${IPA_FQDN}"

    # Enable and sync NTP
    systemctl enable --now chronyd
    chronyc makestep || true
    echo "  NTP synchronised"
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install FreeIPA Packages
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install FreeIPA Packages"
{
    # All packages available in AlmaLinux 10 AppStream — no extra repo needed
    dnf install -y \
        freeipa-server \
        freeipa-server-dns \
        freeipa-client
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Run FreeIPA Installer
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Run FreeIPA Installer"
{
    ipa-server-install \
        --hostname="${IPA_FQDN}" \
        --domain="${IPA_DOMAIN}" \
        --realm="${IPA_REALM}" \
        --ds-password="${IPA_DM_PASS}" \
        --admin-password="${IPA_ADMIN_PASS}" \
        --setup-dns \
        --auto-forwarders \
        --no-dnssec-validation \
        --unattended
} >> "$LOG" 2>&1

# -----------------------------
# STEP 4: Verify Services
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Verify Services"
{
    ipactl status
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
        firewall-cmd --permanent --add-service=dns
        firewall-cmd --permanent --add-service=ntp
        firewall-cmd --permanent --add-service=freeipa-ldap
        firewall-cmd --permanent --add-service=freeipa-ldaps
        firewall-cmd --permanent --add-service=kerberos
        firewall-cmd --permanent --add-service=kpasswd
        firewall-cmd --reload
    else
        echo "  firewalld not running — skipping firewall rules."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# SAVE CREDENTIALS TO FILE
# -----------------------------
log_section "Credentials Saved"
IPA_VERSION=$(ipa --version 2>/dev/null | grep VERSION | awk '{print $2}' | tr -d ',' || echo "unknown")

cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}:
  https://${IPA_FQDN}/ipa/ui
  https://${SERVER_IP}/ipa/ui

  ${MSG_DEFLOGIN}:
  admin
  ${MSG_ADMINPASS}:
  ${IPA_ADMIN_PASS}

  ${MSG_IPASECTION}
  ${MSG_DOMAIN}:
  ${IPA_DOMAIN}
  ${MSG_REALM}:
  ${IPA_REALM}
  ${MSG_HOSTNAME}:
  ${IPA_FQDN}
  ${MSG_DMPASS}:
  ${IPA_DM_PASS}
  ${MSG_IPAVER}:
  ${IPA_VERSION}

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:
  ${SERVER_IP}
  ${MSG_ACCESSURL}:
  https://${IPA_FQDN}/ipa/ui
  ${MSG_IPACONF}:
  /etc/ipa/default.conf
  ${MSG_IPALOG}:
  /var/log/ipaserver-install.log
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
echo "  https://${IPA_FQDN}/ipa/ui"
echo "  https://${SERVER_IP}/ipa/ui"
echo ""
echo "  ${MSG_DEFLOGIN}: admin"
echo "  ${MSG_ADMINPASS}: ${IPA_ADMIN_PASS}"
echo ""
echo "  ${MSG_DOMAIN}: ${IPA_DOMAIN}"
echo "  ${MSG_REALM}: ${IPA_REALM}"
echo "  ${MSG_HOSTNAME}: ${IPA_FQDN}"
echo ""
echo "  ${MSG_DMPASS}:"
echo "  ${IPA_DM_PASS}"
echo "  ${MSG_IPAVER}:"
echo "  ${IPA_VERSION}"
echo "  ${MSG_IPACONF}:"
echo "  /etc/ipa/default.conf"
echo "  ${MSG_IPALOG}:"
echo "  /var/log/ipaserver-install.log"
echo "  ${MSG_LOG}:"
echo "  ${LOG}"
echo "  ${MSG_CREDS}:"
echo "  ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

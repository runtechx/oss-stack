#!/bin/bash
set -e

# ============================================================
#  Wazuh Deployment Script — AlmaLinux 10
#  Mode A — Server:  Wazuh Indexer + Manager + Dashboard
#  Mode B — Agent:   Wazuh Agent only (points to a Manager)
#
#  Supports: AlmaLinux 10 (x86_64 / aarch64)
#  Requires: root / sudo, internet access to packages.wazuh.com
#
#  Server minimum requirements:
#    4 CPU cores · 8 GB RAM · 50 GB free disk
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  Wazuh Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação Wazuh — AlmaLinux 10"
        MSG_MODE_PROMPT="Seleccione o modo de instalação"
        MSG_MODE_SERVER="Servidor completo (Indexer + Manager + Dashboard)"
        MSG_MODE_AGENT="Agente apenas (liga a um Manager existente)"
        MSG_MODE_INVALID="Opção inválida. Por favor escolha 1 ou 2."
        MSG_PROMPT_MANAGERIP="Endereço IP do Wazuh Manager"
        MSG_PROMPT_AGENTNAME="Nome do agente (deixe em branco para usar o hostname)"
        MSG_PROMPT_AGENTGROUP="Grupo do agente (deixe em branco para 'default')"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        MSG_WARN_RES="ATENÇÃO: O hardware pode não cumprir os requisitos mínimos para o servidor."
        MSG_STEP1="[1/5] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/5] A configurar o repositório Wazuh..."
        MSG_STEP3="[3/5] A instalar os componentes Wazuh..."
        MSG_STEP4="[4/5] A configurar o firewall..."
        MSG_STEP5="[5/5] A activar e iniciar os serviços..."
        MSG_STEP1_AGENT="[1/3] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2_AGENT="[2/3] A configurar o repositório e instalar o agente..."
        MSG_STEP3_AGENT="[3/3] A activar e iniciar o serviço do agente..."
        MSG_DONE_SERVER="INSTALAÇÃO DO SERVIDOR WAZUH CONCLUÍDA"
        MSG_DONE_AGENT="INSTALAÇÃO DO AGENTE WAZUH CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP_SERVER="Próximo passo: Abra o URL no seu browser e inicie sessão com admin / <ver abaixo>"
        MSG_NEXTSTEP_AGENT="Próximo passo: Confirme que o agente aparece no dashboard do Manager"
        MSG_CREDTITLE_SERVER="Instalação Wazuh Servidor — Credenciais"
        MSG_CREDTITLE_AGENT="Instalação Wazuh Agente — Informação"
        MSG_GENERATED="Gerado em"
        MSG_SRVSECTION="-- Servidor --"
        MSG_AGENTSECTION="-- Agente --"
        MSG_SERVERIP="IP do Servidor"
        MSG_ACCESSURL="URL de Acesso"
        MSG_WAZUHVER="Versão Wazuh"
        MSG_MANAGERIP="IP do Manager"
        MSG_AGENTNAME="Nome do Agente"
        MSG_AGENTGROUP="Grupo do Agente"
        MSG_AGENTCONFIG="Configuração do Agente"
        MSG_AGENTLOG="Log do Agente"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_DISABLEREPO="Repositório Wazuh desactivado (evita actualizações acidentais)."
        MSG_CHECKSTATUS="A verificar estado dos serviços..."
        MSG_RUNNING="a correr"
        MSG_NOTRUNNING="NÃO está a correr"
        MSG_CREDENTIALS_EXTRACT="A extrair credenciais do ficheiro de instalação..."
        MSG_CREDENTIALS_CHECK="Verifique o ficheiro de credenciais para a password do admin."
        MSG_USEFUL_CMDS="Comandos úteis"
        ;;
    3)
        MSG_TITLE="Installation Wazuh — AlmaLinux 10"
        MSG_MODE_PROMPT="Sélectionnez le mode d'installation"
        MSG_MODE_SERVER="Serveur complet (Indexer + Manager + Dashboard)"
        MSG_MODE_AGENT="Agent uniquement (se connecte à un Manager existant)"
        MSG_MODE_INVALID="Option invalide. Veuillez choisir 1 ou 2."
        MSG_PROMPT_MANAGERIP="Adresse IP du Wazuh Manager"
        MSG_PROMPT_AGENTNAME="Nom de l'agent (laisser vide pour utiliser le hostname)"
        MSG_PROMPT_AGENTGROUP="Groupe de l'agent (laisser vide pour 'default')"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        MSG_WARN_RES="ATTENTION : Le matériel peut ne pas satisfaire les exigences minimales pour le serveur."
        MSG_STEP1="[1/5] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/5] Configuration du dépôt Wazuh..."
        MSG_STEP3="[3/5] Installation des composants Wazuh..."
        MSG_STEP4="[4/5] Configuration du pare-feu..."
        MSG_STEP5="[5/5] Activation et démarrage des services..."
        MSG_STEP1_AGENT="[1/3] Mise à jour du système et installation des prérequis..."
        MSG_STEP2_AGENT="[2/3] Configuration du dépôt et installation de l'agent..."
        MSG_STEP3_AGENT="[3/3] Activation et démarrage du service agent..."
        MSG_DONE_SERVER="INSTALLATION DU SERVEUR WAZUH TERMINÉE"
        MSG_DONE_AGENT="INSTALLATION DE L'AGENT WAZUH TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP_SERVER="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec admin / <voir ci-dessous>"
        MSG_NEXTSTEP_AGENT="Prochaine étape : Confirmez que l'agent apparaît dans le dashboard du Manager"
        MSG_CREDTITLE_SERVER="Installation Wazuh Serveur — Identifiants"
        MSG_CREDTITLE_AGENT="Installation Wazuh Agent — Informations"
        MSG_GENERATED="Généré le"
        MSG_SRVSECTION="-- Serveur --"
        MSG_AGENTSECTION="-- Agent --"
        MSG_SERVERIP="IP Serveur"
        MSG_ACCESSURL="URL d'accès"
        MSG_WAZUHVER="Version Wazuh"
        MSG_MANAGERIP="IP du Manager"
        MSG_AGENTNAME="Nom de l'Agent"
        MSG_AGENTGROUP="Groupe de l'Agent"
        MSG_AGENTCONFIG="Configuration de l'Agent"
        MSG_AGENTLOG="Log de l'Agent"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_DISABLEREPO="Dépôt Wazuh désactivé (évite les mises à jour accidentelles)."
        MSG_CHECKSTATUS="Vérification de l'état des services..."
        MSG_RUNNING="en cours d'exécution"
        MSG_NOTRUNNING="N'est PAS en cours d'exécution"
        MSG_CREDENTIALS_EXTRACT="Extraction des identifiants depuis le fichier d'installation..."
        MSG_CREDENTIALS_CHECK="Consultez le fichier d'identifiants pour le mot de passe admin."
        MSG_USEFUL_CMDS="Commandes utiles"
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Wazuh Deployment — AlmaLinux 10"
        MSG_MODE_PROMPT="Select installation mode"
        MSG_MODE_SERVER="Full server (Indexer + Manager + Dashboard)"
        MSG_MODE_AGENT="Agent only (connects to an existing Manager)"
        MSG_MODE_INVALID="Invalid option. Please choose 1 or 2."
        MSG_PROMPT_MANAGERIP="Wazuh Manager IP address"
        MSG_PROMPT_AGENTNAME="Agent name (leave blank to use hostname)"
        MSG_PROMPT_AGENTGROUP="Agent group (leave blank for 'default')"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        MSG_WARN_RES="WARNING: Hardware may not meet the minimum server requirements."
        MSG_STEP1="[1/5] Updating system and installing prerequisites..."
        MSG_STEP2="[2/5] Configuring the Wazuh repository..."
        MSG_STEP3="[3/5] Installing Wazuh components..."
        MSG_STEP4="[4/5] Configuring firewall..."
        MSG_STEP5="[5/5] Enabling and starting services..."
        MSG_STEP1_AGENT="[1/3] Updating system and installing prerequisites..."
        MSG_STEP2_AGENT="[2/3] Configuring repository and installing agent..."
        MSG_STEP3_AGENT="[3/3] Enabling and starting agent service..."
        MSG_DONE_SERVER="WAZUH SERVER DEPLOYMENT COMPLETE"
        MSG_DONE_AGENT="WAZUH AGENT DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP_SERVER="Next step: Open the URL in your browser and log in with admin / <see below>"
        MSG_NEXTSTEP_AGENT="Next step: Confirm the agent appears in the Manager dashboard"
        MSG_CREDTITLE_SERVER="Wazuh Server Installation — Credentials"
        MSG_CREDTITLE_AGENT="Wazuh Agent Installation — Information"
        MSG_GENERATED="Generated"
        MSG_SRVSECTION="-- Server --"
        MSG_AGENTSECTION="-- Agent --"
        MSG_SERVERIP="Server IP"
        MSG_ACCESSURL="Access URL"
        MSG_WAZUHVER="Wazuh Version"
        MSG_MANAGERIP="Manager IP"
        MSG_AGENTNAME="Agent Name"
        MSG_AGENTGROUP="Agent Group"
        MSG_AGENTCONFIG="Agent Config"
        MSG_AGENTLOG="Agent Log"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_DISABLEREPO="Wazuh repository disabled (prevents accidental upgrades)."
        MSG_CHECKSTATUS="Checking service status..."
        MSG_RUNNING="running"
        MSG_NOTRUNNING="NOT running"
        MSG_CREDENTIALS_EXTRACT="Extracting credentials from installation archive..."
        MSG_CREDENTIALS_CHECK="Check the credentials file for the admin password."
        MSG_USEFUL_CMDS="Useful commands"
        ;;
esac

# -----------------------------
# MODE SELECTION
# -----------------------------
echo ""
echo "============================================================"
echo "  ${MSG_TITLE}"
echo "============================================================"
echo ""
echo "  ${MSG_MODE_PROMPT}:"
echo ""
echo "  1) ${MSG_MODE_SERVER}"
echo "  2) ${MSG_MODE_AGENT}"
echo ""

INSTALL_MODE=""
while [[ -z "$INSTALL_MODE" ]]; do
    read -rp "  > " MODE_CHOICE
    case "$MODE_CHOICE" in
        1) INSTALL_MODE="server" ;;
        2) INSTALL_MODE="agent"  ;;
        *) echo "  ${MSG_MODE_INVALID}" ;;
    esac
done

# -----------------------------
# CONFIGURATION
# -----------------------------
WAZUH_VERSION="4.14"
WAZUH_REPO_URL="https://packages.wazuh.com/4.x/yum/"
WAZUH_GPG_KEY="https://packages.wazuh.com/key/GPG-KEY-WAZUH"
WAZUH_INSTALL_SCRIPT="https://packages.wazuh.com/${WAZUH_VERSION}/wazuh-install.sh"
LOG="/var/log/deploy-wazuh.log"

# Helper: log a section header to the log file
log_section() {
    echo ""                                              >> "$LOG"
    echo "============================================================" >> "$LOG"
    echo "  $1"                                         >> "$LOG"
    echo "============================================================" >> "$LOG"
}

echo ""
echo "  ${MSG_WARN_TIME}"
log_section "${MSG_TITLE} [${INSTALL_MODE^^}] — $(date)"

# ============================================================
# ██████╗  ██████╗  ██████╗ ████████╗    —    SERVER MODE
# ╚════██╗██╔═══██╗██╔═══██╗╚══██╔══╝
#  █████╔╝██║   ██║██║   ██║   ██║
# ██╔═══╝ ██║   ██║██║   ██║   ██║
# ███████╗╚██████╔╝╚██████╔╝   ██║
# ╚══════╝ ╚═════╝  ╚═════╝    ╚═╝
# ============================================================
if [[ "$INSTALL_MODE" == "server" ]]; then

    CRED_FILE="/root/wazuh-credentials.txt"

    # -----------------------------
    # USER PROMPTS — SERVER
    # -----------------------------
    echo ""
    read -rp "  ${MSG_PROMPT_IP} ($(hostname -I | awk '{print $1}')): " SERVER_IP
    SERVER_IP=${SERVER_IP:-$(hostname -I | awk '{print $1}')}

    read -rp "  ${MSG_PROMPT_URL} ($(hostname -f)): " ACCESS_URL
    ACCESS_URL=${ACCESS_URL:-$(hostname -f)}

    echo "  ${MSG_SERVERIP}: ${SERVER_IP}" | tee -a "$LOG"
    echo "  ${MSG_ACCESSURL}: ${ACCESS_URL}" | tee -a "$LOG"
    echo ""

    # Hardware check (warn only, do not abort)
    CPU_CORES=$(nproc)
    TOTAL_RAM_MB=$(awk '/MemTotal/ {printf "%d", $2/1024}' /proc/meminfo)
    DISK_FREE_GB=$(df / --output=avail -BG | tail -1 | tr -d 'G ')
    if [[ "$CPU_CORES" -lt 4 || "$TOTAL_RAM_MB" -lt 7500 || "$DISK_FREE_GB" -lt 50 ]]; then
        echo ""
        echo "  !! ${MSG_WARN_RES} !!"
        echo "     CPU: ${CPU_CORES} cores  |  RAM: ${TOTAL_RAM_MB} MB  |  Disk: ${DISK_FREE_GB} GB free"
        echo ""
    fi

    # -----------------------------
    # STEP 1: Prerequisites
    # -----------------------------
    echo ""
    echo "${MSG_STEP1}"
    log_section "STEP 1: System Update & Prerequisites"
    {
        dnf update -y
        dnf install -y curl wget tar coreutils initscripts
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 2: Download installer
    # -----------------------------
    echo "${MSG_STEP2}"
    log_section "STEP 2: Download Wazuh Install Script"
    {
        cd /tmp
        curl -sO "${WAZUH_INSTALL_SCRIPT}"
        chmod +x /tmp/wazuh-install.sh
        echo "  Script downloaded: /tmp/wazuh-install.sh"
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 3: Run all-in-one installer
    # -----------------------------
    echo "${MSG_STEP3}"
    log_section "STEP 3: Wazuh All-in-One Installation"
    {
        # -a  all-in-one (Indexer + Manager + Dashboard on this host)
        # -i  ignore hardware/OS check (AlmaLinux 10 may not be in the
        #     official list yet — packages still install correctly)
        bash /tmp/wazuh-install.sh -a -i
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 4: Firewall
    # -----------------------------
    echo "${MSG_STEP4}"
    log_section "STEP 4: Configure Firewall"
    {
        if systemctl is-active --quiet firewalld; then
            firewall-cmd --permanent --add-port=443/tcp    # Dashboard (HTTPS)
            firewall-cmd --permanent --add-port=55000/tcp  # Manager API
            firewall-cmd --permanent --add-port=1514/tcp   # Agent events (TCP)
            firewall-cmd --permanent --add-port=1514/udp   # Agent events (UDP)
            firewall-cmd --permanent --add-port=1515/tcp   # Agent enrolment
            firewall-cmd --permanent --add-port=9200/tcp   # Indexer REST API
            firewall-cmd --reload
            echo "  Ports opened: 443, 55000, 1514 (tcp/udp), 1515, 9200"
        else
            echo "  firewalld not running — skipping firewall rules."
        fi
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 5: Services check
    # -----------------------------
    echo "${MSG_STEP5}"
    log_section "STEP 5: Services Check"
    {
        for svc in wazuh-indexer wazuh-manager wazuh-dashboard; do
            if systemctl is-active --quiet "${svc}"; then
                echo "  ${svc}: ${MSG_RUNNING}"
            else
                echo "  ${svc}: ${MSG_NOTRUNNING}"
            fi
        done

        # Disable the Wazuh repo to prevent unintentional upgrades
        if [[ -f /etc/yum.repos.d/wazuh.repo ]]; then
            sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/wazuh.repo
            echo "  ${MSG_DISABLEREPO}"
        fi
    } >> "$LOG" 2>&1

    # -----------------------------
    # SAVE CREDENTIALS TO FILE
    # -----------------------------
    log_section "Credentials Saved"

    # Try to extract admin password from the install archive
    ADMIN_PASS=""
    if [[ -f /tmp/wazuh-install-files.tar ]]; then
        ADMIN_PASS=$(tar -O -xvf /tmp/wazuh-install-files.tar \
            wazuh-install-files/wazuh-passwords.txt 2>/dev/null \
            | grep -A1 "admin" | grep "password:" | head -1 | awk '{print $2}' | tr -d "'" || true)
    fi
    [[ -z "$ADMIN_PASS" ]] && ADMIN_PASS="(see /tmp/wazuh-install-files.tar)"

    cat > "$CRED_FILE" << CREDS
============================================================
  ${MSG_CREDTITLE_SERVER}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_URL}: https://${ACCESS_URL}
  ${MSG_URL}: https://${SERVER_IP}

  Login:    admin
  Password: ${ADMIN_PASS}

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}:  ${SERVER_IP}
  ${MSG_ACCESSURL}: ${ACCESS_URL}
  ${MSG_WAZUHVER}:  ${WAZUH_VERSION}.x

  Components:
  Wazuh Indexer    — port 9200
  Wazuh Manager    — port 55000 (API), 1514/1515 (agents)
  Wazuh Dashboard  — port 443

  Credentials archive: /tmp/wazuh-install-files.tar
  Extract all passwords:
  tar -O -xvf /tmp/wazuh-install-files.tar wazuh-install-files/wazuh-passwords.txt

  ${MSG_LOG}:   ${LOG}
  ${MSG_CREDS}: ${CRED_FILE}

  ${MSG_USEFUL_CMDS}:
  systemctl status  wazuh-manager
  systemctl restart wazuh-manager
  systemctl status  wazuh-indexer
  systemctl status  wazuh-dashboard
  journalctl -u wazuh-manager -f

============================================================
  ${MSG_KEEPFILE}
============================================================
CREDS

    chmod 600 "$CRED_FILE"
    echo "  Credentials saved to: $CRED_FILE" >> "$LOG"
    log_section "Deployment Finished — $(date)"

    # -----------------------------
    # SUMMARY OUTPUT — SERVER
    # -----------------------------
    echo ""
    echo "============================================================"
    echo "  ${MSG_DONE_SERVER}"
    echo "============================================================"
    echo ""
    echo "  ${MSG_URL}:"
    echo "  https://${ACCESS_URL}"
    echo "  https://${SERVER_IP}"
    echo ""
    echo "  Login:    admin"
    echo "  Password: ${ADMIN_PASS}"
    echo ""
    echo ""
    echo "  ${MSG_CHECKSTATUS}"
    for svc in wazuh-indexer wazuh-manager wazuh-dashboard; do
        if systemctl is-active --quiet "${svc}"; then
            echo "  ✔ ${svc}: ${MSG_RUNNING}"
        else
            echo "  ✘ ${svc}: ${MSG_NOTRUNNING}"
        fi
    done
    echo ""
    echo "  ${MSG_WAZUHVER}: ${WAZUH_VERSION}.x"
    echo "  ${MSG_LOG}:   ${LOG}"
    echo "  ${MSG_CREDS}: ${CRED_FILE}"
    echo ""
    echo "  ${MSG_NEXTSTEP_SERVER}"
    echo "============================================================"

fi  # end server mode


# ============================================================
# ██████╗  ██████╗████████╗    —    AGENT MODE
# ██╔══██╗██╔════╝╚══██╔══╝
# ███████║██║  ███╗  ██║
# ██╔══██║██║   ██║  ██║
# ██║  ██║╚██████╔╝  ██║
# ╚═╝  ╚═╝ ╚═════╝   ╚═╝
# ============================================================
if [[ "$INSTALL_MODE" == "agent" ]]; then

    CRED_FILE="/root/wazuh-agent-info.txt"

    # -----------------------------
    # USER PROMPTS — AGENT
    # -----------------------------
    echo ""
    read -rp "  ${MSG_PROMPT_MANAGERIP}: " MANAGER_IP
    while [[ -z "$MANAGER_IP" ]]; do
        echo "  (Manager IP is required)"
        read -rp "  ${MSG_PROMPT_MANAGERIP}: " MANAGER_IP
    done

    read -rp "  ${MSG_PROMPT_AGENTNAME} [$(hostname -s)]: " AGENT_NAME
    AGENT_NAME=${AGENT_NAME:-$(hostname -s)}

    read -rp "  ${MSG_PROMPT_AGENTGROUP} [default]: " AGENT_GROUP
    AGENT_GROUP=${AGENT_GROUP:-default}

    echo "  ${MSG_MANAGERIP}:  ${MANAGER_IP}" | tee -a "$LOG"
    echo "  ${MSG_AGENTNAME}:  ${AGENT_NAME}"  | tee -a "$LOG"
    echo "  ${MSG_AGENTGROUP}: ${AGENT_GROUP}" | tee -a "$LOG"
    echo ""

    # -----------------------------
    # STEP 1: Prerequisites
    # -----------------------------
    echo ""
    echo "${MSG_STEP1_AGENT}"
    log_section "STEP 1: System Update & Prerequisites"
    {
        dnf update -y
        dnf install -y curl wget tar coreutils initscripts
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 2: Repository + Install
    # -----------------------------
    echo "${MSG_STEP2_AGENT}"
    log_section "STEP 2: Configure Wazuh Repo & Install Agent"
    {
        # Import GPG key
        rpm --import "${WAZUH_GPG_KEY}"

        # AlmaLinux 10 is RHEL 10-compatible — use priority=1 (EL9+ format)
        cat > /etc/yum.repos.d/wazuh.repo << EOF
[wazuh]
gpgcheck=1
gpgkey=${WAZUH_GPG_KEY}
enabled=1
name=EL-\$releasever - Wazuh
baseurl=${WAZUH_REPO_URL}
priority=1
EOF

        echo "  Wazuh repository configured."

        # Install agent with deployment variables so it auto-enrolls
        WAZUH_MANAGER="${MANAGER_IP}" \
        WAZUH_AGENT_NAME="${AGENT_NAME}" \
        WAZUH_AGENT_GROUP="${AGENT_GROUP}" \
            dnf install -y wazuh-agent

        echo "  wazuh-agent package installed."

        # Disable repo to prevent accidental upgrades
        sed -i 's/^enabled=1/enabled=0/' /etc/yum.repos.d/wazuh.repo
        echo "  ${MSG_DISABLEREPO}"
    } >> "$LOG" 2>&1

    # -----------------------------
    # STEP 3: Enable & start service
    # -----------------------------
    echo "${MSG_STEP3_AGENT}"
    log_section "STEP 3: Enable & Start Wazuh Agent"
    {
        systemctl daemon-reload
        systemctl enable wazuh-agent
        systemctl start  wazuh-agent
        sleep 3
        if systemctl is-active --quiet wazuh-agent; then
            echo "  wazuh-agent: ${MSG_RUNNING}"
        else
            echo "  wazuh-agent: ${MSG_NOTRUNNING} — check: journalctl -u wazuh-agent"
        fi
    } >> "$LOG" 2>&1

    # -----------------------------
    # SAVE INFO TO FILE
    # -----------------------------
    log_section "Agent Info Saved"

    cat > "$CRED_FILE" << INFO
============================================================
  ${MSG_CREDTITLE_AGENT}
  ${MSG_GENERATED}: $(date)
============================================================

  ${MSG_AGENTSECTION}
  ${MSG_MANAGERIP}:  ${MANAGER_IP}
  ${MSG_AGENTNAME}:  ${AGENT_NAME}
  ${MSG_AGENTGROUP}: ${AGENT_GROUP}
  ${MSG_WAZUHVER}:   ${WAZUH_VERSION}.x
  ${MSG_AGENTCONFIG}: /var/ossec/etc/ossec.conf
  ${MSG_AGENTLOG}:   /var/ossec/logs/ossec.log

  ${MSG_USEFUL_CMDS}:
  systemctl status wazuh-agent
  systemctl restart wazuh-agent
  /var/ossec/bin/wazuh-control status
  tail -f /var/ossec/logs/ossec.log

  ${MSG_LOG}:   ${LOG}
  ${MSG_CREDS}: ${CRED_FILE}

============================================================
  ${MSG_KEEPFILE}
============================================================
INFO

    chmod 600 "$CRED_FILE"
    echo "  Agent info saved to: $CRED_FILE" >> "$LOG"
    log_section "Deployment Finished — $(date)"

    # -----------------------------
    # SUMMARY OUTPUT — AGENT
    # -----------------------------
    echo ""
    echo "============================================================"
    echo "  ${MSG_DONE_AGENT}"
    echo "============================================================"
    echo ""
    echo "  ${MSG_MANAGERIP}:  ${MANAGER_IP}"
    echo "  ${MSG_AGENTNAME}:  ${AGENT_NAME}"
    echo "  ${MSG_AGENTGROUP}: ${AGENT_GROUP}"
    echo ""
    echo "  ${MSG_CHECKSTATUS}"
    if systemctl is-active --quiet wazuh-agent; then
        echo "  ✔ wazuh-agent: ${MSG_RUNNING}"
    else
        echo "  ✘ wazuh-agent: ${MSG_NOTRUNNING}"
    fi
    echo ""
    echo "  ${MSG_AGENTCONFIG}: /var/ossec/etc/ossec.conf"
    echo "  ${MSG_AGENTLOG}:    /var/ossec/logs/ossec.log"
    echo "  ${MSG_WAZUHVER}:    ${WAZUH_VERSION}.x"
    echo "  ${MSG_LOG}:         ${LOG}"
    echo "  ${MSG_CREDS}:       ${CRED_FILE}"
    echo ""
    echo "  ${MSG_NEXTSTEP_AGENT}"
    echo "============================================================"

fi  # end agent mode

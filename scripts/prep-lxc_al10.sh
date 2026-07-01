#!/bin/bash
set -e

# ============================================================
#  LXC Base Setup Script — AlmaLinux 10
#  Installs: Base packages, firewalld, SSH, SELinux
#  Modes: Normal container | Template (cleaned & shutdown)
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
echo "============================================================"
echo "  LXC Base Setup — AlmaLinux 10"
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
        MSG_TITLE="Configuração Base LXC — AlmaLinux 10"
        MSG_STEP1="[1/3] A instalar pré-requisitos e ferramentas de base..."
        MSG_STEP2="[2/3] A configurar o SSH e o firewall..."
        MSG_STEP3="[3/3] A finalizar — modo template ou reinício..."
        MSG_DONE="CONFIGURAÇÃO LXC CONCLUÍDA"
        MSG_LOG="Registo de instalação"
        MSG_NEXTSTEP_NORMAL="Próximo passo: O contentor vai reiniciar. Ligue-se via SSH após o arranque."
        MSG_NEXTSTEP_TEMPLATE="Modo template: O contentor foi limpo e vai encerrar."
        MSG_PROMPT_MODE="Seleccione o modo de instalação:"
        MSG_MODE_OPT1="  1) Contentor normal (instalar e reiniciar)"
        MSG_MODE_OPT2="  2) Template (instalar, limpar e encerrar)"
        MSG_MODE_PROMPT="Escolha [1]"
        MSG_MODE_SELECTED="Modo seleccionado"
        MSG_MODE_INVALID="Opção inválida. A sair."
        MSG_ERR_ROOT="ERRO: Este script deve ser executado como root."
        MSG_TEMPLATE_CLEAN="A limpar o sistema para criação de template..."
        MSG_TEMPLATE_SHUTDOWN="A encerrar o contentor..."
        MSG_REBOOT="A reiniciar o contentor..."
        ;;
    3)
        MSG_TITLE="Configuration de base LXC — AlmaLinux 10"
        MSG_STEP1="[1/3] Installation des prérequis et outils de base..."
        MSG_STEP2="[2/3] Configuration de SSH et du pare-feu..."
        MSG_STEP3="[3/3] Finalisation — mode template ou redémarrage..."
        MSG_DONE="CONFIGURATION LXC TERMINÉE"
        MSG_LOG="Journal d'installation"
        MSG_NEXTSTEP_NORMAL="Prochaine étape : Le conteneur va redémarrer. Connectez-vous via SSH après le démarrage."
        MSG_NEXTSTEP_TEMPLATE="Mode template : Le conteneur a été nettoyé et va s'éteindre."
        MSG_PROMPT_MODE="Sélectionnez le mode d'installation :"
        MSG_MODE_OPT1="  1) Conteneur normal (installer et redémarrer)"
        MSG_MODE_OPT2="  2) Template (installer, nettoyer et éteindre)"
        MSG_MODE_PROMPT="Choix [1]"
        MSG_MODE_SELECTED="Mode sélectionné"
        MSG_MODE_INVALID="Option invalide. Fermeture."
        MSG_ERR_ROOT="ERREUR : Ce script doit être exécuté en tant que root."
        MSG_TEMPLATE_CLEAN="Nettoyage du système pour la création du template..."
        MSG_TEMPLATE_SHUTDOWN="Extinction du conteneur..."
        MSG_REBOOT="Redémarrage du conteneur..."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="LXC Base Setup — AlmaLinux 10"
        MSG_STEP1="[1/3] Installing base packages and tools..."
        MSG_STEP2="[2/3] Configuring SSH and firewall..."
        MSG_STEP3="[3/3] Finalising — template mode or reboot..."
        MSG_DONE="LXC SETUP COMPLETE"
        MSG_LOG="Deploy Log"
        MSG_NEXTSTEP_NORMAL="Next step: The container will reboot. Connect via SSH after startup."
        MSG_NEXTSTEP_TEMPLATE="Template mode: The container has been cleaned and will shut down."
        MSG_PROMPT_MODE="Select installation mode:"
        MSG_MODE_OPT1="  1) Normal container (install and reboot)"
        MSG_MODE_OPT2="  2) Template (install, clean and shutdown)"
        MSG_MODE_PROMPT="Choice [1]"
        MSG_MODE_SELECTED="Selected mode"
        MSG_MODE_INVALID="Invalid option. Exiting."
        MSG_ERR_ROOT="ERROR: This script must be run as root."
        MSG_TEMPLATE_CLEAN="Cleaning system for template creation..."
        MSG_TEMPLATE_SHUTDOWN="Shutting down container..."
        MSG_REBOOT="Rebooting container..."
        ;;
esac

# -----------------------------
# ROOT CHECK
# -----------------------------
if [[ "$EUID" -ne 0 ]]; then
    echo "  ${MSG_ERR_ROOT}"
    exit 1
fi

# -----------------------------
# CONFIGURATION
# -----------------------------
LOG="/var/log/deploy-lxc-base.log"

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
echo "  ${MSG_PROMPT_MODE}"
echo "${MSG_MODE_OPT1}"
echo "${MSG_MODE_OPT2}"
echo ""
read -rp "  ${MSG_MODE_PROMPT}: " CONTAINER_MODE
CONTAINER_MODE=${CONTAINER_MODE:-1}

case "$CONTAINER_MODE" in
    1) CONTAINER_TYPE="normal"   ;;
    2) CONTAINER_TYPE="template" ;;
    *)
        echo "  ${MSG_MODE_INVALID}"
        exit 1
        ;;
esac

echo ""
echo "  ${MSG_MODE_SELECTED}: ${CONTAINER_TYPE}" | tee -a "$LOG"
echo ""

# -----------------------------
# STEP 1: Base Packages
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: Base Packages"
{
    # Fix DNF mirrors — AlmaLinux repo files ship with "# baseurl=" (space
    # after #) which keeps the broken mirrorlist active. This enables the
    # official repo.almalinux.org baseurl and disables the mirrorlist.
    sed -i \
        -e 's|^mirrorlist=|#mirrorlist=|' \
        -e 's|^# baseurl=|baseurl=|' \
        /etc/yum.repos.d/almalinux*.repo
    dnf clean all
    echo "  DNF mirrors fixed."

    dnf install -y epel-release
    /usr/bin/crb enable

    dnf install -y \
        wget \
        curl \
        vim \
        nano \
        less \
        man \
        jq \
        fastfetch \
        htop \
        atop \
        iotop \
        sysstat \
        net-tools \
        iproute \
        iputils \
        bind-utils \
        traceroute \
        tcpdump \
        nmap \
        mtr \
        whois \
        ethtool \
        strace \
        lsof \
        nc \
        ncurses \
        ncurses-term \
        NetworkManager \
        NetworkManager-tui \
        firewalld \
        openssh-server \
        selinux-policy \
        selinux-policy-targeted \
        policycoreutils

    dnf update -y && dnf upgrade -y
    echo "  Base packages installed."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: SSH & Firewall
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: SSH & Firewall"
{
    # Allow root SSH login (appropriate for LXC lab environments)
    echo "PermitRootLogin yes" > /etc/ssh/sshd_config.d/permit_root.conf
    systemctl enable --now sshd
    echo "  SSH configured."

    systemctl enable firewalld
    systemctl start firewalld || true
    sleep 3
    if systemctl is-active --quiet firewalld; then
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --reload
        echo "  Firewall configured."
    else
        echo "  firewalld not running — skipping firewall rules (common in LXC)."
    fi
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Finalise
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Finalise (mode: ${CONTAINER_TYPE})"

echo ""
echo "============================================================"
echo "  ${MSG_DONE}"
echo "============================================================"
echo ""
echo "  ${MSG_MODE_SELECTED}: ${CONTAINER_TYPE}"
echo "  ${MSG_LOG}: ${LOG}"
echo ""

if [[ "$CONTAINER_TYPE" == "template" ]]; then
    echo "  ${MSG_NEXTSTEP_TEMPLATE}"
    echo "============================================================"

    # Truncate all log files
    find /var/log -type f -exec truncate -s 0 {} \;

    # Remove bash history
    rm -f /root/.bash_history
    find /home -name ".bash_history" -exec rm -f {} \;
    history -c

    # Reset machine-id (regenerated on first boot)
    truncate -s 0 /etc/machine-id
    mkdir -p /var/lib/dbus
    rm -f /var/lib/dbus/machine-id
    ln -sf /etc/machine-id /var/lib/dbus/machine-id

    # Clean package cache and temp files
    dnf clean all
    rm -rf /var/cache/dnf
    rm -rf /tmp/* /var/tmp/*

    echo "  ${MSG_TEMPLATE_SHUTDOWN}"
    sync
    poweroff -f

else
    echo "  ${MSG_NEXTSTEP_NORMAL}"
    echo "============================================================"

    echo "  ${MSG_REBOOT}" >> "$LOG"
    log_section "Deployment Finished — $(date)"

    reboot now
fi

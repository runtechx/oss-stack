#!/usr/bin/env bash
# =============================================================================
#  install_netbox_almalinux10.sh
#  Instalação automatizada do NetBox no AlmaLinux 10
#  Compatível com: AlmaLinux 10.x (RHEL 10 compatible)
#  Autor: gerado via Claude (Anthropic)
# =============================================================================
set -euo pipefail

# -----------------------------------------------------------------------------
# VARIÁVEIS DE CONFIGURAÇÃO — ajuste antes de executar
# -----------------------------------------------------------------------------
NETBOX_DB_NAME="netbox"
NETBOX_DB_USER="netbox"
NETBOX_DB_PASS="$(openssl rand -hex 20)"   # gerada automaticamente; guarde-a
NETBOX_SECRET_KEY="$(openssl rand -hex 50)"
NETBOX_ALLOWED_HOST="*"          # altere para o IP/domínio real do servidor
NETBOX_INSTALL_DIR="/opt/netbox"
NETBOX_VENV_DIR="${NETBOX_INSTALL_DIR}/venv"
NETBOX_BRANCH="master"           # ou "v4.x.x" para uma versão específica
NGINX_SERVER_NAME="_"            # altere para FQDN em produção
ADMIN_USER="admin"
ADMIN_EMAIL="admin@exemplo.local"
ADMIN_PASS="Admin@12345"         # mude esta palavra-passe depois do primeiro login

# Cores para output
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()    { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error()   { echo -e "${RED}[ERRO]${NC}  $*"; exit 1; }

# -----------------------------------------------------------------------------
# 0. VERIFICAÇÕES INICIAIS
# -----------------------------------------------------------------------------
[[ $EUID -ne 0 ]] && error "Este script deve ser executado como root (sudo)."

info "=== Instalação do NetBox no AlmaLinux 10 ==="
info "Palavra-passe BD gerada: ${NETBOX_DB_PASS}"
info "Chave secreta gerada   : ${NETBOX_SECRET_KEY}"
warn "Guarde as credenciais acima antes de continuar!"
echo ""
read -rp "Pressione ENTER para continuar ou Ctrl+C para abortar..."

# -----------------------------------------------------------------------------
# 1. ACTUALIZAR O SISTEMA
# -----------------------------------------------------------------------------
info "1/10 — A actualizar o sistema..."
dnf update -y

# -----------------------------------------------------------------------------
# 2. DEPENDÊNCIAS DO SISTEMA
# -----------------------------------------------------------------------------
info "2/10 — A instalar dependências do sistema..."
dnf groupinstall -y "Development Tools"
dnf install -y \
    python3 python3-pip python3-devel python3-setuptools python3-virtualenv \
    git gcc gcc-c++ \
    libxml2-devel libxslt-devel \
    libffi-devel openssl-devel \
    redhat-rpm-config \
    nginx \
    policycoreutils-python-utils

# -----------------------------------------------------------------------------
# 3. POSTGRESQL
# -----------------------------------------------------------------------------
info "3/10 — A instalar e configurar o PostgreSQL..."
dnf install -y postgresql postgresql-server postgresql-devel

# Inicializar cluster se ainda não existir
if [[ ! -f /var/lib/pgsql/data/PG_VERSION ]]; then
    postgresql-setup --initdb
fi

# Configurar autenticação md5
PG_HBA="/var/lib/pgsql/data/pg_hba.conf"
# Substituir ident/peer por md5 para ligações locais
sed -i 's/^\(local\s\+all\s\+all\s\+\)peer/\1md5/' "${PG_HBA}"
sed -i 's/^\(host\s\+all\s\+all\s\+127\.0\.0\.1\/32\s\+\)ident/\1md5/' "${PG_HBA}"
sed -i 's/^\(host\s\+all\s\+all\s\+::1\/128\s\+\)ident/\1md5/' "${PG_HBA}"

systemctl enable postgresql --now
systemctl restart postgresql

# Criar base de dados e utilizador
info "   A criar base de dados e utilizador PostgreSQL..."
sudo -u postgres psql <<EOF
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
EOF

# PostgreSQL 15+ exige GRANT no schema public
sudo -u postgres psql -d "${NETBOX_DB_NAME}" -c \
    "GRANT ALL ON SCHEMA public TO ${NETBOX_DB_USER};" 2>/dev/null || true

# -----------------------------------------------------------------------------
# 4. REDIS
# -----------------------------------------------------------------------------
info "4/10 — A instalar e configurar o Redis..."
dnf install -y redis

# Ligação apenas local
sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis/redis.conf 2>/dev/null || \
sed -i 's/^bind .*/bind 127.0.0.1/' /etc/redis.conf 2>/dev/null || true

systemctl enable redis --now

# -----------------------------------------------------------------------------
# 5. UTILIZADOR E DIRECTÓRIO DO NETBOX
# -----------------------------------------------------------------------------
info "5/10 — A criar utilizador de sistema e directórios..."
id netbox &>/dev/null || \
    useradd --system --shell /bin/bash \
            --home-dir "${NETBOX_INSTALL_DIR}" \
            --create-home netbox

mkdir -p "${NETBOX_INSTALL_DIR}"/{media,reports,scripts}
chown -R netbox:netbox "${NETBOX_INSTALL_DIR}"
chmod 750 "${NETBOX_INSTALL_DIR}"

# -----------------------------------------------------------------------------
# 6. CLONAR O NETBOX
# -----------------------------------------------------------------------------
info "6/10 — A descarregar o NetBox do GitHub..."
if [[ -d "${NETBOX_INSTALL_DIR}/.git" ]]; then
    warn "   Repositório já existe — a actualizar..."
    sudo -u netbox git -C "${NETBOX_INSTALL_DIR}" pull
else
    sudo -u netbox git clone -b "${NETBOX_BRANCH}" \
        https://github.com/netbox-community/netbox.git \
        "${NETBOX_INSTALL_DIR}"
fi

# -----------------------------------------------------------------------------
# 7. AMBIENTE VIRTUAL PYTHON E DEPENDÊNCIAS
# -----------------------------------------------------------------------------
info "7/10 — A criar ambiente virtual Python e instalar dependências..."
sudo -u netbox python3 -m venv "${NETBOX_VENV_DIR}"
sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install --upgrade pip wheel
sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install \
    -r "${NETBOX_INSTALL_DIR}/requirements.txt"

# Pacotes de produção adicionais
sudo -u netbox "${NETBOX_VENV_DIR}/bin/pip" install \
    gunicorn psycopg2-binary

# -----------------------------------------------------------------------------
# 8. FICHEIRO DE CONFIGURAÇÃO DO NETBOX
# -----------------------------------------------------------------------------
info "8/10 — A criar configuração do NetBox..."
NETBOX_CONF="${NETBOX_INSTALL_DIR}/netbox/netbox/configuration.py"

cp "${NETBOX_INSTALL_DIR}/netbox/netbox/configuration_example.py" \
   "${NETBOX_CONF}"

# Substituições no ficheiro de configuração
python3 - <<PYEOF
import re, pathlib

conf = pathlib.Path("${NETBOX_CONF}").read_text()

# ALLOWED_HOSTS
conf = re.sub(
    r"ALLOWED_HOSTS\s*=\s*\[.*?\]",
    "ALLOWED_HOSTS = ['${NETBOX_ALLOWED_HOST}']",
    conf, flags=re.DOTALL
)

# DATABASE
conf = re.sub(
    r"DATABASE\s*=\s*\{.*?\}",
    """DATABASE = {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': '${NETBOX_DB_NAME}',
    'USER': '${NETBOX_DB_USER}',
    'PASSWORD': '${NETBOX_DB_PASS}',
    'HOST': 'localhost',
    'PORT': '',
    'CONN_MAX_AGE': 300,
}""",
    conf, flags=re.DOTALL
)

# REDIS
conf = re.sub(
    r"REDIS\s*=\s*\{.*?\}\s*\}",
    """REDIS = {
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
    }
}""",
    conf, flags=re.DOTALL
)

# SECRET_KEY
conf = re.sub(
    r"SECRET_KEY\s*=\s*['\"].*?['\"]",
    "SECRET_KEY = '${NETBOX_SECRET_KEY}'",
    conf
)

pathlib.Path("${NETBOX_CONF}").write_text(conf)
print("Configuração escrita com sucesso.")
PYEOF

chown netbox:netbox "${NETBOX_CONF}"
chmod 640 "${NETBOX_CONF}"

# -----------------------------------------------------------------------------
# 9. MIGRAÇÕES, FICHEIROS ESTÁTICOS E SUPER-UTILIZADOR
# -----------------------------------------------------------------------------
info "9/10 — A inicializar base de dados e criar super-utilizador..."
cd "${NETBOX_INSTALL_DIR}/netbox"

MANAGE="${NETBOX_VENV_DIR}/bin/python3 manage.py"

sudo -u netbox ${MANAGE} migrate
sudo -u netbox ${MANAGE} collectstatic --no-input
sudo -u netbox ${MANAGE} remove_stale_contenttypes --no-input 2>/dev/null || true

# Criar super-utilizador de forma não interactiva
sudo -u netbox ${MANAGE} shell <<PYEOF
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='${ADMIN_USER}').exists():
    User.objects.create_superuser('${ADMIN_USER}', '${ADMIN_EMAIL}', '${ADMIN_PASS}')
    print("Super-utilizador criado: ${ADMIN_USER}")
else:
    print("Super-utilizador já existe.")
PYEOF

# -----------------------------------------------------------------------------
# 10. GUNICORN + NGINX + SYSTEMD
# -----------------------------------------------------------------------------
info "10/10 — A configurar Gunicorn, Nginx e serviços systemd..."

# --- Gunicorn config ---
cat > /etc/netbox/gunicorn.py <<'EOF'
bind = "127.0.0.1:8001"
workers = 5
threads = 3
timeout = 120
max_requests = 5000
max_requests_jitter = 500
EOF

mkdir -p /etc/netbox
cat > /etc/netbox/gunicorn.py <<'EOF'
bind = "127.0.0.1:8001"
workers = 5
threads = 3
timeout = 120
max_requests = 5000
max_requests_jitter = 500
EOF

# --- Serviço netbox (Gunicorn) ---
cat > /etc/systemd/system/netbox.service <<EOF
[Unit]
Description=NetBox WSGI Service
Documentation=https://docs.netbox.dev/
After=network-online.target
Wants=network-online.target

[Service]
User=netbox
Group=netbox
WorkingDirectory=${NETBOX_INSTALL_DIR}/netbox
ExecStart=${NETBOX_VENV_DIR}/bin/gunicorn \\
    --pid /var/tmp/netbox.pid \\
    --pythonpath ${NETBOX_INSTALL_DIR}/netbox \\
    -c /etc/netbox/gunicorn.py \\
    netbox.wsgi
Restart=on-failure
RestartSec=30
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# --- Serviço netbox-rq (worker de filas) ---
cat > /etc/systemd/system/netbox-rq.service <<EOF
[Unit]
Description=NetBox Request Queue Worker
Documentation=https://docs.netbox.dev/
After=network-online.target
Wants=network-online.target

[Service]
User=netbox
Group=netbox
WorkingDirectory=${NETBOX_INSTALL_DIR}/netbox
ExecStart=${NETBOX_VENV_DIR}/bin/python3 manage.py rqworker
Restart=on-failure
RestartSec=30
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

# --- Nginx ---
cat > /etc/nginx/conf.d/netbox.conf <<EOF
server {
    listen 80;
    server_name ${NGINX_SERVER_NAME};

    client_max_body_size 25m;

    location /static/ {
        alias ${NETBOX_INSTALL_DIR}/netbox/static/;
    }

    location / {
        proxy_pass http://127.0.0.1:8001;
        proxy_set_header X-Forwarded-Host \$http_host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect http://127.0.0.1:8001 http://\$http_host/;
        proxy_read_timeout 120;
        proxy_connect_timeout 120;
        proxy_send_timeout 120;
    }
}
EOF

# Remover default do nginx se existir
rm -f /etc/nginx/conf.d/default.conf

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

# --- Activar e iniciar serviços ---
systemctl daemon-reload
systemctl enable --now netbox netbox-rq nginx

# --- Housekeeping cron ---
cat > /etc/cron.d/netbox <<EOF
# NetBox daily housekeeping
0 0 * * * netbox ${NETBOX_VENV_DIR}/bin/python3 \\
    ${NETBOX_INSTALL_DIR}/netbox/manage.py housekeeping
EOF

# =============================================================================
# RESUMO FINAL
# =============================================================================
echo ""
echo -e "${GREEN}============================================================${NC}"
echo -e "${GREEN}   NetBox instalado com sucesso no AlmaLinux 10!${NC}"
echo -e "${GREEN}============================================================${NC}"
echo ""
echo -e "  URL de acesso : ${YELLOW}http://$(hostname -I | awk '{print $1}')/${NC}"
echo -e "  Utilizador    : ${YELLOW}${ADMIN_USER}${NC}"
echo -e "  Palavra-passe : ${YELLOW}${ADMIN_PASS}${NC}  ← altere após o login!"
echo -e "  BD palavra-passe : ${YELLOW}${NETBOX_DB_PASS}${NC}"
echo ""
echo -e "  Estado dos serviços:"
systemctl is-active netbox    && echo -e "    netbox     : ${GREEN}activo${NC}" \
                               || echo -e "    netbox     : ${RED}inactivo${NC}"
systemctl is-active netbox-rq && echo -e "    netbox-rq  : ${GREEN}activo${NC}" \
                               || echo -e "    netbox-rq  : ${RED}inactivo${NC}"
systemctl is-active nginx     && echo -e "    nginx      : ${GREEN}activo${NC}" \
                               || echo -e "    nginx      : ${RED}inactivo${NC}"
echo ""
echo -e "${YELLOW}NOTA: Guarde as credenciais acima em local seguro.${NC}"
echo -e "${YELLOW}Para SSL/TLS, adicione o seu certificado no ficheiro:${NC}"
echo -e "${YELLOW}  /etc/nginx/conf.d/netbox.conf${NC}"
echo ""

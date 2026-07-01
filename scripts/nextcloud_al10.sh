#!/bin/bash
set -e

# ============================================================
#  Nextcloud Deployment Script — AlmaLinux 10
#  Installs: Nginx, MariaDB, PHP (AppStream), Nextcloud (latest)
#  Source: https://github.com/runtechx/
# ============================================================

# -----------------------------
# LANGUAGE SELECTION
# -----------------------------
clear
echo "============================================================"
echo "  Nextcloud Deployment — AlmaLinux 10"
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
        MSG_TITLE="Instalação Nextcloud — AlmaLinux 10"
        MSG_STEP1="[1/6] A actualizar o sistema e a instalar pré-requisitos..."
        MSG_STEP2="[2/6] A instalar e configurar o MariaDB..."
        MSG_STEP3="[3/6] A descarregar e instalar o Nextcloud..."
        MSG_STEP4="[4/6] A configurar o PHP-FPM e o Nginx..."
        MSG_STEP5="[5/6] A configurar o SELinux e as permissões..."
        MSG_STEP6="[6/6] A configurar o firewall..."
        MSG_DONE="INSTALAÇÃO DO NEXTCLOUD CONCLUÍDA"
        MSG_URL="URL"
        MSG_IP="IP do Servidor"
        MSG_LOG="Registo de instalação"
        MSG_CREDS="Ficheiro de credenciais"
        MSG_NEXTSTEP="Próximo passo: Abra o URL no seu browser e inicie sessão com as credenciais definidas"
        MSG_CREDTITLE="Instalação Nextcloud — Credenciais"
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
        MSG_NCVER="Versão Nextcloud"
        MSG_ADMINUSER="Utilizador Admin"
        MSG_ADMINPASS="Password Admin"
        MSG_NGINXCONF="Config Nginx"
        MSG_INSTALLDIR="Directório de instalação"
        MSG_KEEPFILE="GUARDE ESTE FICHEIRO — ELIMINE APÓS ANOTAR AS CREDENCIAIS"
        MSG_PROMPT_IP="Endereço IP do servidor"
        MSG_PROMPT_URL="URL de acesso (FQDN ou IP)"
        MSG_PROMPT_ADMINUSER="Utilizador administrador do Nextcloud"
        MSG_WARN_TIME="A instalação pode demorar vários minutos — por favor aguarde."
        ;;
    3)
        MSG_TITLE="Installation Nextcloud — AlmaLinux 10"
        MSG_STEP1="[1/6] Mise à jour du système et installation des prérequis..."
        MSG_STEP2="[2/6] Installation et configuration de MariaDB..."
        MSG_STEP3="[3/6] Téléchargement et installation de Nextcloud..."
        MSG_STEP4="[4/6] Configuration de PHP-FPM et Nginx..."
        MSG_STEP5="[5/6] Configuration de SELinux et des permissions..."
        MSG_STEP6="[6/6] Configuration du pare-feu..."
        MSG_DONE="INSTALLATION DE NEXTCLOUD TERMINÉE"
        MSG_URL="URL"
        MSG_IP="IP Serveur"
        MSG_LOG="Journal d'installation"
        MSG_CREDS="Fichier d'identifiants"
        MSG_NEXTSTEP="Prochaine étape : Ouvrez l'URL dans votre navigateur et connectez-vous avec les identifiants définis"
        MSG_CREDTITLE="Installation Nextcloud — Identifiants"
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
        MSG_NCVER="Version Nextcloud"
        MSG_ADMINUSER="Utilisateur Admin"
        MSG_ADMINPASS="Mot de passe Admin"
        MSG_NGINXCONF="Config Nginx"
        MSG_INSTALLDIR="Répertoire d'installation"
        MSG_KEEPFILE="CONSERVEZ CE FICHIER — SUPPRIMEZ-LE APRÈS AVOIR NOTÉ LES IDENTIFIANTS"
        MSG_PROMPT_IP="Adresse IP du serveur"
        MSG_PROMPT_URL="URL d'accès (FQDN ou IP)"
        MSG_PROMPT_ADMINUSER="Utilisateur administrateur Nextcloud"
        MSG_WARN_TIME="L'installation peut prendre plusieurs minutes — veuillez patienter."
        ;;
    *)
        # Default: English (option 2 or any invalid input)
        MSG_TITLE="Nextcloud Deployment — AlmaLinux 10"
        MSG_STEP1="[1/6] Updating system and installing prerequisites..."
        MSG_STEP2="[2/6] Installing and configuring MariaDB..."
        MSG_STEP3="[3/6] Downloading and installing Nextcloud..."
        MSG_STEP4="[4/6] Configuring PHP-FPM and Nginx..."
        MSG_STEP5="[5/6] Configuring SELinux and permissions..."
        MSG_STEP6="[6/6] Configuring firewall..."
        MSG_DONE="NEXTCLOUD DEPLOYMENT COMPLETE"
        MSG_URL="URL"
        MSG_IP="Server IP"
        MSG_LOG="Deploy Log"
        MSG_CREDS="Credentials File"
        MSG_NEXTSTEP="Next step: Open the URL in your browser and log in with the credentials you set"
        MSG_CREDTITLE="Nextcloud Installation — Credentials"
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
        MSG_NCVER="Nextcloud Version"
        MSG_ADMINUSER="Admin User"
        MSG_ADMINPASS="Admin Password"
        MSG_NGINXCONF="Nginx Config"
        MSG_INSTALLDIR="Install Directory"
        MSG_KEEPFILE="KEEP THIS FILE SAFE — DELETE AFTER NOTING CREDENTIALS"
        MSG_PROMPT_IP="Server IP address"
        MSG_PROMPT_URL="Access URL (FQDN or IP)"
        MSG_PROMPT_ADMINUSER="Nextcloud admin username"
        MSG_WARN_TIME="Installation may take several minutes — please wait."
        ;;
esac

# -----------------------------
# CONFIGURATION
# -----------------------------
INSTALL_DIR="/var/www/nextcloud"
DATA_DIR="/var/www/nextcloud-data"
DB_NAME="nextcloud"
DB_USER="nextcloud"
DB_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
MYSQL_ROOT_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)
LOG="/var/log/deploy-nextcloud.log"
CRED_FILE="/root/nextcloud-credentials.txt"
NC_ARCHIVE_URL="https://download.nextcloud.com/server/releases/latest.tar.bz2"

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

read -rp "  ${MSG_PROMPT_ADMINUSER} (admin): " NC_ADMIN_USER
NC_ADMIN_USER=${NC_ADMIN_USER:-admin}

NC_ADMIN_PASS=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 20)

echo ""
echo "  ${MSG_SERVERIP}: ${SERVER_IP}"  | tee -a "$LOG"
echo "  ${MSG_ACCESSURL}: ${ACCESS_URL}" | tee -a "$LOG"
echo "  ${MSG_ADMINUSER}: ${NC_ADMIN_USER}" | tee -a "$LOG"
echo ""

# -----------------------------
# STEP 1: Prerequisites & PHP
# -----------------------------
echo "${MSG_STEP1}"
log_section "STEP 1: System Update & Prerequisites"
{
    dnf update -y
    dnf install -y \
        wget curl tar bzip2 unzip \
        php php-cli php-fpm \
        php-bcmath php-ctype php-curl php-dom php-exif php-fileinfo \
        php-gd php-gmp php-iconv php-intl php-json php-ldap \
        php-mbstring php-mysqlnd php-opcache php-pcntl php-posix \
        php-session php-simplexml php-xmlreader php-xmlwriter \
        php-zip php-apcu php-pecl-imagick \
        policycoreutils-python-utils
    php -v

    # PHP performance tuning for Nextcloud
    PHP_INI=$(php --ini | grep 'Loaded Configuration' | awk '{print $NF}')
    sed -i 's/^memory_limit = .*/memory_limit = 512M/'       "$PHP_INI"
    sed -i 's/^upload_max_filesize = .*/upload_max_filesize = 16G/' "$PHP_INI"
    sed -i 's/^post_max_size = .*/post_max_size = 16G/'      "$PHP_INI"
    sed -i 's/^max_execution_time = .*/max_execution_time = 3600/' "$PHP_INI"
    sed -i 's/^;date.timezone.*/date.timezone = UTC/'         "$PHP_INI"

    echo "  PHP configured."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 2: Install MariaDB
# -----------------------------
echo "${MSG_STEP2}"
log_section "STEP 2: Install MariaDB"
{
    dnf install -y mariadb-server
    systemctl enable --now mariadb
    sleep 5

    mysql <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
FLUSH PRIVILEGES;
SQL

    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e \
        "CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e \
        "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
    mysql -uroot -p"${MYSQL_ROOT_PASS}" -e \
        "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost'; FLUSH PRIVILEGES;"

    # Recommended Nextcloud MariaDB settings
    cat >> /etc/my.cnf.d/nextcloud.cnf << MYCNF
[mysqld]
transaction_isolation = READ-COMMITTED
binlog_format          = ROW
MYCNF
    systemctl restart mariadb

    mysql -u"${DB_USER}" -p"${DB_PASS}" "${DB_NAME}" -e "SELECT 1;" > /dev/null
    echo "  Database connectivity confirmed."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 3: Download & Install Nextcloud
# -----------------------------
echo "${MSG_STEP3}"
log_section "STEP 3: Download & Install Nextcloud"
{
    mkdir -p /tmp/nc-install
    wget -q "${NC_ARCHIVE_URL}"        -O /tmp/nc-install/nextcloud-latest.tar.bz2
    wget -q "${NC_ARCHIVE_URL}.sha256" -O /tmp/nc-install/nextcloud-latest.tar.bz2.sha256

    # The sha256 file references the original versioned filename (e.g. nextcloud-30.0.0.tar.bz2).
    # Extract that name and create a symlink so sha256sum can find it.
    cd /tmp/nc-install
    NC_ORIG_NAME=$(awk '{print $2}' nextcloud-latest.tar.bz2.sha256)
    ln -sf nextcloud-latest.tar.bz2 "${NC_ORIG_NAME}"
    sha256sum -c nextcloud-latest.tar.bz2.sha256
    echo "  Checksum verified."

    tar -xjf nextcloud-latest.tar.bz2 -C /var/www/
    mv /var/www/nextcloud "${INSTALL_DIR}"

    # Dedicated data directory outside web root
    mkdir -p "${DATA_DIR}"
    chown -R apache:apache "${INSTALL_DIR}" "${DATA_DIR}"
    chmod -R 755 "${INSTALL_DIR}"
    chmod 750 "${DATA_DIR}"

    rm -rf /tmp/nc-install
    echo "  Nextcloud extracted to: ${INSTALL_DIR}"

    # Run silent installation via occ
    sudo -u apache php "${INSTALL_DIR}/occ" maintenance:install \
        --database      "mysql" \
        --database-host "localhost" \
        --database-name "${DB_NAME}" \
        --database-user "${DB_USER}" \
        --database-pass "${DB_PASS}" \
        --admin-user    "${NC_ADMIN_USER}" \
        --admin-pass    "${NC_ADMIN_PASS}" \
        --data-dir      "${DATA_DIR}"

    # Add server IP and URL to trusted domains
    sudo -u apache php "${INSTALL_DIR}/occ" config:system:set \
        trusted_domains 0 --value="${SERVER_IP}"
    sudo -u apache php "${INSTALL_DIR}/occ" config:system:set \
        trusted_domains 1 --value="${ACCESS_URL}"

    # Recommended performance settings
    sudo -u apache php "${INSTALL_DIR}/occ" config:system:set \
        memcache.local --value="\OC\Memcache\APCu"
    sudo -u apache php "${INSTALL_DIR}/occ" config:system:set \
        default_phone_region --value="PT"

    NC_VERSION=$(sudo -u apache php "${INSTALL_DIR}/occ" --version 2>/dev/null | awk '{print $NF}' || echo "unknown")
    echo "  Nextcloud ${NC_VERSION} installed."
} >> "$LOG" 2>&1

NC_VERSION=$(sudo -u apache php "${INSTALL_DIR}/occ" --version 2>/dev/null | awk '{print $NF}' || echo "unknown")

# -----------------------------
# STEP 4: PHP-FPM & Nginx
# -----------------------------
echo "${MSG_STEP4}"
log_section "STEP 4: Configure PHP-FPM & Nginx"
{
    dnf install -y nginx

    # Nextcloud-specific PHP-FPM pool
    cat > /etc/php-fpm.d/nextcloud.conf << FPMEOF
[nextcloud]
user  = apache
group = apache

listen = /run/php-fpm/nextcloud.sock
listen.owner = nginx
listen.group = nginx
listen.mode  = 0660

pm                   = dynamic
pm.max_children      = 120
pm.start_servers     = 12
pm.min_spare_servers = 6
pm.max_spare_servers = 18
pm.max_requests      = 500

env[HOSTNAME] = \$HOSTNAME
env[PATH]     = /usr/local/bin:/usr/bin:/bin
env[TMP]      = /tmp
env[TMPDIR]   = /tmp
env[TEMP]     = /tmp

php_admin_value[memory_limit]    = 512M
php_admin_value[upload_max_filesize] = 16G
php_admin_value[post_max_size]   = 16G
php_value[opcache.interned_strings_buffer] = 16
php_value[opcache.max_accelerated_files]   = 10000
php_value[opcache.memory_consumption]      = 128
php_value[opcache.save_comments]           = 1
php_value[opcache.revalidate_freq]         = 1
FPMEOF

    # Nginx vhost for Nextcloud
    cat > /etc/nginx/conf.d/nextcloud.conf << NGINXEOF
upstream php-handler {
    server unix:/run/php-fpm/nextcloud.sock;
}

server {
    listen 80;
    listen [::]:80;
    server_name ${SERVER_IP} ${ACCESS_URL};

    root ${INSTALL_DIR}/;
    index index.php index.html;

    client_max_body_size 16G;
    fastcgi_buffers 64 4K;

    gzip on;
    gzip_vary on;
    gzip_comp_level 4;
    gzip_min_length 256;
    gzip_proxied expired no-cache no-store private no_last_modified no_etag auth;
    gzip_types application/atom+xml text/javascript application/javascript
               application/json application/ld+json application/manifest+json
               application/rss+xml application/vnd.geo+json application/vnd.ms-fontobject
               application/wasm application/x-font-ttf application/x-web-app-manifest+json
               application/xhtml+xml application/xml font/opentype image/bmp
               image/svg+xml image/x-icon text/cache-manifest text/css text/plain
               text/vcard text/vnd.rim.location.xloc text/vtt text/x-component text/x-cross-domain-policy;

    add_header Referrer-Policy                   "no-referrer"       always;
    add_header X-Content-Type-Options            "nosniff"           always;
    add_header X-Frame-Options                   "SAMEORIGIN"        always;
    add_header X-Permitted-Cross-Domain-Policies "none"              always;
    add_header X-Robots-Tag                      "noindex, nofollow" always;
    add_header X-XSS-Protection                  "1; mode=block"     always;

    fastcgi_hide_header X-Powered-By;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log    off;
    }

    location ^~ /.well-known {
        location = /.well-known/carddav { return 301 /remote.php/dav/; }
        location = /.well-known/caldav  { return 301 /remote.php/dav/; }
        location ^~ /.well-known        { return 301 /index.php\$uri;  }
        try_files \$uri \$uri/ =404;
    }

    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:\$|/) { return 404; }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }

    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|oc[ms]-provider/.+|.+/richdocumentscode/proxy)\.php(?:\$|/) {
        fastcgi_split_path_info ^(.+?\.php)(/.*)$;
        set \$path_info \$fastcgi_path_info;
        try_files \$fastcgi_script_name =404;
        include        fastcgi_params;
        fastcgi_param  SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param  PATH_INFO       \$path_info;
        fastcgi_param  HTTPS           off;
        fastcgi_param  modHeadersAvailable true;
        fastcgi_param  front_controller_active true;
        fastcgi_pass   php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off;
        fastcgi_read_timeout 3600;
        fastcgi_send_timeout 3600;
    }

    location ~ ^/(?:updater|oc[ms]-provider)(?:\$|/) {
        try_files \$uri/ =404;
        index index.php;
    }

    location ~ \.(?:css|js|woff2?|svg|gif|map|png|html|ttf|ico|jpg|jpeg|webp)\$ {
        try_files \$uri /index.php\$request_uri;
        expires 6M;
        access_log off;
    }

    location / {
        try_files \$uri \$uri/ /index.php\$request_uri;
    }

    error_log  /var/log/nginx/nextcloud_error.log;
    access_log /var/log/nginx/nextcloud_access.log combined;
}
NGINXEOF

    nginx -t
    systemctl enable --now php-fpm nginx
    systemctl restart php-fpm nginx
    echo "  Nginx and PHP-FPM configured and started."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 5: SELinux & Permissions
# -----------------------------
echo "${MSG_STEP5}"
log_section "STEP 5: SELinux & Permissions"
{
    semanage fcontext -a -t httpd_sys_content_t    "${INSTALL_DIR}(/.*)?"
    semanage fcontext -a -t httpd_sys_rw_content_t "${DATA_DIR}(/.*)?"
    semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/apps(/.*)?"
    semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/config(/.*)?"
    semanage fcontext -a -t httpd_sys_rw_content_t "${INSTALL_DIR}/themes(/.*)?"
    restorecon -Rv "${INSTALL_DIR}" "${DATA_DIR}"

    setsebool -P httpd_can_network_connect    on
    setsebool -P httpd_can_network_connect_db on
    setsebool -P httpd_can_sendmail           on
    setsebool -P httpd_use_nfs                on

    # Cron job for Nextcloud background tasks
    (crontab -u apache -l 2>/dev/null; \
     echo "*/5 * * * * php -f ${INSTALL_DIR}/cron.php") | crontab -u apache -
    echo "  Cron job added for apache user."
} >> "$LOG" 2>&1

# -----------------------------
# STEP 6: Configure Firewall
# -----------------------------
echo "${MSG_STEP6}"
log_section "STEP 6: Configure Firewall"
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
  http://${ACCESS_URL}
  http://${SERVER_IP}

  ${MSG_ADMINUSER}: ${NC_ADMIN_USER}
  ${MSG_ADMINPASS}: ${NC_ADMIN_PASS}

  ${MSG_DBSECTION}
  ${MSG_DBNAME}: ${DB_NAME}
  ${MSG_DBUSER}: ${DB_USER}
  ${MSG_DBPASS}: ${DB_PASS}
  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}
  ${MSG_DBHOST}: localhost

  ${MSG_SRVSECTION}
  ${MSG_SERVERIP}: ${SERVER_IP}
  ${MSG_ACCESSURL}: ${ACCESS_URL}
  ${MSG_NCVER}: ${NC_VERSION}
  ${MSG_INSTALLDIR}: ${INSTALL_DIR}
  Data Dir: ${DATA_DIR}
  ${MSG_NGINXCONF}: /etc/nginx/conf.d/nextcloud.conf
  ${MSG_LOG}: ${LOG}
  ${MSG_CREDS}: ${CRED_FILE}

  Tips:
  - Enable HTTPS: dnf install -y certbot python3-certbot-nginx && certbot --nginx -d ${ACCESS_URL}
  - Nextcloud logs: ${DATA_DIR}/nextcloud.log
  - Run OCC commands: sudo -u apache php ${INSTALL_DIR}/occ <command>

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
echo "  ${MSG_ADMINUSER}: ${NC_ADMIN_USER}"
echo "  ${MSG_ADMINPASS}: ${NC_ADMIN_PASS}"
echo ""
echo "  ${MSG_DBNAME}: ${DB_NAME}"
echo "  ${MSG_DBUSER}: ${DB_USER}"
echo "  ${MSG_DBPASS}: ${DB_PASS}"
echo "  ${MSG_DBROOTPASS}: ${MYSQL_ROOT_PASS}"
echo ""
echo "  ${MSG_NCVER}: ${NC_VERSION}"
echo "  ${MSG_INSTALLDIR}: ${INSTALL_DIR}"
echo "  Data Dir: ${DATA_DIR}"
echo "  ${MSG_NGINXCONF}: /etc/nginx/conf.d/nextcloud.conf"
echo "  ${MSG_LOG}: ${LOG}"
echo "  ${MSG_CREDS}: ${CRED_FILE}"
echo ""
echo "  ${MSG_NEXTSTEP}"
echo "============================================================"

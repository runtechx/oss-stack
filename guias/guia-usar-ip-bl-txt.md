# Guia — Como usar ip-bl.txt com Fail2ban

> Lista de bloqueio centralizada distribuída via GitHub  
>
> Fonte: [Política OpenFirst da RunTech](https://github.com/runtechx) 
>
> Ficheiro: `https://raw.githubusercontent.com/runtechx/Openfirst/master/blocklists/ip-bl.txt`

>[!IMPORTANT]
> Usa a conta root caso não for possível 
>```bash
>su - root
>```
>adicione `sudo` antes de cada comando

## 1. Instalar EPEL e Fail2ban

```bash
# Instalar EPEL
dnf install -y epel-release

# Instalar Fail2ban
dnf install -y fail2ban fail2ban-systemd

# Activar e iniciar o serviço
systemctl enable --now fail2ban

# Verificar estado
systemctl status fail2ban
```


## 2. Configurar o Fail2ban

```bash
cat > /etc/fail2ban/jail.local << 'CONF'
[DEFAULT]
bantime  = 24h
findtime = 10m
maxretry = 5
backend  = systemd

[sshd]
enabled  = true
port     = ssh
filter   = sshd
maxretry = 3
bantime  = 48h
CONF
```

Recarregar após configurar:

```bash
systemctl restart fail2ban
```

```bash
fail2ban-client status
```


## 3. Script de importação automática da ip-bl.txt

```bash
cat > /usr/local/bin/import-ip-bl.sh << 'EOF'
#!/bin/bash
set -e

BLOCKLIST_URL="https://raw.githubusercontent.com/runtechx/Openfirst/master/blocklists/ip-bl.txt"
TMP_FILE=$(mktemp)
LOG="/var/log/import-ip-bl.log"

echo "[$(date)] A importar blocklist..." >> "$LOG"

# Descarregar a lista
if ! curl -fsSL "$BLOCKLIST_URL" -o "$TMP_FILE"; then
    echo "[$(date)] Erro ao descarregar blocklist." >> "$LOG"
    exit 1
fi

# Obter jails activas
JAILS=$(fail2ban-client status | grep "Jail list" | cut -d: -f2 | tr ',' ' ')

# Importar cada IP para todas as jails
COUNT=0
while read -r ip; do
    [[ -z "$ip" ]] && continue
    echo "$ip" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' || continue

    for jail in $JAILS; do
        fail2ban-client set "$jail" banip "$ip" 2>/dev/null || true
    done

    ((COUNT++)) || true
done < "$TMP_FILE"

rm -f "$TMP_FILE"

echo "[$(date)] Importados $COUNT IPs com sucesso." >> "$LOG"
EOF
```

Tornar executável 

```bash
chmod +x /usr/local/bin/import-ip-bl.sh
```

## 4. Crontab a cada 1 hora (Agendar a execução da tarefa)

Adiciona directamente a tarefa sem abrir o editor crontab -e

```bash
(crontab -l 2>/dev/null | grep -v "import-ip-bl.sh"; \
echo "0 * * * * /usr/local/bin/import-ip-bl.sh >> /var/log/import-ip-bl.log 2>&1") | crontab -
```

Verificar se ficou guardado

```bash
crontab -l
```

## 5. Outros comandos 

Bloquear IP 
```bash
sudo fail2ban-client set sshd banip x.x.x.x
```

Desbloquear IP 
```bash
sudo fail2ban-client set sshd unbanip x.x.x.x
```

Ver IP bloqueados 
```bash
sudo fail2ban-client status sshd
```

Desbloquear todos IPs 
```bash
sudo fail2ban-client unban --all
sudo systemctl restart fail2ban
```

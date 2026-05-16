
# Conteúdo

* [Como usar `ip-bl.txt` com Fail2ban](#como-usar-ip-bltxt-com-fail2ban)

  * [1. Instalar EPEL e Fail2ban](#1-instalar-epel-e-fail2ban)
  * [2. Configurar o Fail2ban](#2-configurar-o-fail2ban)
  * [3. Criar o script de importação automática](#3-criar-o-script-de-importação-automática)
  * [4. Agendar execução automática com Crontab](#4-agendar-execução-automática-com-crontab)
  * [5. Comandos úteis](#5-comandos-úteis)


# Como usar `ip-bl.txt` com Fail2ban

> Lista de bloqueio centralizada distribuída via GitHub.
>
> **Ficheiro:**
> `https://raw.githubusercontent.com/runtechx/Openfirst/master/blocklists/ip-bl.txt`

> [!IMPORTANT]
> Se o seu sistema não tiver `sudo`, instale com o comando abaixo ou utilize a conta `root` e remova o `sudo` dos comandos.
>
> ```bash
> dnf install -y sudo
> ```



## 1. Instalar EPEL e Fail2ban

### Instalar repositório EPEL

```bash
sudo dnf install -y epel-release
```

### Instalar Fail2ban

```bash
sudo dnf install -y fail2ban fail2ban-systemd
```

### Activar e iniciar o serviço

```bash
sudo systemctl enable --now fail2ban
```

### Verificar estado do serviço

```bash
sudo systemctl status fail2ban
```


## 2. Configurar o Fail2ban

Criar o ficheiro de configuração:

```bash
sudo cat > /etc/fail2ban/jail.local << 'CONF'
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

### Reiniciar o serviço após a configuração

```bash
sudo systemctl restart fail2ban
```

### Verificar estado das jails

```bash
sudo fail2ban-client status
```



## 3. Criar o script de importação automática

Criar o script:

```bash
sudo cat > /usr/local/bin/import-ip-bl.sh << 'EOF'
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

# Importar IPs para todas as jails
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

### Tornar o script executável

```bash
sudo chmod +x /usr/local/bin/import-ip-bl.sh
```

### Executar manualmente para teste

```bash
sudo /usr/local/bin/import-ip-bl.sh
```

### Verificar logs

```bash
sudo tail -f /var/log/import-ip-bl.log
```



## 4. Agendar execução automática com Crontab

Adicionar execução automática a cada 1 hora:

```bash
(crontab -l 2>/dev/null | grep -v "import-ip-bl.sh"; \
echo "0 * * * * /usr/local/bin/import-ip-bl.sh >> /var/log/import-ip-bl.log 2>&1") | crontab -
```

### Verificar se a tarefa foi adicionada

```bash
crontab -l
```



## 5. Comandos úteis

### Bloquear IP manualmente

```bash
sudo fail2ban-client set sshd banip x.x.x.x
```

### Desbloquear IP

```bash
sudo fail2ban-client set sshd unbanip x.x.x.x
```

### Ver IPs bloqueados

```bash
sudo fail2ban-client status sshd
```

### Desbloquear todos os IPs

```bash
sudo fail2ban-client unban --all
sudo systemctl restart fail2ban
```



## Logs importantes

| Ficheiro                    | Descrição                       |
| --------------------------- | ------------------------------- |
| `/var/log/fail2ban.log`     | Logs do Fail2ban                |
| `/var/log/import-ip-bl.log` | Logs da importação da blocklist |


<div align="right">
Source: https://github.com/runtechx/
</div>

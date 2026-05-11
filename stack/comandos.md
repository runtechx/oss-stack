
## [Zabbix](https://www.zabbix.com/) 
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/zabbix_al10.sh -o zabbix.sh && bash zabbix.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-zabbix.log
```

## Passbolt
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/passbolt_al10.sh -o passbolt.sh && bash passbolt.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-passbolt.log
```


## FreeIPA
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/freeipa_al10.sh -o freeipa.sh && bash freeipa.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-freeipa.log
```
> [!WARNING]
> 1. A máquina onde será instalado o FreeIPA deve possuir no mínimo **4 GB de RAM**, de forma a garantir que a instalação decorra sem falhas.
> 2. Instalar em VM e não em LXC (Linux Containers) por não suportar chrony
> 3. Utilize sempre o **FQDN (Fully Qualified Domain Name)** para aceder ao servidor através do navegador. Caso o registo DNS ainda não esteja configurado, adicione manualmente a entrada no ficheiro `hosts` do seu computador.


## Keycloak
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/keycloak_al10.sh -o keycloak.sh && bash keycloak.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-keycloak.log
```


## OpenCloud
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/opencloud_al10.sh -o opencloud.sh && bash opencloud.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-opencloud.log
```
> [!WARNING]
> 1. Após abrir o OpenCloud no navegador, aguarde alguns minutos para que o carregamento inicial seja concluído por completo.
> 2. Utilize o FQDN para aceder ao servidor via navegador. Caso o registo DNS ainda não esteja configurado, adicione a entrada manualmente no ficheiro `hosts` do seu computador.


## GLPI
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/glpi_al10.sh -o glpi.sh && bash glpi.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-glpi.log
```


## Wordpress
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/wordpress_al10.sh -o wordpress.sh && bash wordpress.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-wordpress.log
```

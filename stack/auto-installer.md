<div align="right">

[Início](/README.md) |  [OpenFirst](/OPENFIRST.md) |
[Stack](/stack/stack.md) |
[Guias](/guias/guides.md) |
[Labs](/labs/labs.md) |
[Comandos](/stack/auto-installer.md)

&nbsp;
&nbsp;
</div>


# Auto-Instaladores

>[!TIP]
>**Instalação rápida (sem docker)**
>
>Instale diretamente numa instalação nova do AlmaLinux 10
>Para rede lentas corra antes:
>```bash
># Increase DNF timeout and retries for slow networks
>cat >> /etc/dnf/dnf.conf << 'EOF'
>timeout=120
>retries=10
>minrate=100
>EOF
>```

## [Zabbix](https://www.zabbix.com/) 

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/zabbix_al10.sh -o zabbix.sh && bash zabbix.sh
```
Log
```bash
tail -f /var/log/deploy-zabbix.log
```


## [Wazuh](https://wazuh.com/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/wazuh_al10.sh -o wazuh.sh && bash wazuh.sh
```
Log
```bash
tail -f /var/log/deploy-wazuh.log
```
>[!IMPORTANT]
>A sua VM deve ter o **mínimo recomendado é 4 GB de memória RAM**, para uma configuração de nó único (até 25 agentes).
>
>Para ambientes com mais de 100 endpoints, recomenda-se 16 GB de memória RAM.

## [Passbolt](https://www.passbolt.com/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/passbolt_al10.sh -o passbolt.sh && bash passbolt.sh
```
Log
```bash
tail -f /var/log/deploy-passbolt.log
```


## [FreeIPA](https://www.freeipa.org/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/freeipa_al10.sh -o freeipa.sh && bash freeipa.sh
```
Log
```bash
tail -f /var/log/deploy-freeipa.log
```
> [!WARNING]
> 1. A máquina onde será instalado o FreeIPA deve possuir no mínimo **4 GB de RAM**, de forma a garantir que a instalação decorra sem falhas.
> 2. Instalar em VM e não em LXC (Linux Containers) por não suportar chrony
> 3. Utilize sempre o **FQDN (Fully Qualified Domain Name)** para aceder ao servidor através do navegador. Caso o registo DNS ainda não esteja configurado, adicione manualmente a entrada no ficheiro `hosts` do seu computador.


## [Keycloak](https://www.keycloak.org/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/keycloak_al10.sh -o keycloak.sh && bash keycloak.sh
```
Log
```bash
tail -f /var/log/deploy-keycloak.log
```


## [OpenCloud](https://opencloud.eu/en)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/opencloud_al10.sh -o opencloud.sh && bash opencloud.sh
```
Log
```bash
tail -f /var/log/deploy-opencloud.log
```
> [!WARNING]
> 1. Após abrir o OpenCloud no navegador, aguarde alguns minutos para que o carregamento inicial seja concluído por completo.
> 2. Utilize o FQDN para aceder ao servidor via navegador. Caso o registo DNS ainda não esteja configurado, adicione a entrada manualmente no ficheiro `hosts` do seu computador.


## [GLPI](https://www.glpi-project.org/en/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/glpi_al10.sh -o glpi.sh && bash glpi.sh
```
Log
```bash
tail -f /var/log/deploy-glpi.log
```


## [Wordpress](https://wordpress.com/)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/wordpress_al10.sh -o wordpress.sh && bash wordpress.sh
```
Log
```bash
tail -f /var/log/deploy-wordpress.log
```

## [Bookstack](https://netboxlabs.com/products/free-netbox-cloud)

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/bookstack_al10.sh -o bookstack.sh && bash bookstack.sh
```
Log
```bash
tail -f /var/log/deploy-bookstack.log
```

## [Netbox](https://netboxlabs.com/products/free-netbox-cloud/) 

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/stack/scripts/netbox_al10.sh -o netbox.sh && bash netbox.sh
```
Log
```bash
tail -f /var/log/deploy-netbox.log
```



&nbsp;
<div align="right">
Source: https://github.com/runtechx/
</div>

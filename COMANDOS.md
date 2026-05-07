


## Zabbix
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/scripts/zabbix_al10.sh -o zabbix.sh && bash zabbix.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-zabbix.log
```

## OpenCloud
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/scripts/opencloud_al10.sh -o opencloud.sh && bash opencloud.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-opencloud.log
```
> [!NOTE]
> 1. Após abrir o OpenCloud no navegador, aguarde alguns minutos para que o carregamento inicial seja concluído por completo.
> 2. Utilize o FQDN para aceder ao servidor via navegador. Caso o registo DNS ainda não esteja configurado, adicione a entrada manualmente no ficheiro `hosts` do seu computador.
 

## GLPI (NOK)
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/scripts/glpi_al10.sh -o glpi.sh && bash glpi.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-glpi.log
```


## Wordpress
one-liner

```bash
curl -fsSL https://raw.githubusercontent.com/runtechx/OpenFirst/master/scripts/wordpress_al10.sh -o wordpress.sh && bash wordpress.sh
```
Acompanhar o log da instalação (executar em outro terminal)
```bash
tail -f /var/log/deploy-wordpress.log
```

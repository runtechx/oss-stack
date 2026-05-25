
## Formas de ter acesso ao shell

**Exercício 1**
- Loga-te no servidor 2 usando ssh
```bash
vagrant ssh srv2
```
Quando estiveres dentro vais ver `[vagrant@srvs ~]$` e corre o comando a baixo
```bash
sudo ip a
```
Procura pela placa 2 e parte onde diz ***inet*** e a seguir o IP, neste caso 172.28.78.13/20

```bash
 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:15:5d:64:6f:08 brd ff:ff:ff:ff:ff:ff
    altname enx00155d646f08
    inet 172.28.78.13/20 brd 172.28.79.255 scope global dynamic noprefixroute eth0
       valid_lft 86210sec preferred_lft 86210sec
    inet6 fe80::215:5dff:fe64:6f08/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

**Exercício 2**
- Loga-te no servidor 2 para usar o terminal a partir da parte grafica
apartir de um terminal (Admin) cole o comando a baixo para abrir o Gestor Hyper-v 
```bash

```
Deia dois cliques no servidor 2, maximize a janela e faça o login com a conta `labuser` e senha `student123!`



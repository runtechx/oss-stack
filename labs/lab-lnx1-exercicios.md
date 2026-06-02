>[!IMPORTANT]
>Caso não tenha feito a configuração inicial para execução dos laboratórios
>deve iniciar em guias/
>
>[preparar-maq-virtualbox-para-labs](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-virtualbox-para-labs.md) ou [preparar-maq-hyperv-para-labs](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md)

## 1. Baixar o laboratório

Executar o PowerShell como Administrador:

**Remover Labs antigos**

```powershell
cd C:\RTLabs
vagrant destroy -f
```

**Para Hyper-V**

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx1-hyperv-vagrantfile" `
  -OutFile "Vagrantfile"
```

**Para Virtualbox**

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx1-virtualbox-vagrantfile" `
  -OutFile "Vagrantfile"
```

## 2. Levantar o laboratório

Levantar as VMs

```powershell
cd C:\RTLabs\
vagrant up
```

Verificar o estado das VMs

```powershell
cd C:\RTLabs\
vagrant status
```

Resultado esperado:

```text
Current machine states:

srv1                      running (hyperv)
srv2                      running (hyperv)
```

## Formas de ter acesso ao shell

**Exercício 1** - Encontrar o IP do servidor 2 (Disponível apenas em ambiente de laboratório)

Abra o terminal(Admin) do windows, clicando por cima do botao do windows com o botao esquerdo do rato para abrir o menu de contexto e escolher terminal(Admin)

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

**Exercício 2** - Logar-se no servidor 2 usando ssh

Agora que temos o IP abra uma outra aba no terminal(Admin) windows e corra

```bash
ssh labuser@172.28.78.13
```
>[!NOTE]
> substituir o IP pelo o IP que apareceu em sua maquina e depois pressione enter

 Resultado esperado:
 
 ```bash
The authenticity of host '172.28.78.13 (172.28.78.13)' can't be established.
ED25519 key fingerprint is SHA256:QqX4yqI/dJIAU+M2D3uWItJY/YQ0LAiBvtAwAqKvWxs.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
escreva yes

 ```bash
labuser@172.28.78.13's password:
```
insira Qwerty456#

 ```bash
labuser@172.28.78.13's password:
Web console: https://srv2:9090/ or https://172.28.78.13:9090/

Last failed login: Mon May 25 21:36:54 UTC 2026 from 172.28.64.1 on ssh:notty
There was 1 failed login attempt since the last successful login.
labuser@srv2:~$
```

Corra 
 ```bash
htop 
```
Deia uma vista de olhos no programa aberto, tente responder estás perguntas;
* Quantos vcpu vês ? ____
* Quanto memória está a ser consumida ? ____
* A quanto tempo a VM está ligada ? ____

A seguir pressione Q para fechar o programa htop e escreva exit para sair da ligacao ssh.


**Exercício 2** - Logar-se no servidor 2 apartir da consola

**Hyper-v**

No terminal(Admin) do windows cole o comando a baixo para abrir o Gestor Hyper-v 
```bash
virtmgmt.msc
```
A seguir selecione o srv2, clique a direita connect ou conectar, maximize a janela e faça o login com a conta `labuser` e senha `Qwerty456#`

**Virtualbox**
No terminal(Admin) do windows cole o comando a baixo para abrir o Gestor Hyper-v 
```bash
"C:\Program Files\Oracle\VirtualBox\VirtualBox.exe"
```
A seguir selecione o srv2, clique duas vezes por cima da janela do srv2, maximize a janela e faça o login com a conta `labuser` e senha `Qwerty456#`


**Exercício 3** - Alternar entre as 

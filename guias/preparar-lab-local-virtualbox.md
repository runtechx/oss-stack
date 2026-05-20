## O que é o VirtualBox?

O **VirtualBox** é um programa de virtualização — permite criar e correr **máquinas virtuais (VMs)** no teu computador. Uma máquina virtual é como um computador dentro do computador: tem o seu próprio sistema operativo, disco, memória e rede, mas partilha o hardware físico da tua máquina.

```
┌─────────────────────────────────┐
│        O teu computador         │
│  ┌──────────┐  ┌──────────┐    │
│  │  VM 1    │  │  VM 2    │    │
│  │ AlmaLinux│  │ Ubuntu   │    │
│  └──────────┘  └──────────┘    │
│         VirtualBox              │
│    Windows / macOS / Linux      │
└─────────────────────────────────┘
```

Podes usar o VirtualBox para testar sistemas operativos, simular servidores, ou criar ambientes isolados — sem precisar de hardware adicional.


## O que é o Vagrant?

O **Vagrant** é uma ferramenta de automação que gere máquinas virtuais através de um simples ficheiro de texto chamado `Vagrantfile`. Em vez de criar e configurar VMs manualmente pelo VirtualBox, o Vagrant faz tudo isso automaticamente com um comando.

```
Vagrantfile  →  vagrant up  →  VM pronta
```

O Vagrant não substitui o VirtualBox — ele **fala com o VirtualBox** por baixo para criar e gerir as VMs.


## Como funcionam juntos?

```
┌──────────────┐        cria/gere        ┌───────────────┐
│   Vagrant    │  ──────────────────────▶ │  VirtualBox   │
│ (automação)  │                          │ (virtualização│
│  Vagrantfile │                          │    da VM)     │
└──────────────┘                          └───────────────┘
```

| | VirtualBox | Vagrant |
|---|---|---|
| O que é | Hipervisor (cria VMs) | Gestor de VMs (automação) |
| Interface | GUI + linha de comandos | Linha de comandos |
| Configuração | Manual (cliques) | Ficheiro de texto (`Vagrantfile`) |
| Uso típico | Usar VMs individualmente | Labs, ambientes reproduzíveis |


## Porquê usar os dois juntos?

Sem Vagrant, tens de criar cada VM manualmente no VirtualBox — escolher ISO, configurar disco, rede, memória, instalar o SO, etc. Com Vagrant, defines tudo num `Vagrantfile` e corres `vagrant up`. Em segundos tens uma VM pronta, e qualquer pessoa com o mesmo ficheiro obtém exactamente o mesmo ambiente.

## Instalar VirtualBox + Vagrant
**Metodo 1 - Usando o winget**
Virtualbox
```Powershell
winget install Oracle.VirtualBox
```
Vagrant
```Powershell
winget install HashiCorp.Vagrant
```
**Metodo 2 - Baixar e Instalar manualmente**
Virtualbox
```Powershell 
$vboxVersion = (Invoke-RestMethod "https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT").Trim()
$dirListing = Invoke-WebRequest "https://download.virtualbox.org/virtualbox/$vboxVersion/"
$exeFile = ($dirListing.Links.href | Where-Object { $_ -match "VirtualBox-.*-Win\.exe$" })[0]
$vboxUrl = "https://download.virtualbox.org/virtualbox/$vboxVersion/$exeFile"
Invoke-WebRequest -Uri $vboxUrl -OutFile "$env:TEMP\VirtualBox.exe"
Start-Process "$env:TEMP\VirtualBox.exe" -Wait
```
Vagrant
```Powershell
$vagrantVersion = (Invoke-RestMethod "https://checkpoint-api.hashicorp.com/v1/check/vagrant").current_version
$vagrantUrl = "https://releases.hashicorp.com/vagrant/$vagrantVersion/vagrant_${vagrantVersion}_windows_amd64.msi"
Invoke-WebRequest -Uri $vagrantUrl -OutFile "$env:TEMP\Vagrant.msi"
Start-Process msiexec.exe -ArgumentList "/i $env:TEMP\Vagrant.msi" -Wait
```
Vagrant-vbguest
```Powershell
vagrant plugin install vagrant-vbguest
```
## Prep do ambiente 
Criar a pasta `RTLabs`
```Powershell
New-Item -Path "C:\RTLabs" -ItemType Directory -Force
New-Item -Path "C:\RTLabs\shared" -ItemType Directory -Force
cd C:\RTLabs
```
## Criar o primeiro LAB 
```Powershell
New-Item -Path "C:\RTLabs\almalinux" -ItemType Directory -Force
cd C:\RTLabs\almalinux
```
Baixar o Ficheiro vagrantfile 
```Powershell
baixar ficheiro
```

Iniciar o lab:
```Powershell
cd C:\RTLabs\almalinux
vagrant up
```
Aceder à VM:
```Powershell
vagrant ssh
```
Parar / Destruir o lab:
```Powershell
vagrant halt      # parar
vagrant destroy   # destruir
```

ver [AlmaLinux-lab-l01]() na pasta `\labs\almalinux\`

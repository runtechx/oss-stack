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

Abra o PowerShell como Administrador e execute:

```Powershell
bcdedit /set hypervisorlaunchtype off
```

Depois desative funcionalidades do Windows:

```Powershell
# Desativar o hypervisor do boot
bcdedit /set hypervisorlaunchtype off
# Desativar Virtual Machine Platform
dism /online /disable-feature /featurename:VirtualMachinePlatform /norestart
# Desativar Windows Hypervisor Platform
dism /online /disable-feature /featurename:HypervisorPlatform /norestart
# Desativar WSL2
dism /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
# Desativar Sandbox
dism /online /disable-feature /featurename:Containers-DisposableClientVM /norestart
dism.exe /Online /Disable-Feature:Containers
```

Muito importante.

Reiniciar

Depois do reboot, confirma:

```powershell
systeminfo | findstr /i "Hyper-V"
```

O correto é NÃO aparecer:

```text
A hypervisor has been detected
```

"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" list hostinfo


**Metodo 1 - Usando o winget**

Abra o terminal em modo admin

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

## Prep do ambiente 

Feche o PowerShell e abra novamente, depois teste
```Powershell
vagrant --version
```
Vagrant-vbguest

```Powershell
vagrant plugin install vagrant-vbguest
```

Criar a pasta `RTLabs`
```Powershell
New-Item -Path "C:\RTLabs" -ItemType Directory -Force
cd C:\RTLabs
```
## Criar o primeiro LAB 

Abra um cmd em modo normal 

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
```

Depois execute:

```powershell
vagrant up
```

Para entrar na VM:

```powershell
vagrant ssh
```

Para verificar o estado:

```powershell
vagrant status
```

Para desligar:

```powershell
vagrant halt
```

Para destruir a VM:

```powershell
vagrant destroy -f
```
>[!NOTE]
>Apenas a VM clonada é removida — a box original/base continua armazenada localmente pelo Vagrant.

Ver boxes instaladas:
```powershell
vagrant box list
```

Remover a box:
```powershell
vagrant box remove almalinux/10
```

Se houver várias versões:
```powershell
vagrant box remove almalinux/9 --all```
```

---

Hyper-v+Vagrant


https://www.youtube.com/watch?v=HNsdfTRfnig
https://medium.com/credera-engineering/vagrant-usinghyper-v-4e86f72acc3b
https://developer.hashicorp.com/vagrant/docs/providers/hyperv

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

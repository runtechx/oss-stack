# Preparar a sua máquina para correr labs (VirtualBox+Vagrant)

## O que é o VirtualBox?

O **VirtualBox** é um hipervisor open source da Oracle, usado para virtualização local em ambientes pessoais e de laboratório.

```
┌──────────────────────────────────────┐
│          Windows / Linux            │
│  ┌────────── VirtualBox ──────────┐  │
│  │  ┌────────┐  ┌────────┐       │  │
│  │  │ Linux  │  │ Windows│       │  │
│  │  │ VM     │  │ VM     │       │  │
│  │  └────────┘  └────────┘       │  │
│  └───────────────────────────────┘  │
└──────────────────────────────────────┘
```

## O que é o Vagrant?

O **Vagrant** é o orquestrador de máquinas virtuais.

Ele funciona com ambos:

* Hyper-V
* VirtualBox

```
Vagrantfile → vagrant up → VirtualBox → VM pronta
```

## Diferença importante (VirtualBox vs Hyper-V)

|                         | VirtualBox | Hyper-V                |
| ----------------------- | ---------- | ---------------------- |
| Tipo                    | Terceiros  | Nativo Windows         |
| Performance             | Boa        | Melhor em Windows      |
| Integração              | Média      | Excelente              |
| Compatibilidade Vagrant | Sim        | Sim (provider oficial) |

>[!NOTE]
> Os comandos para Hyper-V devem ser executados no PowerShell como Administrador.
> No VirtualBox, apenas a instalação é administrativa; a criação de VMs não requer execução como Administrador.

## Pré-requisitos (VirtualBox)

>[!IMPORTANT]
>Desativar Hyper-V
>
>```powershell
>Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
>```
> E
>```powershell
># Desativar o hypervisor do boot
>bcdedit /set hypervisorlaunchtype off
># Desativar Virtual Machine Platform
>dism /online /disable-feature /featurename:VirtualMachinePlatform /norestart
># Desativar Windows Hypervisor Platform
>dism /online /disable-feature /featurename:HypervisorPlatform /norestart
># Desativar WSL2
>dism /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /norestart
># Desativar Sandbox
>dism /online /disable-feature /featurename:Containers-DisposableClientVM /norestart
>dism.exe /Online /Disable-Feature:Containers
>```
> (Reboot necessário)

### 1. Instalar VirtualBox

**Método rápido (winget)**

```powershell
winget install Oracle.VirtualBox
```
**Método manual**

```Powershell 
$vboxVersion = (Invoke-RestMethod "https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT").Trim()
$dirListing = Invoke-WebRequest "https://download.virtualbox.org/virtualbox/$vboxVersion/"
$exeFile = ($dirListing.Links.href | Where-Object { $_ -match "VirtualBox-.*-Win\.exe$" })[0]
$vboxUrl = "https://download.virtualbox.org/virtualbox/$vboxVersion/$exeFile"
Invoke-WebRequest -Uri $vboxUrl -OutFile "$env:TEMP\VirtualBox.exe"
Start-Process "$env:TEMP\VirtualBox.exe" -Wait
```

### 2. Instalar Vagrant 

**Método rápido (winget)**

```powershell
winget install HashiCorp.Vagrant
```

**Método manual**

```powershell
$vagrantVersion = (Invoke-RestMethod "https://checkpoint-api.hashicorp.com/v1/check/vagrant").current_version
$vagrantUrl = "https://releases.hashicorp.com/vagrant/$vagrantVersion/vagrant_${vagrantVersion}_windows_amd64.msi"
Invoke-WebRequest -Uri $vagrantUrl -OutFile "$env:TEMP\Vagrant.msi"
Start-Process msiexec.exe -ArgumentList "/i $env:TEMP\Vagrant.msi" -Wait
```
**Verificar instalação**

```powershell
vagrant --version
```

### 3. Criar diretório de trabalho

Criar pasta da VM controladora:

```powershell
New-Item -Path "C:\RTLabs" -ItemType Directory -Force
cd C:\RTLabs
```

Alterar o caminho dos ficheiros do Hyper-V:

```powershell
Import-Module Hyper-V
```

```powershell
New-Item -ItemType Directory -Force -Path "C:\RTLabs\VMs"
New-Item -ItemType Directory -Force -Path "C:\RTLabs\Disks"

Set-VMHost `
  -VirtualMachinePath "C:\RTLabs\VMs" `
  -VirtualHardDiskPath "C:\RTLabs\Disks"
```

```powershell
Get-VMHost | Select-Object VirtualMachinePath, VirtualHardDiskPath
```

>[!TIP]
>Agora você está pronto para começar a baixar os labs.
>
>Abra em /guias o ficheiro [como-usar-os-labs-locais.md](/guias/como-usar-os-labs-locais.md)



<div align="right">
Source: https://github.com/runtechx/
</div>


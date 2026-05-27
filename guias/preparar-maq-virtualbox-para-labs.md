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
Vagrantfile → vagrant up → Hyper-V / VirtualBox → VM pronta
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
>bcdedit /set hypervisorlaunchtype off
>```
> (Reboot necessário)

### 1. Instalar VirtualBox

**Método rápido (winget)**

```powershell
winget install Oracle.VirtualBox
```

### 2. Instalar Vagrant (igual ao Hyper-V)

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

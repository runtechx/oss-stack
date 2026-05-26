# Preparar a sua maquina para correr labs (Hyperv+Vagrant)

## O que é o Hyper-V?

O **Hyper-V** é o hipervisor nativo da Microsoft — permite criar e gerir máquinas virtuais diretamente no Windows.

Ao contrário do VirtualBox, o Hyper-V é integrado no sistema operativo e é utilizado em ambientes mais corporativos.

```
┌──────────────────────────────────────┐
│          Windows 10 / 11            │
│  ┌──────────── Hyper-V ────────────┐ │
│  │  ┌────────┐  ┌────────┐        │ │
│  │  │ Alma   │  │ Ubuntu │        │ │
│  │  │ Linux  │  │ Server │        │ │
│  │  └────────┘  └────────┘        │ │
│  └─────────────────────────────────┘ │
└──────────────────────────────────────┘
```

## O que é o Vagrant (com Hyper-V)?

O **Vagrant** continua a ser o orquestrador de máquinas virtuais.

A diferença é que agora comunica com o **Hyper-V em vez do VirtualBox**.

```
Vagrantfile → vagrant up → Hyper-V → VM pronta
```

## Diferença importante (VirtualBox vs Hyper-V)

|                         | VirtualBox | Hyper-V                |
| ----------------------- | ---------- | ---------------------- |
| Tipo                    | Terceiros  | Nativo Windows         |
| Performance             | Boa        | Melhor em Windows      |
| Integração              | Média      | Excelente              |
| Compatibilidade Vagrant | Sim        | Sim (provider oficial) |

> Nota
> Os comandos para Hyper-V devem ser executados no PowerShell como Administrador.
> No VirtualBox, apenas a instalação é administrativa; a criação de VMs não requer execução como Administrador.

## Pré-requisitos

### 1. Ativar Hyper-V

Executar PowerShell como Administrador:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
```

### 2. Instalar Vagrant

Executar PowerShell como Administrador:

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

Reiniciar o computador.

### 3. Confirmar Hyper-V ativo

```powershell
systeminfo | findstr /i "hyper-v"
```

Se estiver ativo, aparece:

```
A hypervisor has been detected
```

### 4. Criar diretório de trabalho

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

Criar Rede NAT 

```powershell
$SwitchName = "SwitchNAT"
$NatName    = "NetNAT"

# Create switch if it doesn't exist
if (-not (Get-VMSwitch -Name $SwitchName -ErrorAction SilentlyContinue)) {
    New-VMSwitch -SwitchName $SwitchName -SwitchType Internal
}

# Get interface index automatically
$ifIndex = (Get-NetAdapter |
    Where-Object Name -Like "*$SwitchName*").ifIndex

# Configure gateway IP
if (-not (Get-NetIPAddress -InterfaceIndex $ifIndex -ErrorAction SilentlyContinue |
          Where-Object IPAddress -eq "192.168.51.1")) {

    New-NetIPAddress `
      -IPAddress 192.168.51.1 `
      -PrefixLength 24 `
      -InterfaceIndex $ifIndex
}

# Create NAT network if it doesn't exist
if (-not (Get-NetNat -Name $NatName -ErrorAction SilentlyContinue)) {

    New-NetNat `
      -Name $NatName `
      -InternalIPInterfaceAddressPrefix "192.168.51.0/24"
}

Write-Host "Hyper-V lab networking configured successfully."
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

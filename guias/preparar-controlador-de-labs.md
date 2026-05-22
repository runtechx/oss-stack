#  Preparara o Controlador de Laboratorios com Hyper-V + Vagrant (Windows)

## O que é o Hyper-V?

O **Hyper-V** é o hipervisor nativo da Microsoft — permite criar e gerir máquinas virtuais diretamente no Windows.

Ao contrário do VirtualBox, o Hyper-V é integrado ao sistema operativo e usado em ambientes mais corporativos.

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

O **Vagrant** continua a ser o orquestrador de VMs.

A diferença é que agora ele fala com o **Hyper-V em vez do VirtualBox**.

```
Vagrantfile → vagrant up → Hyper-V → VM pronta
```


# Diferença importante (VirtualBox vs Hyper-V)

|                         | VirtualBox | Hyper-V                |
| ----------------------- | ---------- | ---------------------- |
| Tipo                    | Terceiros  | Nativo Windows         |
| Performance             | Boa        | Melhor em Windows      |
| Integração              | Média      | Excelente              |
| Compatibilidade Vagrant | Sim        | Sim (provider oficial) |

# Pré-requisitos

## 1. Ativar Hyper-V

Executar PowerShell como Administrador:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

## 2. Instalar Vagrant

**Método rápido (winget)**

```powershell
winget install HashiCorp.Vagrant
```

**Método manual**
```Powershell
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

## 3. Confirmar Hyper-V ativo

```powershell
systeminfo | findstr /i "hyper-v"
```

Se estiver ativo, vais ver algo como:

```
A hypervisor has been detected
```






# Preparar o controlador de laboratórios com Hyper-V e Vagrant (Windows)

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
New-Item -Path "controladora" -ItemType Directory -Force
cd controlador
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

## VM Controladora de Laboratórios (Arquitetura de Infraestrutura)

Depois de compreender as diferenças entre VirtualBox e Hyper-V, evoluímos o conceito para uma abordagem de **Infrastructure as Code (IaC)**, permitindo a criação e gestão automatizada de laboratórios em ambiente centralizado.

Neste modelo, os laboratórios não são criados no PC local. Em vez disso, toda a infraestrutura é provisionada diretamente num host Proxmox, através da API, utilizando uma VM controladora de laboratórios (VM-Ctrl).

O PC local apenas atua como ponto de apoio para gestão inicial e acesso, enquanto a VM-Ctrl centraliza toda a automação.

## O papel da VM Controladora de Laboratórios

A VM Controladora de Laboratórios não é uma máquina de laboratório.

Ela é o cérebro da infraestrutura.

É responsável por toda a orquestração, automação e padronização do ambiente.

## Responsabilidades principais

### 1. Orquestração de laboratórios

A VM Controladora de Laboratórios cria, gere e elimina ambientes completos no Proxmox de forma automatizada.

Exemplos:

* Lab 01 → 3 VMs (Web + DB + Client)
* Lab 02 → Cluster Linux
* Lab 03 → Ambiente de testes e integração

### Fluxo de comunicação com o Proxmox

A interação segue um modelo automatizado baseado em IaC:

Controladora → Terraform → Proxmox API → Provisionamento das VMs

Isto garante:

* Criação consistente de ambientes
* Redução de erros manuais
* Automação do ciclo de vida dos laboratórios

## Padronização dos laboratórios

Cada laboratório deixa de ser configurado manualmente e passa a ser definido como código.

Exemplos de templates:

* lab-web-stack.tf → stack web (frontend + backend + DB)
* lab-linux-basic.tf → máquinas Linux para treino básico
* lab-monitoring.tf → ambiente com métricas e observabilidade

## Benefícios da arquitetura

* Escalabilidade: criação de dezenas de laboratórios rapidamente
* Consistência: ambientes sempre iguais
* Automação total: sem intervenção manual no Proxmox
* Reprodutibilidade: laboratórios versionados em Git

## 1. Criar a VM controladora usando Vagrantfile no Hyper-V

Executar PowerShell como Administrador:

Criar o ficheiro Vagrantfile:

```powershell
cd C:\RTLabs\controladora
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/hyperv-Vagrantfile" `
  -OutFile "Vagrantfile"
ls
```

Criar a VM:

```powershell
vagrant up
```

> Nota

1. Caso ocorra erro de Execution Policy, executar:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
e a seguir voltar a correr o `vagrant up` dentro da pasta `C:\RTLabs\controladora`

2. Se existir utilizador normal e administrativo, abrir uma nova sessão no terminal como Administrador e executar:

```powershell
virtmgmt.msc
```

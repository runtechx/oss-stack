#  Preparar o controlador de laboratórios com Hyper-V e Vagrant (Windows).

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
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
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

## 4. Criar diretório de trabalho

```powershell
New-Item -Path "C:\RTLabs" -ItemType Directory -Force
cd C:\RTLabs
New-Item -Path "controlador-rtlabs" -ItemType Directory -Force
cd controlador-rtlabs
```


# VM Controladora de Laboratórios (Arquitetura de Infraestrutura)

Depois de compreender a diferença entre VirtualBox e Hyper-V, vamos evoluir o conceito para infraestrutura como codigo para criar os varios laboratorios 
Neste modelo, não crias os laboratorios no teu PC local mas sim no proxmox host via API usando a VM controlador de laboratorios.
Em vez disso, ele apenas executa uma VM Controladora (VM-Ctrl), que centraliza toda a automação e comunicação com o cluster Proxmox.

O papel da VM-Ctrl

A VM-Ctrl não é uma VM de laboratório.

Ela é o cérebro da infraestrutura.

🧠 Responsabilidades principais:
⚙️ 1. Orquestração de laboratórios

Cria, destrói e gere VMs no Proxmox:

Lab 01 → 3 VMs (web + db + client)
Lab 02 → cluster Linux
Lab 03 → ambiente de testes

Comunicação com Proxmox (Exemplo lógico:)
 VM-Ctrl → Terraform → Proxmox API → VM do laboratorio criada

Padronização dos laboratórios

Cada laboratório deixa de ser “manual”.

Passa a ser:

lab-web-stack.tf
lab-linux-basic.tf
lab-monitoring.tf



## 1. Criar Vagrantfile no Hyper-V, para a criar C

Cria um ficheiro chamado `Vagrantfile`:






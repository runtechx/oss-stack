> [!IMPORTANT]
> Antes de prosseguir, é necessário preparar a máquina que será utilizada para os laboratórios.
>
> Siga primeiro o guia [preparar-maq-hyperv-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md) ou [preparar-maq-virtualbox-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-virtualbox-para-labs.md)
>
> Apenas depois de concluir essa preparação deverá continuar com a criação dos laboratórios.


# Como usar os laboratórios locais

Os laboratórios encontram-se no GitHub em [runtechx/OpenFirst/labs](https://github.com/runtechx/OpenFirst/tree/main/labs) e, normalmente, incluem:

1. Um ficheiro `Vagrantfile` para laboratórios locais ou `.tf` para laboratórios hospedados
2. Um ficheiro de exercícios em Markdown
3. Em alguns casos, um diagrama para auxiliar na compreensão do ambiente e da estrutura do laboratório

Exemplo ver os seguintes ficheiros em `/labs`:

1. `lab-lnx0-vagrantfile`
2. `lab-lnx0-exercicios.md`


# Requisitos

- Hyper-V ativo ou Virtualbox instalado
- Vagrant instalado
- Ligação à Internet durante a fase inicial

Recursos mínimos recomendados:

- 16 GB de RAM
- 4 CPUs
- 100 GB livres em disco



# 1. Baixar o laboratório

Executar o PowerShell como Administrador:

** Para Hyper-V**

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-hyperv-vagrantfile" `
  -OutFile "Vagrantfile"
```

** Para Virtualbox**

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-virtualbox-vagrantfile" `
  -OutFile "Vagrantfile"
```

# 2. Levantar o laboratório

## 2.1 — Verificar o estado das VMs

```powershell
cd C:\RTLabs\
vagrant status
```

Resultado esperado:

```text
Current machine states:

test-srv                  not_created (hyperv)
```

> [!TIP]
> Isto significa que a máquina virtual ainda não foi criada.



## 2.2 — Criar/Arrancar as máquinas virtuais

```powershell
cd C:\RTLabs\
vagrant up
```


## 2.3 — Verificar novamente o estado da VM

Tente novamente executar o comando `vagrant status`.

Resultado esperado:

```text
Current machine states:

test-srv                  running (hyperv)
```


# 3. Operar o servidor do laboratório

## 3.1 — Entrar na VM

```powershell
cd C:\RTLabs\
vagrant ssh test-srv
```

> [!NOTE]
> Se o laboratório tiver apenas uma VM, não é necessário especificar o nome da máquina virtual nos comandos do Vagrant.



## 3.2 — Executar comandos na VM

```bash
top
```

Pressione `Q` para sair.

```bash
sudo passwd root
```
> aproveite alterar a senha do root

```bash
sudo dnf -y update
```
> um update ajuda a VM a estar fresca


```bash
sudo shutdown now
```


## 3.5 — Criar Snapshot da VM
```powershell
cd C:\RTLabs\
vagrant snapshot save test-srv base
```

## 3.6 — Listar Snapshot
```powershell
cd C:\RTLabs\
vagrant snapshot list test-srv
```

## 3.7 - Restauro de Snapshot 
```powershell
cd C:\RTLabs\
vagrant snapshot restore test-srv base
```

# 4. Resumo de operações do laboratório

>[!IMPORTANT]
> Comandos vagrant devem ser corridos dentro da pasta  `C:\RTLabs\ `

| Operação                  | Comando                                  | Descrição                                        |
| ------------------------- | ---------------------------------------- | ------------------------------------------------ |
| Verificar estado das VMs  | `vagrant status`                         | Mostra o estado atual das máquinas virtuais      |
| Criar/Iniciar laboratório | `vagrant up`                             | Cria e arranca as VMs definidas no `Vagrantfile` |
| Iniciar VMs em paralelo   | `vagrant up --parallel`                  | Arranca múltiplas VMs ao mesmo tempo             |
| Entrar na VM              | `vagrant ssh test-srv`                   | Abre sessão SSH na VM                            |
| Sair da VM                | `exit`                                   | Fecha a sessão SSH                               |
| Desligar VM               | `vagrant halt test-srv`                  | Desliga a VM de forma segura                     |
| Reiniciar VM              | `vagrant reload test-srv`                | Reinicia a VM                                    |
| Recarregar configuração   | `vagrant reload --provision`             | Reinicia e reaplica provisionamento              |
| Suspender VM              | `vagrant suspend test-srv`               | Coloca a VM em estado suspenso                   |
| Retomar VM suspensa       | `vagrant resume test-srv`                | Retoma VM suspensa                               |
| Criar snapshot            | `vagrant snapshot save test-srv base`    | Cria snapshot chamado `base`                     |
| Listar snapshots          | `vagrant snapshot list test-srv`         | Lista snapshots existentes                       |
| Restaurar snapshot        | `vagrant snapshot restore test-srv base` | Restaura snapshot `base`                         |
| Apagar snapshot           | `vagrant snapshot delete test-srv base`  | Remove snapshot                                  |
| Ver logs SSH              | `vagrant ssh-config`                     | Mostra configuração SSH da VM                    |
| Ver boxes instaladas      | `vagrant box list`                       | Lista boxes instaladas localmente                |
| Remover box               | `vagrant box remove almalinux/10`        | Remove box do sistema                            |
| Destruir laboratório      | `vagrant destroy -f`                     | Remove todas as VMs do laboratório               |
| Validar Vagrantfile       | `vagrant validate`                       | Verifica sintaxe do `Vagrantfile`                |
| Ver ajuda                 | `vagrant -h`                             | Mostra ajuda geral do Vagrant                    |
| Ver plugins               | `vagrant plugin list`                    | Lista plugins instalados                         |
| Abrir Hyper-V Manager     | `virtmgmt.msc`                           | Abre gestor gráfico do Hyper-V                   |


## Ver ajuda do Vagrant

```powershell
cd C:\RTLabs\
vagrant -h
```



<div align="right">

Fonte: https://github.com/runtechx/

</div>

> [!IMPORTANT]
> Antes de prosseguir, é necessário preparar a máquina que será utilizada para os laboratórios.
>
> Siga primeiro o guia [preparar-maq-hyperv-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md)
>
> Apenas depois de concluir essa preparação deverá continuar com a criação dos laboratórios.


# Como usar os laboratórios locais

Os laboratórios encontram-se no GitHub em [runtechx/OpenFirst/labs](https://github.com/runtechx/OpenFirst/tree/main/labs) e, normalmente, incluem:

1. Um ficheiro `Vagrantfile` para laboratórios locais ou `.tf` para laboratórios hospedados
2. Um ficheiro de exercícios em Markdown
3. Em alguns casos, um diagrama para auxiliar na compreensão do ambiente e da estrutura do laboratório

Neste exemplo serão utilizados os seguintes ficheiros:

1. `lab-lnx0-vagrantfile`
2. `lab-lnx0-exercicios.md`


# Requisitos

- Windows 11 com Hyper-V ativo
- Vagrant instalado
- Ligação à Internet durante a fase inicial

Recursos mínimos recomendados:

- 16 GB de RAM
- 4 CPUs
- 100 GB livres em disco



# 1. Baixar o laboratório

Executar o PowerShell como Administrador:

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx0-vagrantfile" `
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
ls -l /
```



## 3.3 — Sair da VM

```bash
exit
```



## 3.4 — Desligar a VM

```powershell
cd C:\RTLabs\
vagrant halt test-srv
```
## 3.5 — Criar Snapshot da VM
```powershell
cd C:\RTLabs\
vagrant snapshot save test-srv
```

## 3.6 — Listar Snapshot
```powershell
cd C:\RTLabs\
vagrant snapshot list test-srv
```

# 4. Outras operações do laboratório

## Abrir o Gestor do Hyper-V

No mesmo terminal (Administrador), execute:

```powershell
virtmgmt.msc
```

Explore a máquina virtual e analise os recursos disponíveis.



## Destruir o laboratório

```powershell
cd C:\RTLabs\
vagrant destroy -f
```

Agora remover a box 
```powershell
cd C:\RTLabs\
vagrant box list
vagrant box remove almalinux/10
```

## Apagar o snaphot

```powershell
cd C:\RTLabs\
vagrant snapshot delete test-srv
```

## Ver ajuda do Vagrant

```powershell
cd C:\RTLabs\
vagrant -h
```



<div align="right">

Fonte: https://github.com/runtechx/

</div>

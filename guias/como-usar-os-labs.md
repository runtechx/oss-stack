> [!IMPORTANT]
> Antes de prosseguir, é necessário preparar a máquina que será utilizada para os laboratórios.
>
> Siga primeiro o guia [preparar-maq-hyperv-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md)
>
> Apenas depois de concluir essa preparação deverá continuar com a criação dos laboratórios.

---

# Como usar os laboratórios

Os laboratórios encontram-se no GitHub em [runtechx/OpenFirst/labs](https://github.com/runtechx/OpenFirst/tree/main/labs) e, normalmente, possuem dois ficheiros:

1. O ficheiro `Vagrantfile` para laboratórios locais ou `.tf` para laboratórios hospedados
2. O ficheiro de exercícios em Markdown

Neste exemplo serão utilizados os seguintes ficheiros:

1. `lab-lnx1-vagrantfile`
2. `lab-lnx1-exercicios.md`

---

# Requisitos

- Windows 11 com Hyper-V ativo
- Vagrant instalado

Recursos mínimos recomendados:

- 16 GB de RAM
- 4 CPUs
- 100 GB livres em disco

---

# 1. Baixar o laboratório

Executar o PowerShell como Administrador:

```powershell
cd C:\RTLabs

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx1-vagrantfile" `
  -OutFile "Vagrantfile"
```

---

# 2. Levantar o laboratório

Criar as máquinas virtuais:

```powershell
cd C:\RTLabs\
vagrant up
```

Verificar o estado das VMs:

```powershell
cd C:\RTLabs\
vagrant status
```

Resultado esperado:

```text
Current machine states:

srv1                      running (hyperv)
srv2                      running (hyperv)
```

Entrar numa VM:

```powershell
cd C:\RTLabs\
vagrant ssh srv1
```

Desligar uma VM:

```powershell
cd C:\RTLabs\
vagrant halt srv1
```

---

# 3. Exercícios do laboratório

Aceda à pasta `labs` no GitHub e abra o ficheiro Markdown `lab-lnx1-exercicios.md`.

Link:
https://github.com/runtechx/OpenFirst/tree/main/labs

---

# 4. Outras operações do laboratório

Destruir o laboratório:

```powershell
cd C:\RTLabs\
vagrant destroy -f
```

Abrir o Gestor do Hyper-V:

```powershell
virtmgmt.msc
```

Se o laboratório tiver apenas uma VM, não é necessário especificar o nome da máquina virtual.

Entrar na VM:

```powershell
cd C:\RTLabs\
vagrant ssh
```

Desligar a VM:

```powershell
cd C:\RTLabs\
vagrant halt
```

<div align="right">
Source: https://github.com/runtechx/
</div>


> [!IMPORTANT]
> Antes de prosseguir, é necessário preparar a máquina que será utilizada para os laboratórios.
>
> Siga primeiro o guia [preparar-maq-hyperv-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md)
>
> Apenas depois de concluir essa preparação deverá continuar com a criação dos laboratórios.


## Como usar os labs

### Requisitos
- Windows 11 com Hyper-V ativo e Vagrant instalado 
- Pelo menos:
  - 16 GB RAM
  - 4 CPUs
  - 100 GB livres em disco   


### 1. Baixar o Laboratório 
Executar PowerShell como Administrador:

```bash
cd C:\RTLabs
Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx1-vagrantfile" `
  -OutFile "Vagrantfile"
```

### 2. Levantar o Laboratório

Criar as VMs:

```powershell
cd C:\RTLabs\
vagrant up
```

Para verificar o estado:

```powershell
cd C:\RTLabs\
vagrant status
```
resultado:
```bash
Current machine states:

srv1                      running (hyperv)
srv2                      running (hyperv)
```
Para entrar na VM:

```powershell
cd C:\RTLabs\
vagrant ssh srv1
```



Para desligar a VM:

```powershell
cd C:\RTLabs\
vagrant halt srv1
```

Se tiver apenas uma VM
```powershell
cd C:\RTLabs\
vagrant halt
```




### 2. Outras Operações do Laboratório


Para destruir o laboratório :

```powershell
cd C:\RTLabs\
vagrant destroy -f
```

Abrir o gestor de Hyper-V

```bash
virtmgmt.msc
```

Se o Lab tiver apenas uma VM não é preciso especificar o nome da VM

```powershell
cd C:\RTLabs\
vagrant ssh
```

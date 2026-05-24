
> [!IMPORTANT]
> Antes de prosseguir, é necessário preparar a máquina que será utilizada para os laboratórios.
>
> Siga primeiro o guia [preparar-maq-hyperv-para-labs.md](https://github.com/runtechx/OpenFirst/blob/main/guias/preparar-maq-hyperv-para-labs.md)
>
> Apenas depois de concluir essa preparação deverá continuar com a criação dos laboratórios.


## LAB-LNX1

### Requisitos
- Windows 11 com Hyper-V ativo e Vagrant instalado
- Pelo menos:
  - 16 GB RAM
  - 4 CPUs
  - 100 GB livres em disco   


### Objectivo 
Conectar-se aos servidores e familiarizar-se com a linha de comando 

### Baixar o Laboratório 
Executar PowerShell como Administrador:

Invoke-WebRequest `
  -Uri "https://raw.githubusercontent.com/runtechx/OpenFirst/main/labs/lab-lnx1-vagrantfile" `
  -OutFile "Vagrantfile"

### 

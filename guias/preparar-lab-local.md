


## Instalar VirtualBox + Vagrant

Metódo 1 - Usando o winget

**Virtualbox**

```bash
winget install Oracle.VirtualBox
```

**Vagrant**

```bash
winget install HashiCorp.Vagrant
```

Metodo 2 - Baixar e Instalar manualmente

**Virtualbox**

```bash 
$vboxVersion = Invoke-RestMethod "https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT"
$vboxVersion = $vboxVersion.Trim()
$vboxUrl = "https://download.virtualbox.org/virtualbox/$vboxVersion/VirtualBox-$vboxVersion-Win.exe"
Invoke-WebRequest -Uri $vboxUrl -OutFile "$env:TEMP\VirtualBox.exe"
```

**Vagrant**

```bash






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
Start-Process "$env:TEMP\VirtualBox.exe" -Wait
```

**Vagrant**

```bash
$vagrantVersion = (Invoke-RestMethod "https://checkpoint-api.hashicorp.com/v1/check/vagrant").current_version
$vagrantUrl = "https://releases.hashicorp.com/vagrant/$vagrantVersion/vagrant_${vagrantVersion}_windows_amd64.msi"
Invoke-WebRequest -Uri $vagrantUrl -OutFile "$env:TEMP\Vagrant.msi"
Start-Process msiexec.exe -ArgumentList "/i $env:TEMP\Vagrant.msi /quiet" -Wait
```

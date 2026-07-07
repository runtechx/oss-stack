<div align="right">

[![en](https://img.shields.io/badge/lang-en-B22234?style=flat-square)](README.md) [![fr](https://img.shields.io/badge/lang-fr-0055A4?style=flat-square)](README.fr.md)

</div>

<div align="center">

# oss-stack

**aprender · implementar · operar**

*Um repositório público dedicado a ajudar organizações, estudantes e profissionais de TI a aprender, implementar e operar uma infraestrutura on-premises open-source e pronta para produção, através de guias práticos, ambientes de laboratório e automação de deployment.*

[Scripts](#scripts) · [Labs](#labs) · [Blocklists](#blocklists) · [Roadmap](#roadmap)

</div>


## O que é o oss-stack?

O oss-stack é um repositório público dedicado a ajudar organizações, estudantes e profissionais de TI a **aprender, implementar e operar** uma infraestrutura on-premises **open-source** e pronta para produção, através de guias práticos, ambientes de laboratório e automação de deployment.

## O que há neste repositório?

```
oss-stack/
├── guides/        # Guias práticos para aprender e operar a stack
├── scripts/       # Scripts de deployment para AlmaLinux 10+
├── labs/          # Ficheiros de laboratório para testar a stack
├── blocklists/    # Listas de domínios e IPs para reforçar a proteção dos seus sistemas
└── assets/        # Imagens, diagramas e outros ficheiros diversos
```

## Para quem é este projeto?

O oss-stack é uma boa opção se:

- Quer **aprender** como uma stack open-source de nível produção é construída, passo a passo
- Gere infraestrutura on-premises e quer deployments reprodutíveis e auditáveis
- Precisa de montar ferramentas internas — ITSM, monitorização, identidade, wiki, SIEM — sem pagar por SaaS
- Está a construir um homelab ou um ambiente de cliente e quer um ponto de partida sólido e testado
- Quer ensinar ou fazer demonstrações de stacks open-source sem gastar horas em documentação
- É estudante ou profissional de TI à procura de prática prática e guiada, e não apenas documentação


## Porque não usar apenas contentores?

Executar serviços diretamente no SO remove uma camada de abstração entre si e aquilo que está a gerir. Obtém integração nativa com o systemd, caminhos de log padrão, e serviços que se comportam exatamente como documentado a montante — sem nada pelo meio. Isso significa mais controlo sobre a configuração, resolução de problemas mais fácil e uma visão mais clara do que está realmente a correr no seu sistema.
Alguns projetos deste repositório podem estar disponíveis apenas como contentores. Nesse caso, os contentores são usados. Mas quando uma instalação nativa é viável, essa é a opção por defeito.


## Scripts

![Demo Animation](./assets/bstack.gif)

Executar como `root` num servidor **AlmaLinux 10** limpo. Cada script pede os inputs necessários — idioma, IP, FQDN — e trata do resto.

> [!NOTE]
> Expanda cada serviço para ver o comando de instalação de uma linha.

#### Grupo 1 — Serviços core

<details>
<summary><b>Prep Almalinux 10</b> — Linux Container</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/prep-lxc_al10.sh)
```

</details>

<details>
<summary><b>FreeIPA</b> — identidade & DNS</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/freeipa_al10.sh)
```

</details>

<details>
<summary><b>Keycloak</b> — SSO & IAM</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/keycloak_al10.sh)
```

</details>

<details>
<summary><b>NetBox</b> — fonte de verdade da rede</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/netbox_al10.sh)
```

</details>

<details>
<summary><b>Passbolt</b> — gestor de passwords de equipa</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/passbolt_al10.sh)
```

</details>

#### Grupo 2 — Operações

<details>
<summary><b>Zabbix</b> — monitorização de infraestrutura</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/zabbix_al10.sh)
```

</details>

<details>
<summary><b>Wazuh</b> — SIEM & XDR</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/wazuh_al10.sh)
```

> [!NOTE]
> O Wazuh requer no mínimo 4 cores, 8 GB de RAM e 50 GB de disco livre.

</details>

<details>
<summary><b>GLPI</b> — ITSM & gestão de ativos</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/glpi_al10.sh)
```

</details>

<details>
<summary><b>BookStack</b> — wiki de equipa</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/bookstack_al10.sh)
```

</details>

#### Grupo 3 — Serviços de utilizador

<details>
<summary><b>OpenCloud</b> — sincronização e partilha de ficheiros</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/opencloud_al10.sh)
```

</details>

<details>
<summary><b>Nextcloud</b> — sincronização e partilha de ficheiros com um ecossistema de plugins mais amplo</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/nextcloud_al10.sh)
```

</details>

<details>
<summary><b>WordPress</b> — CMS</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/wordpress_al10.sh)
```

</details>


## Labs

Ambientes de laboratório guiados para ajudar a **aprender** e **operar** cada elemento da stack em contexto — como os serviços se relacionam, como validá-los, e como é um deployment completo do início ao fim.

Esta pasta contém Vagrantfiles, configurações OpenTofu, playbooks Ansible, ficheiros de provisionamento Vagrant, e qualquer outra ferramenta com o mesmo objetivo: montar um laboratório reprodutível para praticar. Esta secção está em construção ativa.


## Blocklists

Listas de IPs e domínios mantidas para uso com fail2ban, firewalls e resolvers DNS.

```
blocklists/
├── domain-bl.txt      # Formato 0.0.0.0 <domínio> — Pi-hole / AdGuard / /etc/hosts
├── ip-bl.txt          # Lista de IPs compilada — regras de firewall / IPSET
└── nodes/
    ├── n0.txt         # Lista de IPs partilhada — nó 0
    ├── n1.txt         # Lista de IPs partilhada — nó 1
    ├── n2.txt         # Lista de IPs partilhada — nó 2
    └── n3.txt         # Lista de IPs partilhada — nó 3
```


## Requisitos

A maioria dos serviços corre confortavelmente numa VPS de 2 vCPU / 2 GB RAM. O Wazuh é a exceção — ver nota acima.


## Roadmap

Adições planeadas para o AL10:

- [ ] Cachet — página de estado
- [ ] Gitea — Git auto-hospedado
- [ ] Grafana + Prometheus — métricas e alertas
- [ ] MantisBT — gestão de issues e bugs
- [ ] Mattermost — mensagens de equipa
- [X] Nextcloud — alternativa ao OpenCloud com um ecossistema de plugins mais amplo

Pull requests e reports de issues são bem-vindos.


## Licença

[MIT](LICENSE) © 2026 runtech

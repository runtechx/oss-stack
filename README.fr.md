<div align="right">

[![en](https://img.shields.io/badge/lang-en-B22234?style=flat-square)](README.md) [![pt](https://img.shields.io/badge/lang-pt-009739?style=flat-square)](README.pt.md)

</div>

<div align="center">

# oss-stack

**apprendre · déployer · exploiter**

*Un dépôt public dédié à aider les organisations, les étudiants et les professionnels de l'IT à apprendre, déployer et exploiter une infrastructure on-premises open-source prête pour la production, à travers des guides pratiques, des environnements de labo et de l'automatisation de déploiement.*

[Scripts](#scripts) · [Labs](#labs) · [Blocklists](#blocklists) · [Roadmap](#roadmap)

</div>


## Qu'est-ce que oss-stack ?

oss-stack est un dépôt public dédié à aider les organisations, les étudiants et les professionnels de l'IT à **apprendre, déployer et exploiter** une infrastructure on-premises **open-source** prête pour la production, à travers des guides pratiques, des environnements de labo et de l'automatisation de déploiement.

## Que contient ce dépôt ?

```
oss-stack/
├── guides/        # Guides pratiques pour apprendre et exploiter la stack
├── scripts/       # Scripts de déploiement pour AlmaLinux 10+
├── labs/          # Fichiers de labo pour tester la stack
├── blocklists/    # Listes de domaines et d'IP pour renforcer la protection de vos systèmes
└── assets/        # Images, diagrammes et autres fichiers divers
```

## À qui s'adresse ce projet ?

oss-stack est fait pour vous si :

- Vous voulez **apprendre** comment une stack open-source de niveau production est construite, étape par étape
- Vous gérez une infrastructure on-premises et voulez des déploiements reproductibles et auditables
- Vous devez mettre en place des outils internes — ITSM, supervision, identité, wiki, SIEM — sans payer pour du SaaS
- Vous construisez un homelab ou un environnement client et voulez un point de départ solide et éprouvé
- Vous voulez enseigner ou faire des démonstrations de stacks open-source sans passer des heures sur la documentation
- Vous êtes étudiant ou professionnel de l'IT à la recherche d'une pratique guidée plutôt que de simple documentation


## Pourquoi ne pas utiliser uniquement des conteneurs ?

Faire tourner les services directement sur l'OS supprime une couche d'abstraction entre vous et ce que vous gérez. Vous obtenez une intégration native avec systemd, des chemins de logs standards, et des services qui se comportent exactement comme documenté en amont — rien entre les deux. Cela signifie plus de contrôle sur la configuration, un dépannage plus facile, et une vision plus claire de ce qui tourne réellement sur votre système.
Certains projets de ce dépôt ne sont disponibles qu'en conteneurs. Dans ce cas, les conteneurs sont utilisés. Mais quand une installation native est possible, c'est l'option par défaut.


## Scripts

![Demo Animation](./assets/bstack.gif)

À exécuter en tant que `root` sur un serveur **AlmaLinux 10** neuf. Chaque script demande les informations nécessaires — langue, IP, FQDN — et s'occupe du reste.

> [!NOTE]
> Dépliez chaque service pour voir la commande d'installation en une ligne.

#### Groupe 1 — Services principaux

<details>
<summary><b>Prep Almalinux 10</b> — Linux Container</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/prep-lxc_al10.sh)
```

</details>

<details>
<summary><b>FreeIPA</b> — identité & DNS</summary>

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
<summary><b>NetBox</b> — source de vérité réseau</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/netbox_al10.sh)
```

</details>

<details>
<summary><b>Passbolt</b> — gestionnaire de mots de passe d'équipe</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/passbolt_al10.sh)
```

</details>

#### Groupe 2 — Opérations

<details>
<summary><b>Zabbix</b> — supervision d'infrastructure</summary>

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
> Wazuh nécessite au minimum 4 cœurs, 8 Go de RAM et 50 Go d'espace disque libre.

</details>

<details>
<summary><b>GLPI</b> — ITSM & gestion des actifs</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/glpi_al10.sh)
```

</details>

<details>
<summary><b>BookStack</b> — wiki d'équipe</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/bookstack_al10.sh)
```

</details>

#### Groupe 3 — Services utilisateurs

<details>
<summary><b>OpenCloud</b> — synchronisation et partage de fichiers</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/opencloud_al10.sh)
```

</details>

<details>
<summary><b>Nextcloud</b> — synchronisation et partage de fichiers avec un écosystème de plugins plus large</summary>

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

Des environnements de labo guidés pour vous aider à **apprendre** et **exploiter** chaque élément de la stack en contexte — comment les services s'articulent entre eux, comment les valider, et à quoi ressemble un déploiement complet de bout en bout.

Ce dossier contient des Vagrantfiles, des configurations OpenTofu, des playbooks Ansible, des fichiers de provisionnement Vagrant, et tout autre outil visant le même objectif : monter un labo reproductible pour s'entraîner. Cette section est en construction active.


## Blocklists

Listes d'IP et de domaines maintenues pour une utilisation avec fail2ban, les pare-feux et les résolveurs DNS.

```
blocklists/
├── domain-bl.txt      # Format 0.0.0.0 <domaine> — Pi-hole / AdGuard / /etc/hosts
├── ip-bl.txt          # Liste d'IP compilée — règles de pare-feu / IPSET
└── nodes/
    ├── n0.txt         # Liste d'IP partagée — nœud 0
    ├── n1.txt         # Liste d'IP partagée — nœud 1
    ├── n2.txt         # Liste d'IP partagée — nœud 2
    └── n3.txt         # Liste d'IP partagée — nœud 3
```


## Prérequis

La plupart des services tournent confortablement sur un VPS 2 vCPU / 2 Go de RAM. Wazuh est l'exception — voir la note ci-dessus.


## Roadmap

Ajouts prévus pour AL10 :

- [ ] Cachet — page de statut
- [ ] Gitea — Git auto-hébergé
- [ ] Grafana + Prometheus — métriques et alertes
- [ ] MantisBT — suivi des tickets et bugs
- [ ] Mattermost — messagerie d'équipe
- [X] Nextcloud — alternative à OpenCloud avec un écosystème de plugins plus large

Les pull requests et les rapports d'issues sont les bienvenus.


## Licence

[MIT](LICENSE) © 2026 runtech

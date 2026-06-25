<div align="center">

# runtechx / oss-stack

**Self-hosted open-source infrastructure, deployed in minutes.**

Take a freshly provisioned AlmaLinux server and have a real, working, production-capable service running on it in a few minutes.

No containers, no cloud lock-in, no licensing fees — just clean, reproducible bash scripts
that do exactly what they say.

[Scripts](#scripts) · [Labs](#labs) · [Blocklists](#blocklists) · [Roadmap](#roadmap)

### Demo

[![asciicast](https://asciinema.org/a/1259067.svg)](https://asciinema.org/a/1259067)

</div>


## What is oss-stack?

**oss-stack** is a curated collection of deployment scripts, blocklists and lab definitions for building
self-hosted infrastructure stacks on top of AlmaLinux — the enterprise-grade, RHEL-compatible
Linux distribution.

The goal is simple: take a freshly provisioned AlmaLinux server and have a real, working,
production-capable service running on it in a few minutes — fully configured, firewall open,
SELinux policies applied, and credentials saved to `/root/`.

This is useful if you:

- Run on-premises infrastructure and want reproducible, auditable deployments
- Need to stand up internal tools (ITSM, monitoring, identity, wiki, SIEM) without paying for SaaS
- Are building a homelab or a customer environment and want a known-good starting point
- Want to teach or demo open-source stacks without spending hours on documentation

Every script in this repo is written to be read, not just run. If something goes wrong,
the deploy log tells you where, and the script logic tells you why.



## What's in this repo?

```
oss-stack/
├── scripts/          # Deployment scripts for AlmaLinux 10+
├── blocklists/       # Domain and IP blocklists
└── labs/             # Pre-defined lab environments (work in progress)
```



## Quick Install

Run as `root` on a fresh **AlmaLinux 10** server. The script will prompt for language, IP, and FQDN.
>[!NOTE]
> Collapse/expand each service name to reveal the install commands.

### Group 1 – Core Services

<details>
<summary><b>FreeIPA</b> — identity & DNS</summary>

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
<summary><b>NetBox</b> — network source of truth</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/netbox_al10.sh)
```

</details>

<details>
<summary><b>Passbolt</b> — team password manager</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/passbolt_al10.sh)
```

</details>




### Group 2 – Operations

<details>
<summary><b>Zabbix</b> — infrastructure monitoring</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/zabbix_al10.sh)
```

</details>

<details>
<summary><b>Wazuh</b> — SIEM & XDR</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/wazuh_al10.sh)
```

</details>

<details>
<summary><b>GLPI</b> — ITSM & asset management</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/glpi_al10.sh)
```

</details>

<details>
<summary><b>BookStack</b> — team wiki</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/bookstack_al10.sh)
```

</details>

### Group 3 – User Services

<details>
<summary><b>OpenCloud</b> — file sync & share</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/opencloud_al10.sh)
```

</details>

<details>
<summary><b>WordPress</b> — CMS</summary>

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/runtechx/oss-stack/main/scripts/wordpress_al10.sh)
```

</details>




### What every script does

All scripts follow the same eight-step pattern:

```
1  Language selection     PT / EN / FR — prompts and output adapt automatically
2  User prompts           Server IP, FQDN, any app-specific inputs
3  System update          dnf update -y before anything is installed
4  Stack install          Packages, database, web server, app — in order
5  SELinux                fcontext labels + booleans for every writable path
6  Firewall               firewall-cmd --permanent rules (if firewalld is active)
7  Service enable         systemctl enable --now for all required services
8  Credentials file       /root/<app>-credentials.txt — mode 600 — always
```

Everything is written to `/var/log/deploy-<app>.log` so you can audit or debug any step.

### Notable design decisions

**BookStack** — uses `bookstack-system-cli download-vendor` so Composer is not required on the host.

**FreeIPA** — derives the Kerberos realm from the domain automatically. A valid FQDN must be set as the system hostname before running.

**GLPI** — installs PHP 8.5 from the Remi repository and runs `bin/console db:install` non-interactively. Loads MariaDB timezone tables and patches the `mysql.time_zone_name` grant.

**Keycloak** — detects the latest GitHub release at runtime. Runs `kc.sh build` before first start and runs as a dedicated system user under systemd.

**NetBox** — uses **Valkey** (the Redis-compatible successor shipped in AlmaLinux 10 AppStream) instead of Redis. Generates a self-signed TLS certificate and serves over HTTPS from day one.

**OpenCloud** — deploys a pre-built Go binary with no PHP or database dependency. Requires HTTPS and a real FQDN because the embedded OIDC issuer is bound to `OC_URL`. The script writes a loopback `/etc/hosts` entry so the internal OIDC callback resolves correctly.

**Passbolt** — installs from source via Composer because the official repo-setup script does not yet support AlmaLinux 10. Generates the GPG server key automatically. Admin account is created through the browser wizard on first visit.

**Wazuh** — supports two modes chosen at runtime: **Server** (Indexer + Manager + Dashboard, all-in-one) or **Agent** (auto-enrolled, points at an existing Manager). The Wazuh repository is disabled after installation to prevent accidental upgrades.

**Zabbix** — uses PostgreSQL 18 from the PGDG repository and Zabbix 7.4 from the official Zabbix repo. EPEL exclusions are applied automatically to prevent package conflicts.


## Roadmap
Future additions planned for AL10:

- [ ] Cachet
- [ ] Gitea — self-hosted Git
- [ ] Nextcloud — alternative to OpenCloud for broader plugin ecosystem
- [ ] Mattermost — team messaging
- [ ] MantisB'T
- [ ] openQA ??

## License

[MIT](LICENSE) © 2026 runtech

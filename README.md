<div align="center">

# runtechx / oss-stack

**Self-hosted open-source infrastructure, deployed in minutes.**

Take a freshly provisioned AlmaLinux server and have a real, working, production-capable service running on it in a few minutes.

No containers, no cloud lock-in, no licensing fees — just clean, reproducible bash scripts
that do exactly what they say.

[Scripts](#scripts) · [Labs](#labs) · [Blocklists](#blocklists) · [Roadmap](#roadmap)

</div>


## What is oss-stack?

**oss-stack** is a curated collection of deployment scripts and lab definitions for building
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
├── blocklists/       # Domain and IP blocklists (hosts format + IP shards)
└── labs/             # Pre-defined lab environments (work in progress)
```


## Scripts

Each script deploys a full application stack on a **fresh AlmaLinux** install.
Run as root, answer three questions (language, IP, FQDN), and walk away.

| Script | Application | Stack | Default Port |
|---|---|---|---|
| `bookstack_al10.sh` | [BookStack](https://www.bookstackapp.com/) — team wiki | Nginx · MariaDB · PHP | 80 |
| `freeipa_al10.sh` | [FreeIPA](https://www.freeipa.org/) — identity & DNS | 389-DS · Kerberos · Dogtag · BIND | 443 |
| `glpi_al10.sh` | [GLPI](https://glpi-project.org/) — ITSM & asset management | Apache · MariaDB · PHP 8.5 | 80 |
| `keycloak_al10.sh` | [Keycloak](https://www.keycloak.org/) — SSO & IAM | Java 21 · PostgreSQL | 8080 |
| `netbox_al10.sh` | [NetBox](https://netbox.dev/) — network source of truth | Nginx · PostgreSQL · Valkey | 443 |
| `opencloud_al10.sh` | [OpenCloud](https://opencloud.eu/) — file sync & share | Nginx · Go binary | 443 |
| `passbolt_al10.sh` | [Passbolt](https://www.passbolt.com/) — team password manager | Nginx · MariaDB · PHP 8.3 | 80 |
| `wazuh_al10.sh` | [Wazuh](https://wazuh.com/) — SIEM & XDR | Indexer · Manager · Dashboard | 443 |
| `wordpress_al10.sh` | [WordPress](https://wordpress.org/) — CMS | Apache · MariaDB · PHP | 80 |
| `zabbix_al10.sh` | [Zabbix](https://www.zabbix.com/) — infrastructure monitoring | Nginx · PostgreSQL 18 | 80 |

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



## Labs

> The `labs/` directory is where pre-defined environment blueprints will live.

A **lab** is a combination of scripts that together produce a complete, themed infrastructure
environment on a fresh AlmaLinux 10 server or set of servers. Think of it as a bill of materials
for a working internal stack.

Planned labs include:

| Lab | Services | Purpose |
|---|---|---|
| `lab-itsm` | GLPI + Zabbix + BookStack | IT operations — ticketing, monitoring, documentation |
| `lab-identity` | FreeIPA + Keycloak | Centralised identity with SSO |
| `lab-security` | Wazuh + Passbolt | SIEM, XDR, and credential management |
| `lab-netops` | NetBox + Zabbix | Network source of truth + monitoring |
| `lab-collab` | OpenCloud + BookStack + WordPress | File sharing, wiki, and web presence |

Labs are the next phase of this project. Watch this space.



## Blocklists

Maintained IP and domain blocklists for use with firewalls, DNS resolvers, or IPSET rules.

```
blocklists/
├── domain-bl.txt        # 0.0.0.0 <domain> format — Pi-hole / AdGuard / /etc/hosts
├── ip-bl.txt            # Flat IP list — firewall rules / IPSET
└── nodes/
    ├── n0.txt           # Sharded IP list — node 0
    ├── n1.txt           # Sharded IP list — node 1
    ├── n2.txt           # Sharded IP list — node 2
    └── n3.txt           # Sharded IP list — node 3
```

The node shards allow blocklist distribution across multiple enforcement points — each node
loads only its shard, keeping memory footprint small on constrained hardware.



## Requirements

| | |
|---|---|
| **OS** | AlmaLinux 10 (x86\_64) — fresh minimal install recommended |
| **User** | `root` or passwordless `sudo` |
| **Network** | Internet access required during install |
| **SELinux** | Supported — all required policies are applied by the scripts |
| **Firewall** | `firewalld` — configured automatically if the service is active |

Most services run comfortably on a 2-vCPU / 2 GB RAM VPS.
Wazuh Server is the exception — it requires at least 4 cores, 8 GB RAM, and 50 GB free disk.



## Roadmap

oss-stack is built to grow with AlmaLinux.

```
AlmaLinux 10   ████████████░░░░   active — scripts complete, labs incoming
```

Future additions planned for AL10:

- [ ] Gitea — self-hosted Git
- [ ] Nextcloud — alternative to OpenCloud for broader plugin ecosystem
- [ ] Grafana + Prometheus — metrics stack
- [ ] Vaultwarden — Bitwarden-compatible server
- [ ] Mattermost — team messaging
- [ ] Lab blueprints (`labs/`)

Pull requests and issue reports are welcome.


## License

[MIT](LICENSE) © 2026 runtech

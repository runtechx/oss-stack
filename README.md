# runtechx — AlmaLinux 10 Deployment Scripts

> One-command deployment of production-ready open-source infrastructure on **AlmaLinux 10**.
> Every script is trilingual, SELinux-aware, and saves credentials to `/root/` on completion.

---

## Overview

This repository provides battle-tested shell scripts for deploying self-hosted services on AlmaLinux 10. Each script handles the full stack: package installation, database provisioning, web server configuration, SELinux policies, firewall rules, and a credentials file written to `/root/` — so you can hand a server off and know exactly where to find the passwords.

All scripts are interactive, prompt for IP and FQDN, and support **Português · English · Français**.

---

## Scripts

| Script | Stack | Default Port |
|---|---|---|
| `bookstack_al10.sh` | Nginx · MariaDB · PHP (AppStream) | 80 |
| `freeipa_al10.sh` | 389-DS · Kerberos · Dogtag CA · BIND DNS | 443 |
| `glpi_al10.sh` | Apache · MariaDB · PHP 8.5 (Remi) | 80 |
| `keycloak_al10.sh` | Java 21 · PostgreSQL | 8080 |
| `netbox_al10.sh` | Nginx · PostgreSQL · Valkey · Gunicorn | 443 |
| `opencloud_al10.sh` | Nginx · Go binary (self-contained) | 443 |
| `passbolt_al10.sh` | Nginx · MariaDB · PHP 8.3 (Remi) | 80 |
| `wazuh_al10.sh` | Indexer · Manager · Dashboard **or** Agent only | 443 |
| `wordpress_al10.sh` | Apache · MariaDB · PHP (AppStream) | 80 |
| `zabbix_al10.sh` | Nginx · PostgreSQL 18 · PHP-FPM | 80 |

---

## Quick Start

```bash
# Run as root or with sudo
sudo bash <script_name>.sh
```

Each script will ask for:

1. Language — `1` PT · `2` EN · `3` FR
2. Server IP address *(auto-detected, press Enter to confirm)*
3. Access URL / FQDN *(auto-detected from hostname)*
4. Any service-specific inputs *(realm, admin password, etc.)*

At the end, credentials are printed to the terminal **and** saved to `/root/<app>-credentials.txt` (mode `600`).

---

## What Every Script Does

```
1. Language selection (PT / EN / FR)
2. User prompts     (IP, FQDN, passwords)
3. System update    (dnf update -y)
4. Stack install    (packages, database, web server)
5. SELinux          (fcontexts + booleans)
6. Firewall         (firewall-cmd --permanent)
7. Service enable   (systemctl enable --now)
8. Credentials file (/root/<app>-credentials.txt, mode 600)
9. Summary output   (URL, logins, paths)
```

All activity is logged to `/var/log/deploy-<app>.log`.

---

## Script Notes

### BookStack
Installs the latest release branch from GitHub. Uses `php bookstack-system-cli download-vendor` — no Composer required. Runs under `apache` user with PHP-FPM (AppStream).

### FreeIPA
Requires a valid FQDN set as the system hostname before running. Configures integrated DNS with auto-forwarders. Kerberos realm is derived from the domain by default.

### GLPI
Uses **PHP 8.5 from the Remi repository** (`remi-release-10`). Runs the CLI installer (`bin/console db:install`) for a non-interactive setup. Loads MariaDB timezone tables and grants `SELECT` on `mysql.time_zone_name`.

### Keycloak
Detects the latest GitHub release automatically. Builds Keycloak with `kc.sh build` before first start. Runs as a dedicated `keycloak` system user under systemd.

### NetBox
Pins to a tested release (`v4.2.0` — update `NETBOX_VERSION` to change). Uses **Valkey** (the Redis-compatible replacement shipped in AlmaLinux 10 AppStream). Generates a self-signed TLS certificate valid for 10 years and configures an Nginx reverse proxy on port 443.

### OpenCloud
Deploys the pre-built Go binary — no PHP, no database. Requires HTTPS and a valid FQDN: IP-only access does not work because the embedded OIDC issuer is bound to `OC_URL`. The script patches `/etc/hosts` with a loopback entry so the internal OIDC callback resolves correctly.

### Passbolt CE
Installs from source via Composer because the official repo-setup script does not yet support AlmaLinux 10. Uses **PHP 8.3 from Remi**. Generates the GPG server key automatically. The admin account is created through the browser wizard on first visit.

### Wazuh
Supports two modes selected at runtime:
- **Server** — deploys Indexer + Manager + Dashboard on a single node using the official `wazuh-install.sh -a` all-in-one method. Minimum 4 cores / 8 GB RAM / 50 GB disk.
- **Agent** — installs and auto-enrolls a Wazuh agent pointing at an existing Manager.

In both modes the Wazuh repository is **disabled after installation** to prevent unintentional upgrades.

### WordPress
Standard LAMP stack. Fetches WordPress security keys from the official WordPress API. Writes `wp-config.php` with generated database credentials.

### Zabbix
Uses **Zabbix 7.4** from the official Zabbix repository and **PostgreSQL 18** from the PGDG repository. Excludes Zabbix packages from EPEL to prevent conflicts. Configures Nginx on port 80 (add Let's Encrypt separately for HTTPS).

---

## Blocklists

```
blocklists/
├── domain-bl.txt        # Domain-level blocklist (hosts-file format)
├── ip-bl.txt            # IP address blocklist
└── nodes/
    ├── n0.txt           # Node-distributed IP blocklist (shard 0)
    ├── n1.txt           # Node-distributed IP blocklist (shard 1)
    ├── n2.txt           # Node-distributed IP blocklist (shard 2)
    └── n3.txt           # Node-distributed IP blocklist (shard 3)
```

The domain blocklist uses the standard `0.0.0.0 <domain>` format compatible with Pi-hole, AdGuard Home, and `/etc/hosts` overrides. The IP list and node shards are suitable for firewall rules or IPSET ingestion.

---

## Requirements

| Requirement | Detail |
|---|---|
| OS | AlmaLinux 10 (x86\_64) |
| User | `root` or `sudo` |
| Internet | Required (packages + GitHub releases) |
| SELinux | Supported — scripts apply all required policies |
| Firewall | `firewalld` — configured automatically if active |

Minimum hardware varies by service. Wazuh Server is the most demanding (4 CPU / 8 GB RAM / 50 GB disk). All others run comfortably on a 2-CPU / 2 GB RAM VPS.

---

## Credentials

After a successful run, credentials are in two places:

```
Terminal output  — printed at the end of the script
/root/<app>-credentials.txt  — mode 600, persistent
```

The credentials file includes the access URL, default login, database name/user/password, install directory, config file paths, and the deploy log location. **Keep the file or note the credentials before deleting it.**

---

## License

[MIT](LICENSE) © 2026 runtech

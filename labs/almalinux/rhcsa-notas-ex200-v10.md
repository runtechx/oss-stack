
# Study points for the exam
[RHCSA exam](https://www.redhat.com/en/services/training/ex200-red-hat-certified-system-administrator-rhcsa-exam) candidates should be able to accomplish the tasks below without assistance. These have been grouped into several categories.

## Understand and use essential tools

- Access a shell prompt and issue commands with correct syntax
- Use input-output redirection (>, >>, |, 2>, etc.)
- Use grep and regular expressions to analyze text
- Access remote systems using SSH
- Log in and switch users in multiuser targets
- Archive, compress, unpack, and uncompress files using tar, gzip, and bzip2
- Create and edit text files
- Create, delete, copy, and move files and directories
- Create hard and soft links
- List, set, and change standard ugo/rwx permissions
- Locate, read, and use system documentation including man, info, and files in /usr/share/doc

## Manage software

- Configure access to RPM repositories
- Install and remove RPM software packages
- Configure access to Flatpak repositories
- Install and remove Flatpak software packages

## Create simple shell scripts

- Conditionally execute code (use of: if, test, [], etc.)
- Use Looping constructs (for, etc.) to process file, command line input
- Process script inputs ($1, $2, etc.)
- Processing output of shell commands within a script

## Operate running systems

- Boot, reboot, and shut down a system normally
- Boot systems into different targets manually
- Interrupt the boot process in order to gain access to a system
- Identify CPU/memory intensive processes and kill processes
- Adjust process scheduling
- Manage tuning profiles
- Locate and interpret system log files and journals
- Preserve system journals
- Start, stop, and check the status of network services
- Securely transfer files between systems

## Configure local storage

- List, create, delete partitions on GPT disks
- Create and remove physical volumes
- Assign physical volumes to volume groups
- Create and delete logical volumes
- Configure systems to mount file systems at boot by universally unique ID (UUID) or label
- Add new partitions and logical volumes, and swap to a system non-destructively

## Create and configure file systems

- Create, mount, unmount, and use VFAT, ext4, and xfs file systems
- Mount and unmount network file systems using NFS
- Configure autofs
- Extend existing logical volumes
- Diagnose and correct file permission problems

## Deploy, configure, and maintain systems

- Schedule tasks using at cron and systemd timer units
- Start and stop services and configure services to start automatically at boot
- Configure systems to boot into a specific target automatically
- Configure time service clients
- Install and update software packages from Red Hat Content Delivery Network, a remote repository, or from the local file system
- Modify the system bootloader

## Manage basic networking

- Configure IPv4 and IPv6 addresses
- Configure hostname resolution
- Configure network services to start automatically at boot
- Restrict network access using firewalld and firewall-cmd

## Manage users and groups

- Create, delete, and modify local user accounts
- Change passwords and adjust password aging for local user accounts
- Create, delete, and modify local groups and group memberships
- Configure privileged access

## Manage security

- Configure firewall settings using firewall-cmd/firewalld
- Manage default file permissions
- Configure key-based authentication for SSH
- Set enforcing and permissive modes for SELinux
- List and identify SELinux file and process context
- Restore default file contexts
- Manage SELinux port labels
- Use boolean settings to modify system SELinux settings

>[!NOTE]
> As with all Red Hat performance-based exams, configurations must persist after reboot without intervention.
>
>Red Hat reserves the right to add, modify, and remove objectives. Such changes will be made public in advance through revisions to this document.

# Especificações de Hardware

## Máquinas Virtuais

| Máquina           | Memória | Disco 1 | Disco 2 | CPU |
|------------------|--------|--------|--------|-----|
| Virtualizador    | 16 GB  | 64 GB+ | —      | 4   |
| Máquina Virtual 1| 2 GB   | 20 GB+ | —      | 2   |
| Máquina Virtual 2| 2 GB   | 20 GB+ | —      | 2   |

## Rede
- Tipo: Bridge

# Infrastructure Architecture

## Overview

The homelab combines Windows virtualization, an Ubuntu application server, and Debian network storage.

```text
Windows Virtualization Host
|
|-- Docker Applications
|   |-- Immich
|   |-- Jellyfin
|   |-- Portainer
|   `-- Uptime Kuma
|
`-- Ubuntu Server VM
    |-- Nginx
    |-- FastAPI Dashboard
    |-- PostgreSQL
    `-- Automated Database Backups
                 |
                 | SSH / rsync
                 v
         Debian Storage Server
         |-- Samba Shares
         |-- Media Storage
         |-- Immich Originals
         `-- Off-Host Backups
```

## Technical Design

- Hyper-V provides Linux virtualization on the Windows host.
- Docker runs application containers.
- Nginx serves the infrastructure dashboard and proxies API requests.
- FastAPI processes monitoring and inventory requests.
- PostgreSQL stores application data and telemetry.
- Debian provides shared storage and backup destinations.
- systemd manages Linux services and automated tasks.

## Operational Considerations

Application availability, data durability, and disaster recovery are separate concerns.

The lab uses off-host database backups, but not every application has a fully tested independent recovery procedure.

The diagram is intentionally sanitized and does not contain internal addresses or authentication details.

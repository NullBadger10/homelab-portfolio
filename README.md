# Homelab | Infrastructure Engineering Portfolio

A multi-device homelab built to develop practical skills in systems administration, virtualization, automation, monitoring, and disaster recovery.

I use this environment to build useful services, troubleshoot infrastructure problems, automate repetitive tasks, and validate recovery procedures.

## Infrastructure

| Component | Technologies | Purpose |
| --- | --- | --- |
| Virtualization host | Windows, Hyper-V, Docker | Virtual machines and containerized services |
| Application server | Ubuntu Server, Nginx, FastAPI, PostgreSQL | Dashboard, API, database, and backup automation |
| Storage server | Debian, Samba, ext4, SSH | Network storage and off-host backups |
| Monitoring | Uptime Kuma, Python, Bash, systemd | Service health and infrastructure telemetry |

## Featured Projects

### PostgreSQL Backup and Disaster Recovery

Implemented scheduled PostgreSQL backups and replication to a separate physical computer.

- Automated custom-format database backups
- Archive validation and local retention
- systemd-triggered replication through SSH and rsync
- Restricted backup access
- Isolated test database restoration
- Verified recovery of approximately 700 records

**Remaining work:** Additional failure testing, remote retention verification, and recovery drills.

[Backup and recovery details](docs/backup-and-recovery.md)

### Infrastructure Dashboard

Built a web-based infrastructure dashboard using FastAPI, PostgreSQL, Nginx, and JavaScript.

- REST API endpoints
- CPU, memory, disk, and uptime metrics
- Remote Linux telemetry ingestion
- PostgreSQL-backed inventory and maintenance history
- systemd-managed application service

[Architecture overview](docs/architecture.md)

### Automated Infrastructure Incident Monitoring

Extended the dashboard with an unattended Python monitoring service, PostgreSQL incident history and recovery tracking.

- Six health checks for backup age, job results, telemetry freshness and disk utilization
- Five-minute `systemd` scheduling independent of the web browser
- Deduplicated open incidents with automatic recovery timestamps
- Read-only FastAPI endpoints and dashboard incident history
- Verified incident creation, deduplication and recovery using an isolated test table

[Monitoring architecture and verification](docs/incident-monitoring.md)

### Immich Photo Cloud

Deployed Immich for self-hosted photo and video management using Docker and Debian network storage.

- Application services hosted in containers
- Photo originals stored on a separate Debian computer
- Automated transfer of database backup archives
- Mobile photo and video backup workflow

**Limitation:** A complete independent recovery has not yet been validated.

### PowerShell TV Library Organizer

Developed a PowerShell workflow for organizing a television library.

- CSV-based move planning and auditing
- SHA-256 duplicate detection
- FFprobe integration
- Interrupted-operation recovery
- 272 media files organized

### Storage Administration and Monitoring

Configured persistent storage, cross-platform file sharing, and automated health checks using Samba, ext4, Bash, systemd, and Uptime Kuma.

### Self-Hosted Documentation Portal

Built a documentation portal using MkDocs Material and Nginx, integrated with the infrastructure dashboard.

## Technical Skills

Linux administration, Windows, Hyper-V, Docker, PostgreSQL, Bash, PowerShell, Python, FastAPI, Nginx, Samba, SSH, rsync, Git, monitoring, backup, and recovery.

## Documentation

- [Infrastructure Architecture](docs/architecture.md)
- [Automated Incident Monitoring](docs/incident-monitoring.md)
- [PostgreSQL Backup and Recovery](docs/backup-and-recovery.md)
- [Project Roadmap](docs/roadmap.md)

## Engineering Approach

My goal is to understand how infrastructure components interact, identify failure points, automate routine operations, document troubleshooting, and test recovery procedures.

This portfolio distinguishes verified implementations from planned improvements.

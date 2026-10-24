# PostgreSQL Backup and Disaster Recovery

## Objective

Protect infrastructure application data and practice recovery from database failure or data loss.

## Backup Workflow

1. A systemd timer starts the scheduled backup service.
2. A Bash script creates a PostgreSQL custom-format dump.
3. The archive is validated before finalization.
4. Successful completion triggers a separate replication service.
5. SSH and rsync transfer backups to an independent physical computer.

## Recovery Validation

Backups have been restored into isolated PostgreSQL databases without overwriting the production database.

A later recovery test verified approximately 700 restored records.

## Technologies

- PostgreSQL pg_dump and pg_restore
- Bash
- systemd services and timers
- SSH
- rsync
- Linux file permissions

## Remaining Work

- Verify remote retention policy behavior.
- Improve failure detection and alerting.
- Test additional restore scenarios.
- Expand recovery testing to other applications.

Database-level restoration does not establish full virtual-machine disaster recovery.

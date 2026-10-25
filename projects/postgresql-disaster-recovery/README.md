# PostgreSQL Backup Replication and Recovery Validation

**Status:** Implemented; database-level recovery tested. **Not** a complete infrastructure disaster recovery implementation.

## Problem and goal

A PostgreSQL database supports a self-hosted infrastructure dashboard. A local-only database dump cannot protect against loss of the VM or its storage. This project adds automated database snapshots, event-triggered replication to a separate Debian machine, and an isolated restore exercise.

## Architecture

See [architecture and workflow](architecture.md). The Ubuntu VM creates PostgreSQL custom-format dumps, validates the dump inventory with `pg_restore -l`, publishes completed files and retains recent local snapshots. A systemd `OnSuccess=` dependency starts SSH/rsync replication to an external volume attached to a separate physical Debian host. Destination retention is a separate scheduled job.

## Implementation

- **Backup:** `pg_dump -Fc`, temporary `.partial` output, nonempty/TOC checks, restrictive permissions, atomic same-directory rename, seven-day local retention policy.
- **Scheduling:** systemd calendar timer at 03:00 UTC with `Persistent=true`.
- **Replication:** systemd success dependency, key-based noninteractive SSH, host-key checking, mount guard, `rsync --checksum`; runs as a separate oneshot service.
- **Destination retention:** separate daily systemd timer at 04:00 UTC; mount guard and safeguard preserving at least the newest automated dump.
- **Recovery:** a replicated dump was retrieved from the Debian host and restored into a separate temporary PostgreSQL database, without replacing production data.

Sanitized, illustrative adaptations of the operational scripts are under [examples](examples/). They have not been deployed or end-to-end tested as a reusable distribution. Credentials, internal addresses, original user accounts, and real data are omitted. The operational repository remains private.

## Verification evidence

See [recovery test and execution evidence](validation.md).

On **October 23, 2026**, the operational runbook recorded a successful restore from a replicated backup (reported `pg_restore` exit code 0) and SQL row counts of **3 managed systems + 3 maintenance records + 694 telemetry records = 700 rows**. This is evidence for successful database-level recovery of the tested backup, not bytewise verification of every record or full VM recovery.

On **October 24, 2026**, the source journal showed backup service completion followed by successful replication at 01:35, 03:00 and 23:19 UTC. The destination listed the matching most recent dump. The destination retention journal showed a successful execution on October 23, but there was no recorded expired-file deletion in the supplied evidence.

## Engineering decisions and limitations

1. **Event-triggered versus hourly replication:** the current success dependency sends backups after creation; the earlier hourly transfer remains historical and was retired.
2. **Backup success differs from replication success:** `OnSuccess=` starts the second unit; failures in that unit must be monitored separately.
3. **Archive TOC validation is limited:** `pg_restore -l` is not equivalent to a full restore, which is why an independent restore test was done.
4. **Mount guard currently tied to `/dev/sdb1`:** prefer a stable filesystem UUID in a future revision.
5. **No PITR:** logical daily dumps cannot recover arbitrary moments between backups.
6. **Not off-site:** a separate physical computer is not protection from a site-wide event.
7. **Not yet demonstrated:** fresh-host rebuild, application end-to-end recovery, measured RTO/RPO, periodic automated restore drills, comprehensive post-copy integrity verification, and failure alerting. Restoring 700 rows does not establish any of these.

## Skills demonstrated

Linux administration; PostgreSQL logical backup and restore; Bash error handling; systemd oneshot services, timers and dependencies; SSH access controls; rsync; least-privilege file permissions; recovery validation; documenting operational limits.

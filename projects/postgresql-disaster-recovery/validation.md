# Recovery and operation evidence

**Evidence source:** contemporaneous private operational runbook and journal excerpts inspected in October 2026. No new restore was run to create this public page. Do not interpret these results as a full rebuild test.

## October 23: off-machine restore drill

The runbook documents retrieval of a PostgreSQL custom-format archive from external storage on the separate Debian host, transfer into temporary staging on the Ubuntu VM, restoration as the `postgres` OS account into `homelab_usb_restore_test`, SQL row counts, then removal of the temporary database and staging files.

| Restored table | Rows |
| --- | ---: |
| `managed_systems` | 3 |
| `maintenance_history` | 3 |
| `system_telemetry` | 694 |
| **Total** | **700** |

Recorded `pg_restore` exit code: **0**.

An initial attempt used the wrong database role (`root`) and failed; the corrected procedure explicitly executed the restore as the PostgreSQL OS user. The SQL count verification does not establish byte-for-byte data comparison.

## October 24: backup → replication sequence

Times below are **UTC**, transcribed from systemd journals. The entries verify three completed *backup and transfer sequences*; only the 03:00 run aligns with the configured calendar schedule. Trigger origins for the other runs were not established.

| Backup completed | Replication completed | Logged result |
| --- | --- | --- |
| 01:35:08 | 01:35:09 | Both services successful |
| 03:00:45 | 03:00:47 | Both services successful |
| 23:19:33 | 23:19:34 | Both services successful |

The Debian external-storage listing included the latest timestamped dump from this sequence, with `rw-------` permissions. It listed seven dump files in total.

## Remote retention observation

The destination service journal recorded a successful retention run on October 23 at **23:00:11 local time**. The file inventory establishes backups exist; it does *not* demonstrate that the retention script actually deleted an expired file.

## Validation scope and open gaps

**Verified:** a copied archive could be retrieved, `pg_restore` completed into an isolated database, row counts were queried, and the operational logs reported repeated successful backup/replication transfers.

**Not verified by this evidence:** bit-for-bit validation of copied dumps, repeated unattended restore drills, a fresh PostgreSQL installation, a full application or VM rebuild, recovery duration, recovery after deletion/corruption scenarios, or off-site survivability.

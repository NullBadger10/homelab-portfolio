# Sanitized systemd examples

Adapted from the installed arrangement; update paths, identities, and dependencies for your own deployment.

## Backup service

```ini
[Unit]
Description=Example PostgreSQL logical backup
Wants=postgresql.service
After=postgresql.service

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/sbin/example-db-backup.sh
```

## Backup timer

```ini
[Unit]
Description=Run example PostgreSQL backup every day

[Timer]
OnCalendar=*-*-* 03:00:00 UTC
Persistent=true
Unit=example-db-backup.service

[Install]
WantedBy=timers.target
```

## Success-triggered replication override

Install under `example-db-backup.service.d/replication.conf`:

```ini
[Unit]
OnSuccess=example-db-replicate.service
```

## Replication service

```ini
[Unit]
Description=Replicate example PostgreSQL backups to another host
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
User=root
ExecStart=/usr/local/sbin/example-db-replicate.sh
TimeoutStartSec=120
```

## Caveats

- A successful backup unit is not evidence of a successful replication unit.
- `Persistent=true` catches up missed timer events; it does not necessarily replay each missed occurrence.
- The receiver must enforce its own destination restrictions, permissions, and mount safety; the example scripts alone are not a production-ready secure receiver.
- The operational Debian environment also has a separate daily retention timer at 04:00 UTC that guards the external mount and preserves its newest automated dump. Its separate implementation is summarized in the case-study README.

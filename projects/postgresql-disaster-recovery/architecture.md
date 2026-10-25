# Architecture and workflow

```mermaid
flowchart TD
    DB["Ubuntu VM: PostgreSQL database"] --> TIMER["systemd backup timer, 03:00 UTC"]
    TIMER --> DUMP["Bash: pg_dump -Fc to .partial"]
    DUMP --> VALIDATE{"Nonempty and pg_restore -l succeeds?"}
    VALIDATE -- No --> FAIL["Fail backup service; remove partial file"]
    VALIDATE -- Yes --> LOCAL["Publish .dump; local retention"]
    LOCAL --> ON["systemd OnSuccess dependency"]
    ON --> SSH["SSH + rsync; host-key check and mount guard"]
    SSH --> USB["Separate Debian machine: external USB backup storage"]
    USB --> RETAIN["Independent retention timer, 04:00 UTC"]
    USB -. "Manual retrieval for tested drill" .-> RESTORE["Isolated PostgreSQL restore database"]
    RESTORE --> SQL["SQL row-count verification and cleanup"]
```

## Components

| Component | Function |
| --- | --- |
| Source Ubuntu VM | Runs the PostgreSQL dashboard database and backup/replication services |
| Local backup directory | Holds completed custom-format archives, separate from `.partial` files |
| systemd `OnSuccess=` | Starts replication only after the backup service finishes successfully |
| SSH/rsync | Transfers dumps to the second physical computer, with a destination mount precondition |
| Debian external storage | Holds independent backup copies and runs a separate retention job |
| Isolated restore database | Provides non-destructive validation of retrieved backup data |

## Important distinction

The operational system produces a *backup copy* on another host, not a synchronous replica of the running database. Transfer logs demonstrate service success; they do not replace periodic restore drills. The path to an independent backup copy reduces reliance on the VM but does not by itself satisfy full disaster recovery requirements.

#!/usr/bin/env bash
# Sanitized adaptation of an operational script; review and test before using.
set -Eeuo pipefail
umask 077

BACKUP_DIR="/var/backups/example-postgres"
DATABASE="exampledb"
RETENTION_DAYS=7
timestamp="$(date -u +%Y-%m-%d_%H-%M-%S)"
archive="$BACKUP_DIR/example-auto-$timestamp.dump"
partial="$archive.partial"
trap 'rm -f -- "$partial"' EXIT

install -d -m 700 "$BACKUP_DIR"
# Script assumes execution as root; pg_dump uses local postgres OS identity.
runuser -u postgres -- pg_dump -Fc -d "$DATABASE" > "$partial"
test -s "$partial"
pg_restore -l "$partial" > /dev/null
mv -- "$partial" "$archive"
chmod 600 "$archive"

# A 7-day calendar-style retention policy matching the original script's -mtime +6.
find "$BACKUP_DIR" -maxdepth 1 -type f \
  -name 'example-auto-*.dump' -mtime +6 -delete

echo "Created validated archive: $archive"

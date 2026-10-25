#!/usr/bin/env bash
# Sanitized educational adaptation; NOT a drop-in production configuration.
# Replace all placeholders and test receiver access, mounts and failure cases.
set -Eeuo pipefail
umask 077

SOURCE="/var/backups/example-postgres/"
REMOTE_USER="backup-user"
REMOTE_HOST="backup.example.internal"
REMOTE_DIR="/mnt/backup-volume/postgres/"
SSH_KEY="/etc/example-backup/id_ed25519"
KNOWN_HOSTS="/etc/example-backup/known_hosts"
MOUNT_POINT="/mnt/backup-volume"

SSH_OPTS=(
  -i "$SSH_KEY"
  -o IdentitiesOnly=yes
  -o BatchMode=yes
  -o StrictHostKeyChecking=yes
  -o "UserKnownHostsFile=$KNOWN_HOSTS"
  -o ConnectTimeout=10
)

# Verify at least one completed local backup exists.
compgen -G "${SOURCE}*.dump" >/dev/null || {
  echo "ERROR: no completed backups found" >&2
  exit 1
}

# Defense in depth: the receiving rsync process is started only if the
# destination mount exists at transfer time. This protects against a
# missing mount, but cannot prevent the disk disappearing mid-transfer.
# All remote command values here are fixed, trusted configuration values.
REMOTE_RSYNC="mountpoint -q '$MOUNT_POINT' && exec rsync"

rsync -av --checksum --no-owner --no-group \
  --include='*.dump' --exclude='*' \
  --rsync-path="$REMOTE_RSYNC" \
  -e "ssh -i $SSH_KEY -o IdentitiesOnly=yes -o BatchMode=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$KNOWN_HOSTS -o ConnectTimeout=10" \
  "$SOURCE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Backup transfer completed"

# This example assumes the destination exists, is writable only by the
# intended backup identity, and allows a remote shell command. If using
# an authorized_keys forced-command/rrsync receiver, adapt the command
# to that receiver's restrictions rather than copying this verbatim.
# For additional assurance, validate retrieved backups with pg_restore
# and periodic isolated restore tests.

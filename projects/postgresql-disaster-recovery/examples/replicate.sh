#!/usr/bin/env bash
# Sanitized adaptation; placeholders MUST be replaced before testing.
set -Eeuo pipefail
umask 077

SOURCE="/var/backups/example-postgres/"
REMOTE_USER="backup-user"
REMOTE_HOST="backup.example.internal"
REMOTE_DIR="/mnt/backup-volume/postgres/"
SSH_KEY="/etc/example-backup/id_ed25519"
KNOWN_HOSTS="/etc/example-backup/known_hosts"

# The operational script checked for /dev/sdb1. This illustrative example
# instead requires a known mount point; a UUID-based check is preferable.
ssh -i "$SSH_KEY" -o BatchMode=yes -o StrictHostKeyChecking=yes \
  -o "UserKnownHostsFile=$KNOWN_HOSTS" -o ConnectTimeout=10 \
  "$REMOTE_USER@$REMOTE_HOST" "mountpoint -q /mnt/backup-volume"

rsync -av --checksum --no-owner --no-group \
  --include='*.dump' --exclude='*' \
  -e "ssh -i $SSH_KEY -o BatchMode=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=$KNOWN_HOSTS -o ConnectTimeout=10" \
  "$SOURCE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

echo "Backup transfer completed"
# Note: a production deployment must also enforce the mount precondition
# in the remote rsync execution path to avoid an unmount race.

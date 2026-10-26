#!/bin/bash
BACKUP_DIR="/mnt/media/backups"
SOURCE_DIR="/opt/mediaserver"
DATE=$(date +%F)

mkdir -p "$BACKUP_DIR"

# Create compressed archive (removed -v for clean background cron execution)
tar -czf "$BACKUP_DIR/mediaserver-config-$DATE.tar.gz" \
  --warning=no-file-changed \
  --exclude="$SOURCE_DIR/jellyfin/cache" \
  --exclude="$SOURCE_DIR/jellyfin/data/transcodes" \
  --exclude="$SOURCE_DIR/jellyfin/data/metadata/library" \
  --exclude="$SOURCE_DIR/prometheus/data" \
  "$SOURCE_DIR" \
  /etc/fstab \
  /etc/docker/daemon.json

# Delete archives older than 30 days
find "$BACKUP_DIR" -type f -name "mediaserver-config-*.tar.gz" -mtime +30 -delete

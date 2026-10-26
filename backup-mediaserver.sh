#!/bin/bash
BACKUP_DIR="/mnt/media/backups"
DATE=$(date +%F)

mkdir -p "$BACKUP_DIR"

# -C / steps into root first so paths don't need a leading '/'
tar -czf "$BACKUP_DIR/mediaserver-config-$DATE.tar.gz" \
  --warning=no-file-changed \
  --exclude="opt/mediaserver/jellyfin/cache" \
  --exclude="opt/mediaserver/jellyfin/data/transcodes" \
  --exclude="opt/mediaserver/jellyfin/data/metadata/library" \
  --exclude="opt/mediaserver/prometheus/data" \
  -C / \
  opt/mediaserver \
  etc/fstab \
  etc/docker/daemon.json

find "$BACKUP_DIR" -type f -name "mediaserver-config-*.tar.gz" -mtime +30 -delete

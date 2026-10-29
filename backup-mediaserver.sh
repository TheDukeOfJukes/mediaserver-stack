#!/bin/bash
BACKUP_DIR="/mnt/media/backups"
DATE=$(date +%F)

mkdir -p "$BACKUP_DIR"

# Archive the real SSD path (mnt/ssd/mediaserver) plus host OS configs
tar -czf "$BACKUP_DIR/mediaserver-config-$DATE.tar.gz" \
  --warning=no-file-changed \
  --exclude="mnt/ssd/mediaserver/jellyfin/cache" \
  --exclude="mnt/ssd/mediaserver/jellyfin/data/transcodes" \
  --exclude="mnt/ssd/mediaserver/jellyfin/data/metadata/library" \
  --exclude="mnt/ssd/mediaserver/prometheus/data" \
  -C / \
  mnt/ssd/mediaserver \
  opt/mediaserver \
  etc/fstab \
  etc/docker/daemon.json \
  etc/sysctl.d/99-mediaserver-io.conf \
  etc/udev/rules.d/60-ioschedulers.rules \
  etc/modules-load.d/bfq.conf

find "$BACKUP_DIR" -type f -name "mediaserver-config-*.tar.gz" -mtime +30 -delete

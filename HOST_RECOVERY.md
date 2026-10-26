# Host OS & External Recovery Blueprint

## 1. Tailscale Admin Console Settings (Cloud)
- Server IP: 100.101.56.5 (Disable Key Expiry in Tailscale Admin Console)
- Split DNS: Domain media.internal -> Nameserver 100.101.56.5
- Client Access: Remote/Mobile browsers must use explicit http://*.media.internal (Port 80) or native apps. Stationary LAN devices can use http://192.168.0.177:<PORT>.

## 2. Ubuntu Host Requirement: Release Port 53 for Pi-hole
Fresh Ubuntu installs run systemd-resolved on port 53, which blocks Pi-hole:
~~bash
sudo sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
sudo systemctl restart systemd-resolved
~~

## 3. Storage Mounts (/etc/fstab)
~~~text
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sdc2 during curtin installation
/dev/disk/by-uuid/c0df66b7-8893-46e7-923c-cdd39da9080d / ext4 defaults 0 1
# /boot/efi was on /dev/sdc1 during curtin installation
/dev/disk/by-uuid/475C-95EF /boot/efi vfat defaults 0 1
/swap.img	none	swap	sw	0	0
UUID=c0df66b7-8893-46e7-923c-cdd39da9080d /mnt/media ext4 defaults,nofail 0 0
UUID=f881c99e-53c9-4085-b619-b3e9f2c5475a /mnt/ssd ext4 defaults,noatime 0 2
~~~

## 4. Root Crontab (Backups & Pruning)
~~~cron
# Every Sunday at 03:00 AM - Back up SSD configs & databases to the 4TB HDD
0 3 * * 0 /usr/local/bin/backup-mediaserver.sh

# Every Sunday at 04:00 AM - Delete dangling/old Docker images to save SSD space
0 4 * * 0 /usr/bin/docker image prune -f > /dev/null 2>&1
~~~

## 5. Docker Daemon Config (/etc/docker/daemon.json)
~~~json
{
  "data-root": "/mnt/ssd/docker",
  "dns": ["1.1.1.1", "8.8.8.8"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
~~~

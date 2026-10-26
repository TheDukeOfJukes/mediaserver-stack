# OptiPlex Media Server

## Hardware Layout
* **OS / Docker Engine:** 120GB SSD (`/mnt/ssd`)
* **Media / Transcodes:** 4TB HDD (`/mnt/media`)
* **RAM:** 8GB

## Deployment
1. Install Docker & Git.
2. Mount the SSD and HDD to their respective points.
3. Clone this repo to `/opt/mediaserver`.
4. Copy `.env.example` to `.env` and fill in the Mullvad keys.
5. Run `sudo docker compose up -d`.

## Maintenance Notes
* Docker logs are capped at 30MB via `/etc/docker/daemon.json`.
* Prometheus TSDB is capped at 5GB.
* Jellyfin transcodes are routed to the HDD to protect SSD flash cells.

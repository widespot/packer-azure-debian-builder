#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

#cat <<'EOF' | sudo tee /etc/apt/sources.list.d/bookworm-backports.sources
#Types: deb
#URIs: http://deb.debian.org/debian
#Suites: bookworm-backports
#Components: main contrib
#Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
#EOF

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y fasttrack-archive-keyring

echo "Types: deb
URIs: https://fasttrack.debian.net/debian-fasttrack
Suites: bookworm-fasttrack bookworm-backports-staging
Components: main contrib
Signed-By: /etc/apt/trusted.gpg.d/fasttrack-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/fasttrack.sources

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "linux-headers-$(uname -r)"
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y virtualbox
# Confirm is running
ls -l /dev/vboxdrv
VBoxManage --version

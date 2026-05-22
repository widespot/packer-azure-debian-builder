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
Signed-By: /usr/share/keyrings/fasttrack-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/fasttrack.sources

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y "linux-headers-$(uname -r)" linux-headers-cloud-amd64
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y virtualbox-dkms virtualbox

# Grant access to vboxusers
echo "==== Seed per-instance init script to add users to vboxusers group ..."
sudo mkdir -p /var/lib/cloud/scripts/per-instance/
cat <<EOF | sudo tee /var/lib/cloud/scripts/per-instance/add-default-user-to-vboxusers.sh
#!/usr/bin/env bash
# This script runs during the first boot of the VM instance

# Get the first user with UID 1000 (usually the default admin user in Azure)
DEFAULT_USER=\$(id -un 1000 2>/dev/null || true)

if [ -n "\$DEFAULT_USER" ]; then
    echo "==== Adding \$DEFAULT_USER to vboxusers group ..."
    usermod -aG vboxusers "\$DEFAULT_USER"
fi

if ! id AzDevOps >/dev/null 2>&1; then
  echo "==== AzDevOps doesn't exist, creating it ..."
  useradd -m -s /bin/bash AzDevOps
fi
echo "==== adding AzDevOps to vboxusers group ..."
usermod -aG vboxusers AzDevOps
EOF
sudo chmod +x /var/lib/cloud/scripts/per-instance/add-default-user-to-vboxusers.sh

# Load the kernel module
sudo modprobe vboxdrv

# Confirm is running
ls -l /dev/vboxdrv
VBoxManage --version

#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# UEFI firmware environment.
#sudo DEBIAN_FRONTEND=noninteractive apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ovmf

# Enable access to KVM
# We want to add the default user to the kvm group.
# Since the user is created at instantiation time, we use a cloud-init per-instance script.

echo "==== Ensure the cloud-init scripts directory exists ..."
sudo mkdir -p /var/lib/cloud/scripts/per-instance/

echo "==== Seed per-instance init script to add users to kvm group ..."
# Create the provisioning script
cat <<EOF | sudo tee /var/lib/cloud/scripts/per-instance/add-default-user-to-kvm.sh
#!/usr/bin/env bash
# This script runs during the first boot of the VM instance

# Get the first user with UID 1000 (usually the default admin user in Azure)
DEFAULT_USER=\$(id -un 1000 2>/dev/null || true)

if [ -n "\$DEFAULT_USER" ]; then
    echo "==== Adding \$DEFAULT_USER to kvm group ..."
    usermod -aG kvm "\$DEFAULT_USER"
fi

if ! id AzDevOps >/dev/null 2>&1; then
  echo "==== AzDevOps doesn't exist, creating it ..."
  useradd -m -s /bin/bash AzDevOps
fi
echo "==== adding AzDevOps to kvm group ..."
usermod -aG kvm AzDevOps

# Grant everyone access to kvm
echo "==== Adding an udev rule to grant everyone an access to kvm group ..."
cat <<RULE | sudo tee /etc/udev/rules.d/99-kvm.rules
KERNEL=="kvm", GROUP="kvm", MODE="0666"
RULE

echo "==== Reloading udev rules ..."
sudo udevadm control --reload-rules
echo "==== ... "
sudo udevadm trigger --name-match=kvm
echo "==== Display groups of  "
id AzDevOps

EOF

echo "Make per-instance init script executable ..."
sudo chmod +x /var/lib/cloud/scripts/per-instance/add-default-user-to-kvm.sh

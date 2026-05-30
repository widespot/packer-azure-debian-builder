#!/usr/bin/env bash

set -euo pipefail

echo "==== Ensure the cloud-init scripts directory exists ..."
sudo mkdir -p /var/lib/cloud/scripts/per-instance/

echo "==== Seed per-instance init script to grant passwordless sudo to AzDevOps ..."
cat <<EOF | sudo tee /var/lib/cloud/scripts/per-instance/add-azdo-sudo.sh >/dev/null
#!/usr/bin/env bash
set -euo pipefail

cat <<SUDOERS >/etc/sudoers.d/90-azdo-nopasswd
AzDevOps ALL=(ALL) NOPASSWD:ALL
SUDOERS
chmod 440 /etc/sudoers.d/90-azdo-nopasswd
EOF

echo "==== Make per-instance init script executable ..."
sudo chmod +x /var/lib/cloud/scripts/per-instance/add-azdo-sudo.sh

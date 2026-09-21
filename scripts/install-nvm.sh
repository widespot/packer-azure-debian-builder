#!/usr/bin/env bash

set -euo pipefail

echo "==== Clone nvm repository ..."
sudo git clone https://github.com/nvm-sh/nvm.git /opt/nvm
cd /opt/nvm
sudo git checkout "${nvm_version}"

echo "==== Create NVM user group ..."
sudo groupadd --system nvm 2>/dev/null || true

echo "==== Ensure NVM permissions and directory structure ..."
sudo chown -R root:nvm /opt/nvm
sudo chmod -R 775 /opt/nvm

echo "==== Configure global profile to load nvm ..."
sudo tee /etc/profile.d/nvm.sh > /dev/null <<'EOF'
export NVM_DIR="/opt/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
sudo chmod +x /etc/profile.d/nvm.sh

echo "==== Ensure the cloud-init scripts directory exists ..."
sudo mkdir -p /var/lib/cloud/scripts/per-instance/

echo "==== Create per-instance init script ..."
cat <<EOF | sudo tee /var/lib/cloud/scripts/per-instance/add-users-to-nvm.sh
#!/usr/bin/env bash
# This script runs during the first boot of the VM instance

# Get the first user with UID 1000 (usually the default admin user in Azure)
DEFAULT_USER=\$(id -un 1000 2>/dev/null || true)

if [ -n "\$DEFAULT_USER" ]; then
    echo "==== Adding \$DEFAULT_USER to nvm group ..."
    usermod -aG nvm "\$DEFAULT_USER"
fi

if ! id AzDevOps >/dev/null 2>&1; then
  echo "==== AzDevOps doesn't exist, creating it ..."
  useradd -m -s /bin/bash AzDevOps
fi
echo "==== adding AzDevOps to nvm group ..."
usermod -aG nvm AzDevOps

echo "==== Display groups of AzDevOps ..."
id AzDevOps

EOF
echo "==== Make per-instance init script executable ..."
sudo chmod +x /var/lib/cloud/scripts/per-instance/add-users-to-nvm.sh

echo "==== Init NVM and install Node.js ${nvm_node_version} ..."
sudo env NVM_DIR=/opt/nvm bash -c '
  set -e
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm --version
  nvm install ${nvm_node_version}
  nvm alias default ${nvm_node_version}
  nvm use default
'

echo "==== Ensure permissions for all users on installed versions ..."
sudo chown -R root:nvm /opt/nvm
sudo chmod -R 775 /opt/nvm

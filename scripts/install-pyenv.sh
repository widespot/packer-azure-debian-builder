#!/usr/bin/env bash

set -euo pipefail

echo "==== Clone pyenv repository ..."
sudo git clone https://github.com/pyenv/pyenv.git /opt/pyenv
cd /opt/pyenv
echo "==== Configure and make PyEnv ..."
sudo ./src/configure && sudo make -C src

echo "==== Create Pyenv user group"
sudo groupadd --system pyenv 2>/dev/null || true

echo "==== Ensure Pyenv shims and versions directory exists ..."
sudo mkdir -p /opt/pyenv/shims
sudo mkdir -p /opt/pyenv/versions
sudo chown -R root:pyenv /opt/pyenv
sudo chmod -R a+rX /opt/pyenv

echo "==== Configure global profile to load pyenv ..."
sudo tee /etc/profile.d/pyenv.sh > /dev/null <<'EOF'
export PYENV_ROOT=/opt/pyenv
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"

# Only initialize pyenv fully for users who can write to shims.
# Everyone else just gets the already-baked shims on PATH.
if [ -w "$PYENV_ROOT/shims" ]; then
  eval "$(pyenv init -)"
fi
EOF
sudo chmod +x /etc/profile.d/pyenv.sh

echo "==== Create per-instance init script ..."
cat <<EOF | sudo tee /var/lib/cloud/scripts/per-instance/add-users-to-pyenv.sh
#!/usr/bin/env bash
# This script runs during the first boot of the VM instance

# Get the first user with UID 1000 (usually the default admin user in Azure)
DEFAULT_USER=\$(id -un 1000 2>/dev/null || true)

if [ -n "\$DEFAULT_USER" ]; then
    echo "==== Adding \$DEFAULT_USER to pyenv group ..."
    usermod -aG pyenv "\$DEFAULT_USER"
fi

if ! id AzDevOps >/dev/null 2>&1; then
  echo "==== AzDevOps doesn't exist, creating it ..."
  useradd -m -s /bin/bash AzDevOps
fi
echo "==== adding AzDevOps to pyenv group ..."
usermod -aG pyenv AzDevOps

echo "==== Display groups of  "
id AzDevOps

EOF
echo "==== Make per-instance init script executable ..."
sudo chmod +x /var/lib/cloud/scripts/per-instance/add-users-to-pyenv.sh

echo "==== Init Pyenv ..."
export PYENV_ROOT=/opt/pyenv
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
pyenv --version

sudo apt-get update
sudo apt-get install -y \
  build-essential curl ca-certificates \
  libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
  libsqlite3-dev libffi-dev liblzma-dev xz-utils

echo "==== Pyenv install 3.12 ..."
sudo PYENV_ROOT=/opt/pyenv /opt/pyenv/bin/pyenv install 3.12.4
echo "==== Pyenv global 3.12.4 ..."
sudo PYENV_ROOT=/opt/pyenv /opt/pyenv/bin/pyenv global 3.12.4
echo "==== Pyenv rehash ..."
sudo PYENV_ROOT=/opt/pyenv /opt/pyenv/bin/pyenv rehash

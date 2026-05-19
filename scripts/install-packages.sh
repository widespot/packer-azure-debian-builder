#!/usr/bin/env bash
set -euo pipefail

lsb_release -a

export DEBIAN_FRONTEND=noninteractive

sudo DEBIAN_FRONTEND=noninteractive apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${PACKAGES}
sudo DEBIAN_FRONTEND=noninteractive apt-get autoremove -y
sudo DEBIAN_FRONTEND=noninteractive apt-get clean
sudo rm -rf /var/lib/apt/lists/*

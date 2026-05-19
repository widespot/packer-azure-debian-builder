#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

VERSION=1.15.3
echo "==== Download zip archive, checksum and checksum signature ..."
wget https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_linux_amd64.zip
wget https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_SHA256SUMS
wget https://releases.hashicorp.com/packer/${VERSION}/packer_${VERSION}_SHA256SUMS.sig
echo "==== Trust Hashicorp signing key ..."
gpg --keyserver keyserver.ubuntu.com --recv-keys C820C6D5CD27AB87
echo "==== Verify signature ..."
gpg --verify packer_${VERSION}_SHA256SUMS.sig packer_${VERSION}_SHA256SUMS
echo "==== Verify zip consistency ..."
sha256sum -c packer_${VERSION}_SHA256SUMS --ignore-missing
echo "==== Unzip binary ..."
unzip packer_${VERSION}_linux_amd64.zip
echo "==== Install binary ..."
sudo mv packer /usr/local/bin/

echo "==== Packer version ===="
packer --version

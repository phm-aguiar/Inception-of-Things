#!/bin/bash
set -euo pipefail

CLUSTER_NAME="iotcluster"

if command -v k3d >/dev/null 2>&1; then
	if k3d cluster list | awk '{print $1}' | grep -qx "${CLUSTER_NAME}"; then
		k3d cluster delete "${CLUSTER_NAME}"
	fi
fi

sudo rm -f /usr/local/bin/kubectl
sudo rm -f /usr/local/bin/k3d

if command -v apt >/dev/null 2>&1; then
	sudo apt remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
fi

sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker

echo "clean"

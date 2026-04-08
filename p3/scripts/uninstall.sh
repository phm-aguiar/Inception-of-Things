#!/bin/bash
set -e

k3d cluster delete iotcluster

sudo rm -f /usr/local/bin/kubectl

sudo rm -f /usr/local/bin/k3d

sudo apt remove --purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker

echo "clean"

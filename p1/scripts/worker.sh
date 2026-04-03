#!/bin/bash
set -e

while [ ! -f /vagrant/node-token ]; do
  echo "aguardando token..."
  sleep 3
done

TOKEN=$(cat /vagrant/node-token)

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent \
  --server=https://192.168.56.110:6443 \
  --token=${TOKEN} \
  --node-ip=192.168.56.111" sh -

#!/bin/bash
set -e

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --bind-address=192.168.56.110 \
  --advertise-address=192.168.56.110 \
  --node-ip=192.168.56.110" sh -

cp /var/lib/rancher/k3s/server/node-token /vagrant/node-token

# kubectl no sudo permission
mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:/sbin' >> /home/vagrant/.bashrc

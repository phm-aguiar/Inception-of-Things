#!/bin/bash
set -e

# Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# K3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# cluster
k3d cluster create iotcluster \
  --port "8080:80@loadbalancer" \
  --port "8443:443@loadbalancer"

k3d kubeconfig merge iotcluster --kubeconfig-switch-context

kubectl wait --for=condition=Ready node --all --timeout=120s

kubectl create namespace argocd
kubectl create namespace dev

kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Ready pod --all -n argocd --timeout=300s

echo "Argo CD admin password:"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
echo

kubectl apply -f ../confs/app.yaml

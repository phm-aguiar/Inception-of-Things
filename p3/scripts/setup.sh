#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CLUSTER_NAME="iotcluster"

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists docker; then
  curl -fsSL https://get.docker.com | sh
fi

if ! id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
  sudo usermod -aG docker "$USER"
fi

if ! command_exists k3d; then
  curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

if ! command_exists kubectl; then
  tmp_kubectl="${ROOT_DIR}/kubectl"
  curl -fsSLo "${tmp_kubectl}" "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  chmod +x "${tmp_kubectl}"
  sudo mv "${tmp_kubectl}" /usr/local/bin/kubectl
fi

if ! k3d cluster list | awk '{print $1}' | grep -qx "${CLUSTER_NAME}"; then
  k3d cluster create "${CLUSTER_NAME}" \
    --port "8080:80@loadbalancer" \
    --port "8443:443@loadbalancer"
fi

k3d kubeconfig merge "${CLUSTER_NAME}" --kubeconfig-switch-context
kubectl wait --for=condition=Ready node --all --timeout=120s

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace dev --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -n argocd --server-side -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=300s

kubectl apply -f "${ROOT_DIR}/confs/argocd.yaml"
kubectl apply -f "${ROOT_DIR}/confs/project.yaml"

if kubectl get secret argocd-initial-admin-secret -n argocd >/dev/null 2>&1; then
  echo "Argo CD admin password:"
  kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
  echo
fi

kubectl apply -f "${ROOT_DIR}/confs/app.yaml"

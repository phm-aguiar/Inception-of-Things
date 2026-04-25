#!/bin/bash
set -euo pipefail

if ! command -v kubectl >/dev/null 2>&1; then
	echo "kubectl not found"
	exit 1
fi

echo "=== Checking cluster ==="
kubectl get nodes

echo
echo "=== Checking namespaces ==="
kubectl get namespaces | grep -E "argocd|dev"

echo
echo "=== Checking ArgoCD pods ==="
kubectl get pods -n argocd

echo
echo "=== Checking dev pods ==="
kubectl get pods -n dev

echo
echo "=== Checking image tags (v1/v2) in dev ==="
kubectl get deploy -n dev -o jsonpath='{..image}' | tr ' ' '\n' | grep -E ':(v1|v2)$'


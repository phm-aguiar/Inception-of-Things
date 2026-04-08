#!/bin/bash

echo "=== Checking cluster ==="
kubectl get nodes

echo ""
echo "=== Checking namespaces ==="
kubectl get namespaces | grep -E "argocd|dev"

echo ""
echo "=== Checking ArgoCD pods ==="
kubectl get pods -n argocd

echo ""
echo "=== Checking dev pods ==="
kubectl get pods -n dev


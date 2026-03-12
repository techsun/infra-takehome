#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Installing ArgoCD"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --server-side -k argocd/argocd/

echo "==> Waiting for ArgoCD server to be ready"
kubectl wait --for=condition=available --timeout=120s deployment/argocd-server -n argocd

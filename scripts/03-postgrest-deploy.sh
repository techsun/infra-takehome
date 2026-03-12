#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Applying ArgoCD Application"
kubectl apply -f argocd/postgrest/application.yaml

echo "==> Waiting for ArgoCD to sync and PostgREST to become healthy"
for i in $(seq 1 24); do
  STATUS=$(kubectl get application postgrest -n argocd -o jsonpath='{.status.sync.status}' 2>/dev/null || echo "")
  HEALTH=$(kubectl get application postgrest -n argocd -o jsonpath='{.status.health.status}' 2>/dev/null || echo "")
  if [ "$STATUS" = "Synced" ] && [ "$HEALTH" = "Healthy" ]; then
    echo "PostgREST is synced and healthy"
    break
  fi
  echo "  sync=$STATUS health=$HEALTH — retrying in 5s..."
  sleep 5
  if [ "$i" = "24" ]; then
    echo "Timed out waiting for ArgoCD sync" >&2
    exit 1
  fi
done

kubectl wait --for=condition=available --timeout=60s deployment/postgrest -n postgrest

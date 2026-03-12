#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

echo "==> Running seed data job"
kubectl apply -f k8s/jobs/seed-data.yaml
kubectl wait --for=condition=complete job/seed-data -n postgrest --timeout=60s

echo "==> Reloading PostgREST schema cache"
kubectl rollout restart deployment/postgrest -n postgrest
kubectl rollout status deployment/postgrest -n postgrest

echo "==> Done — PostgREST is available at http://localhost:8080/products"

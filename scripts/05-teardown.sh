#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT/tofu"

export DOCKER_HOST
DOCKER_HOST=$(docker context inspect --format '{{.Endpoints.docker.Host}}' "$(docker context show)")

echo "==> Preparing for teardown"

# Drop kubernetes resources from state if Step 2 was applied
tofu state rm kubernetes_secret.postgrest_db_credentials kubernetes_namespace.postgrest 2>/dev/null || true

# Undo Step 2 file changes so the kubernetes provider doesn't block destroy
[ -f kubernetes.tf ] && mv kubernetes.tf kubernetes.tf.off
git -C "$REPO_ROOT" checkout -- tofu/versions.tf

echo "==> Destroying infrastructure"
tofu destroy -auto-approve

echo "==> Done"

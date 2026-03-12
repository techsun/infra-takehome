#!/bin/bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT/tofu"

export DOCKER_HOST
DOCKER_HOST=$(docker context inspect --format '{{.Endpoints.docker.Host}}' "$(docker context show)")

echo "==> Step 1: provisioning cluster and database"
tofu init -input=false
tofu apply -auto-approve

echo "==> Step 2: enabling Kubernetes namespace and secret"
[ -f kubernetes.tf.off ] && mv kubernetes.tf.off kubernetes.tf
sed -i '' -e '/# Uncomment for Step 2:/d' -e 's/    # /    /' versions.tf
tofu init -input=false
tofu apply -auto-approve

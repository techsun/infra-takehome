#!/bin/bash
set -euo pipefail

SCRIPTS_DIR="$(cd "$(dirname "$0")" && pwd)"

"$SCRIPTS_DIR/01-tofu-provision.sh"
"$SCRIPTS_DIR/02-argocd-install.sh"
"$SCRIPTS_DIR/03-postgrest-deploy.sh"
"$SCRIPTS_DIR/04-seed.sh"

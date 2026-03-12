# tofu

Provisions the local k3d cluster, PostgreSQL instance, and associated Kubernetes resources using OpenTofu (or Terraform).

## Prerequisites

- Docker runtime
- k3d CLI
- opentofu or terraform binary
- kubectl binary

## What this provisions

- A k3d cluster with a loadbalancer mapping host port 8080 to cluster port 80
- A PostgreSQL Docker container with a `postgrest` database and an `authenticator` superuser
- A `postgrest` Kubernetes namespace and a secret containing the PostgREST database credentials

## Apply

The Kubernetes provider requires the k3d cluster to exist before it can initialise. To handle this, `kubernetes.tf.off` is excluded from the first apply by convention — the `.off` extension causes OpenTofu to ignore the file.

### Step 1 — cluster and database

```bash
tofu init
tofu apply
```

### Step 2 — Kubernetes namespace and secret

Once the cluster is up and the `k3d-infra-takehome` kubeconfig context exists, enable the Kubernetes resources:

```bash
mv kubernetes.tf.off kubernetes.tf
```

Uncomment the `kubernetes` block in `versions.tf`, then:

```bash
tofu init
tofu apply
```

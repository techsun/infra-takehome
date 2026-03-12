## Install ArgoCD

```bash
kubectl create namespace argocd
kubectl apply --server-side -k argocd/
```

Wait for ArgoCD to be ready:

```bash
kubectl wait --for=condition=available --timeout=120s deployment/argocd-server -n argocd
```

## Deploy PostgREST

Apply the ArgoCD Application. ArgoCD will sync the local Helm chart and deploy PostgREST into the `postgrest` namespace:

```bash
kubectl apply -f argocd/postgrest/application.yaml
```

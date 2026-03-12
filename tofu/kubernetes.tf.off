provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "k3d-${var.k3d_cluster_name}"
}

resource "kubernetes_namespace" "postgrest" {
  metadata {
    name = "postgrest"
  }
  depends_on = [terraform_data.k3d_cluster]
}

resource "kubernetes_secret" "postgrest_db_credentials" {
  metadata {
    name      = "postgrest-db-credentials"
    namespace = kubernetes_namespace.postgrest.metadata[0].name
  }

  data = {
    PGRST_DB_URI        = "postgres://authenticator:${var.postgres_password}@host.k3d.internal:${var.postgres_port}/postgrest"
    PGRST_DB_SCHEMA     = "public"
    PGRST_DB_ANON_ROLE  = "authenticator"
  }
}

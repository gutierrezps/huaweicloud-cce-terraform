resource "kubernetes_cluster_role_binding_v1" "cluster_admin" {
  for_each = toset(var.cluster_admin_user_ids)
  metadata {
    name = "clusterrole_cluster-admin_user${each.value}"
    annotations = {
      "CCE.com/IAM" = true
    }
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
  }
}

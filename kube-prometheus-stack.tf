resource "helm_release" "kube-prometheus-stack" {
  name       = "kube-prometheus-stack"
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  namespace  = "monitoring"
  version    = "62.7.0"

  create_namespace = true

  depends_on = [
    helm_release.ingress-nginx
  ]
}
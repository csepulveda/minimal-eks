resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.15.3"
  namespace  = "cert-manager"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = true
  }
}

resource "kubectl_manifest" "cert-manager-cluster-issuer" {
  yaml_body = <<-YAML
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: cesar.sepulveda.b@gmail.com
        privateKeySecretRef:
          name: letsencrypt
        solvers:
          - http01:
              ingress:
                class: nginx
  YAML

  depends_on = [
    helm_release.cert-manager
  ]
}
resource "helm_release" "keda" {
  name       = "keda"
  chart      = "keda"
  repository = "https://kedacore.github.io/charts"
  namespace  = "keda"
  version    = "2.15.1"

  create_namespace = true

  set {
    name  = "serviceAccount.operator.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.eks_keda_iam.iam_role_arn
  }

  depends_on = [
    helm_release.ingress-nginx
  ]
}

module "eks_keda_iam" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.44.0"

  role_name = "keda"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["keda:keda-operator"]
    }
  }

  role_policy_arns = {
    AmazonSQSFullAccess = aws_iam_policy.keda-policy.arn
  }

}

resource "aws_iam_policy" "keda-policy" {
  name        = "keda-policy"
  path        = "/"
  description = ""

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "sqs:GetQueueAttributes"
        ],
        "Effect" : "Allow",
        "Resource" : "*",
        "Sid" : "SQS"
      }
    ],
    "Version" : "2012-10-17"
  })
}
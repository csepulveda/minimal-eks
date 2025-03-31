module "eks_sqs_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.54.0"

  role_name = "sqs-role"

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["default:sqs-service-account"]
    }
  }

  role_policy_arns = {
    AmazonSQSFullAccess = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  }
  depends_on = [
    helm_release.ingress-nginx
  ]
}


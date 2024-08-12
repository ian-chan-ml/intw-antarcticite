module "antarticite-eks-1-karpenter" {
  source = "../../../../modules/eks/karpenter"

  cluster_name           = module.antarticite-eks-1.cluster_name
  irsa_oidc_provider_arn = module.antarticite-eks-1.oidc_provider_arn
  tags = {
    Name = "${module.antarticite-eks-1.cluster_name}-karpenter"
  }
}

module "lb_controller_irsa" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "~> 5.0"
  create_role                            = true
  role_name                              = "AWSLBController-${module.antarticite-eks-1.cluster_name}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.antarticite-eks-1.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
  tags = {
    Name = "AWSLBController-${module.antarticite-eks-1.cluster_name}"
  }
}


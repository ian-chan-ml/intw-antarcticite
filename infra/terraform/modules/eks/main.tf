provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 5
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

data "aws_availability_zones" "available" {}
data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.us_east_1
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "v20.8.5"

  cluster_name    = var.name
  cluster_version = var.cluster_version

  # Gives Terraform identity admin access to cluster which will
  # allow deploying resources (Karpenter) into the cluster
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  iam_role_name = var.name

  enable_cluster_creator_admin_permissions = true # grants eks admin to scalr
  authentication_mode                      = "API"
  access_entries = merge(
    local.global_admin_roles,
  )


  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_driver_role.iam_role_arn
      most_recent              = true
    }
  }

  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnets.private.ids

  eks_managed_node_groups = {
    std = {
      name                 = "${substr(var.name, 0, 11)}-std"
      launch_template_name = "${var.name}-std-lt"
      use_name_prefix      = false
      capacity_type        = "ON_DEMAND"
      min_size             = 3
      max_size             = 3
      desired_size         = 3
      tags = {
        Environment = "production"
      }
    }
  }

  node_security_group_additional_rules = merge(
    {
      ingress_node_all = {
        description = "Ingress all from self"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "ingress"
        self        = true
      }

      ingress_cluster_all = {
        description                   = "Ingress all from cluster"
        protocol                      = "-1"
        from_port                     = 0
        to_port                       = 0
        type                          = "ingress"
        source_cluster_security_group = true
      }

      # By default the EKS terraform module only whitelists DNS queries coming from itself via the node sg.
      # If a pod is assigned a sg, it would get blocked; this is why we whitelist the whole VPC cidr block.
      dns_udp_ingress = {
        description = "Allow DNS UDP queries to CoreDNS - required for pods with sg"
        protocol    = "udp"
        from_port   = 53
        to_port     = 53
        type        = "ingress"
        cidr_blocks = [data.aws_vpc.this.cidr_block]
      }

      dns_tcp_ingress = {
        description = "Allow DNS TCP queries to CoreDNS - required for pods with sg"
        protocol    = "tcp"
        from_port   = 53
        to_port     = 53
        type        = "ingress"
        cidr_blocks = [data.aws_vpc.this.cidr_block]
      }

      egress_all = {
        description = "Egress all to the internet"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "egress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    },
    var.node_security_group_additional_rules,
  )

  node_security_group_tags = merge({
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = var.name
  })

  eks_managed_node_group_defaults = merge({
    enable_monitoring = true
  }, var.eks_managed_node_group_defaults)

}

module "ebs_csi_driver_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = "true"
  role_name             = "${var.name}-ebs-csi-driver"
  attach_ebs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${coalesce(module.eks.oidc_provider, "throwaway")}"
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa", "kube-system:ebs-csi-node-sa"]
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-ebs-csi-driver"
  })
}


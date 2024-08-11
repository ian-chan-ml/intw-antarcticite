data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_iam_roles" "admin" {
  name_regex = "AWSReservedSSO_Admins_.+"
}

data "aws_vpc" "this" {
  id = "vpc-0cb35e70f02cbf8a9"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Usage"
    values = ["private"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.key
}

locals {
  partition        = data.aws_partition.current.partition
  admin_policy_arn = "arn:${local.partition}:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  admin_policy_assoc = {
    admin = {
      policy_arn = local.admin_policy_arn
      access_scope = {
        type = "cluster"
      }
    }
  }

  global_admin_roles = {
    for principal_arn in data.aws_iam_roles.admin.arns : principal_arn => {
      principal_arn       = principal_arn
      user_name           = "Admin"
      policy_associations = local.admin_policy_assoc
    }
  }
}

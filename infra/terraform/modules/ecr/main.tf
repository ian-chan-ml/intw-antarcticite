locals {
  region = "us-east-1"
  name   = "ecr-ex-${replace(basename(path.cwd), "_", "-")}"

  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Name       = var.name
    Example    = var.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-ecr"
  }
}

data "aws_caller_identity" "current" {}


module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.2.1"

  repository_name = var.name

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = var.create_lifecycle_policy
  repository_lifecycle_policy = jsonencode({
    rules = var.create_lifecycle_policy == true ? [
      {
        rulePriority = 1,
        description  = "Keep last 99 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 99
        },
        action = {
          type = "expire"
        }
      }
    ] : []
  })
  repository_force_delete = true

  tags = var.tags
}

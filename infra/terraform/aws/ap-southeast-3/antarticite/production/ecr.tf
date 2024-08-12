module "antarticite_be_ecr" {
  source = "../../../../modules/ecr"
  providers = {
    aws = aws
  }

  name = "antarticite-be"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

module "antarticite_fe_ecr" {
  source = "../../../../modules/ecr"
  providers = {
    aws = aws
  }

  name = "antarticite-fe"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

module "antarticite_be_ecr_southeast1" {
  source = "../../../../modules/ecr"
  providers = {
    aws = aws.ap_southeast_1
  }

  name = "antarticite-be"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

module "antarticite_fe_ecr_southeast1" {
  source = "../../../../modules/ecr"
  providers = {
    aws = aws.ap_southeast_1
  }

  name = "antarticite-fe"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

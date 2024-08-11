module "antarticite_be_ecr" {
  source = "../../../../modules/ecr"

  name = "antarticite-be"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

module "antarticite_fe_ecr" {
  source = "../../../../modules/ecr"

  name = "antarticite-fe"

  repository_force_delete = true
  create_lifecycle_policy = true

  tags = {
    Owner = "quanianitis@gmail.com"
  }
}

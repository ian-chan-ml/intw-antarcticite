moved {
  from = module.antarticite
  to   = module.antarticite_rds
}

module "antarticite_rds" {
  source = "../../../../modules/rds"

  name          = "antarticite"
  database_name = "antarticite"

  engine_version = "16.1"
  instance_class = "db.t4g.medium"

  env                  = "prod"
  db_subnet_group_name = "ex-prod-antarticite"

  // test cluster
  backup_retention_period = 1

  additional_security_group_rules = {}
}

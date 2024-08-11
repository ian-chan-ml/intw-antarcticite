# Wrap around the rds-aurora module, but set defaults specific to our use case
module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  name           = var.name
  engine         = "aurora-postgresql"
  engine_version = var.engine_version
  engine_mode    = var.engine_mode
  instance_class = var.instance_class
  database_name  = var.database_name

  # If restore snapshot, reuse the master user from the snapshot
  master_username = var.snapshot_identifier == null ? var.master_username : null

  instances = merge(
    # At least one node is the writer. Note we do not use the term "writer" and "reader"
    # to identify the DB instances as their roles interchange in the event of a failover.
    { "db1" = {} },
    # Additional nodes start as db2, db3, etc.
    { for i in range(2, var.read_replica_count + 2) : "db${i}" => {} }
  )


  # Need to be modified
  vpc_id               = data.aws_vpc.this.id
  db_subnet_group_name = var.db_subnet_group_name

  publicly_accessible = false
  apply_immediately   = true

  create_security_group      = true
  security_group_name        = "${var.name}-security-group"
  security_group_description = "${var.name} Aurora RDS Cluster Security Group"
  security_group_rules = merge(
    {
      private_subnets = {
        description = "Allow inbound connections from the private subnets"
        cidr_blocks = values(data.aws_subnet.private)[*].cidr_block
      }
      # db_subnets = {
      #   description = "Allow inbound connections from the db subnets"
      #   cidr_blocks = values(data.aws_subnet.db)[*].cidr_block
      # }
      egress = {
        description = "Allow outbound connections within VPC"
        type        = "egress"
        to_port     = 0
        from_port   = 0
        protocol    = "-1"
        cidr_blocks = [
          # Limit DB's network access to only to VPC CIDR; this is
          # to protect against data exfiltration attacks
          data.aws_vpc.this.cidr_block
        ]
      }
    },
    var.additional_security_group_rules
  )

  performance_insights_enabled = true
  monitoring_interval          = var.monitoring_interval

  snapshot_identifier       = var.snapshot_identifier
  final_snapshot_identifier = "${var.name}-snapshot-final"
  restore_to_point_in_time  = var.restore_to_point_in_time

  manage_master_user_password         = true
  iam_database_authentication_enabled = true

  kms_key_id        = module.kms.key_arn
  storage_encrypted = true
  storage_type      = var.storage_type

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window

  enabled_cloudwatch_logs_exports = ["postgresql"]
  create_cloudwatch_log_group     = true

  create_db_cluster_parameter_group = true
  create_db_parameter_group         = true

  db_cluster_parameter_group_family = "aurora-postgresql16"
  db_cluster_parameter_group_name   = "${var.name}-cluster"

  db_parameter_group_family = "aurora-postgresql16"
  db_parameter_group_name   = "${var.name}-instance"

  # autoscaling
  autoscaling_enabled            = var.autoscaling_enabled
  autoscaling_max_capacity       = var.autoscaling_max_capacity
  autoscaling_min_capacity       = var.autoscaling_min_capacity
  autoscaling_policy_name        = var.autoscaling_policy_name
  predefined_metric_type         = var.predefined_metric_type
  autoscaling_scale_in_cooldown  = var.autoscaling_scale_in_cooldown
  autoscaling_scale_out_cooldown = var.autoscaling_scale_out_cooldown
  autoscaling_target_cpu         = var.autoscaling_target_cpu
  autoscaling_target_connections = var.autoscaling_target_connections
  copy_tags_to_snapshot          = var.copy_tags_to_snapshot
}

module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~>1.0"

  aliases     = ["rds/${var.name}"]
  description = "KMS key for ${var.name} RDS cluster"
}

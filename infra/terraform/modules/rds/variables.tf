variable "name" {
  description = "Name used across resources created"
  type        = string
  default     = ""
}

variable "master_username" {
  description = "Username for the master DB user. Required unless `snapshot_identifier` or `replication_source_identifier` is provided or unless a `global_cluster_identifier` is provided when the cluster is the secondary cluster of a global database"
  type        = string
  default     = "master"
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage"
  type        = string
  default     = null
}


variable "engine_mode" {
  description = "The database engine mode. Valid values: `global`, `multimaster`, `parallelquery`, `provisioned`, `serverless`. Defaults to: `provisioned`"
  type        = string
  default     = "provisioned"
}

variable "instance_class" {
  description = "Instance type to use at master instance. Note: if `autoscaling_enabled` is `true`, this will be the same instance class used on instances created by autoscaling"
  type        = string
  default     = "db.t4g.medium"
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = null
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "additional_security_group_rules" {
  description = "Map of additional security group rules to add to the cluster security group created"
  type        = any
  default     = {}
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot"
  type        = string
  default     = null
}

variable "storage_type" {
  description = "Determines the storage type for the DB cluster. Optional for Single-AZ, required for Multi-AZ DB clusters. Valid values for Single-AZ: `aurora`, `\"\"` (default, both refer to Aurora Standard), `aurora-iopt1` (Aurora I/O Optimized). Valid values for Multi-AZ: `io1` (default)."
  type        = string
  default     = null
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the `backup_retention_period` parameter. Time in UTC"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC)"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "read_replica_count" {
  description = "Number of read replicas"
  type        = number
  default     = 0
}

variable "backup_retention_period" {
  description = "The days to retain backups for. Default `30`"
  type        = number
  default     = 30
}


variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for instances. Set to `0` to disable. Default is `60`"
  type        = number
  default     = 60
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to `true`. The default is `true` for production environment, false otherwise"
  type        = bool
  default     = null
}

variable "db_parameter_group_name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "The name of the DB cluster parameter group"
  type        = string
  default     = null
}

################################################################################
# Autoscaling
################################################################################

variable "autoscaling_enabled" {
  description = "Determines whether autoscaling of the cluster read replicas is enabled"
  type        = bool
  default     = false
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of read replicas permitted when autoscaling is enabled"
  type        = number
  default     = 2
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of read replicas permitted when autoscaling is enabled"
  type        = number
  default     = 0
}

variable "autoscaling_policy_name" {
  description = "Autoscaling policy name"
  type        = string
  default     = "target-metric"
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are `RDSReaderAverageCPUUtilization` and `RDSReaderAverageDatabaseConnections`"
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
}

variable "autoscaling_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "autoscaling_target_cpu" {
  description = "CPU threshold which will initiate autoscaling"
  type        = number
  default     = 70
}

variable "autoscaling_target_connections" {
  description = "Average number of connections threshold which will initiate autoscaling. Default value is 70% of db.r4/r5/r6g.large's default max_connections"
  type        = number
  default     = 700
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window. Default is `true`"
  type        = bool
  default     = true
}

variable "restore_to_point_in_time" {
  description = "Map of nested attributes for cloning Aurora cluster"
  type        = map(string)
  default     = {}
}

variable "copy_tags_to_snapshot" {
  description = "Copy all tags to snapshots"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  type = string
}

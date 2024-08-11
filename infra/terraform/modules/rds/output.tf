################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.cluster.cluster_arn
}

output "cluster_id" {
  description = "The RDS Cluster Identifier"
  value       = module.cluster.cluster_id
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.cluster.cluster_resource_id
}

output "cluster_members" {
  description = "List of RDS Instances that are a part of this cluster"
  value       = module.cluster.cluster_members
}

output "endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.cluster.cluster_endpoint
}

output "reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced across replicas"
  value       = module.cluster.cluster_reader_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.cluster.cluster_engine_version_actual
}

output "cluster_database_name" {
  description = "Name for created database on cluster creation"
  value       = module.cluster.cluster_database_name
}

output "cluster_port" {
  description = "The database port"
  value       = module.cluster.cluster_port
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = module.cluster.cluster_hosted_zone_id
}

output "cluster_master_username" {
  description = "The database master username"
  value       = module.cluster.cluster_master_username
}

output "cluster_master_user_secret" {
  description = "The generated database master user secret when `manage_master_user_password` is set to `true`"
  value       = module.cluster.cluster_master_user_secret[0]
}

################################################################################
# Cluster Instance(s)
################################################################################

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.cluster.cluster_instances
}

################################################################################
# Cluster Endpoint(s)
################################################################################

output "additional_cluster_endpoints" {
  description = "A map of additional cluster endpoints and their attributes"
  value       = module.cluster.additional_cluster_endpoints
}

################################################################################
# Cluster IAM Roles
################################################################################

output "cluster_role_associations" {
  description = "A map of IAM roles associated with the cluster and their attributes"
  value       = module.cluster.cluster_role_associations
}

################################################################################
# Security Group
################################################################################

output "security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.cluster.security_group_id
}

################################################################################
# CloudWatch Log Group
################################################################################

output "db_cluster_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.cluster.db_cluster_cloudwatch_log_groups
}
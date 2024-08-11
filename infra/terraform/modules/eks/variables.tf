variable "name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "node_security_group_additional_rules" {
  type    = map(any)
  default = {}
}

variable "eks_managed_node_group_defaults" {
  type    = map(any)
  default = {}
}

variable "tags" {
  type    = map(any)
  default = {}
}

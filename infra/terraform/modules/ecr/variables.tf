variable "name" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "repository_force_delete" {
  type = bool
}

variable "create_lifecycle_policy" {
  type = bool
}

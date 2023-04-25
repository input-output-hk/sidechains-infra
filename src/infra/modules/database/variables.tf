variable "databases" {
  type = list(object({
    name       = string
    extensions = optional(list(string), [])
    count      = optional(number, 1)
  }))
  description = "A list of databases to create"
}

variable "db_cluster_id" {
  type        = string
  description = "The ID of the RDS Aurora Cluster"
}

variable "environment" {
  type        = string
  description = "The name of the environment to scope secret access to"
}

variable "permissions" {
  type        = any
  description = "A map of group names to their respective permissions"
}

variable "label" {
  type = object({
    namespace   = optional(string)
    environment = optional(string)
    stage       = optional(string)
    name        = optional(string)
    attributes  = optional(list(string))
    delimiter   = optional(string)
    tags        = optional(map(string))
  })
  description = "The label to use for this module"
}

variable "policy_templates" {
  type        = any
  description = "A map of common policy templates to use"
}

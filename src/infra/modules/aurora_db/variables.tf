variable "deletion_protection" {
  type        = bool
  description = "If true, prevents the RDS instance from being deleted"
  default     = false
}

variable "engine" {
  type        = string
  description = "The database engine to configure"
  default     = "aurora-postgresql"
}

variable "cluster_family" {
  type        = string
  description = "The database engine family"
  default     = "aurora-postgresql14"
}

variable "engine_version" {
  type        = string
  description = "The database engine version to use"
  default     = "14.6"
}

variable "permissions" {
  type        = any
  description = "A map of group names to their respective permissions"
}

variable "username" {
  type        = string
  description = "The username to use for the master user"
  default     = "root"
}

# variable "vpc_cidr" {
#   type        = string
#   description = "The CIDR of the VPC"
# }

# variable "vpc_subnet_group" {
#   type        = string
#   description = "The name of the database subnet group to use"
# }

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to use"
}

variable "port" {
  type        = number
  description = "Port Number for DB"
  default     = 5432
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

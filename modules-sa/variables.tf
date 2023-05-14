variable "project" {
  description = "project code which used to compose the resource name"
  type        = string
  default     = ""
}

variable "env" {
  description = "environment: dev, stg, qa, prod "
  type        = string
  default     = ""
}

variable "region" {
  description = "aws region to build network infrastructure"
  type        = string
  default     = ""
}

variable "account_id" {
  description = "account id. e.g. aws account id: 123456789012"
  type        = string
  default     = ""
}

variable "oidc_provider" {
  description = "oidc provider"
  type = object({
    provider = string
    url      = string
    arn      = string
  })
  default = {
    provider = ""
    arn      = ""
    url      = ""
  }
}

variable "cluster_name" {
  description = "kubernetes cluster name"
  type        = string
  default     = ""
}

variable "role_arn" {
  type        = string
  default     = ""
}

variable "service_account" {
  description = "service account"
  type = object({
    name            = string
    namespace       = string
    automount_token = bool

  })
}

# variable "service_account" {
#   description = "service account"
#   type        = any
# }

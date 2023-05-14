############################################
# version of terraform and providers
############################################
terraform {
  cloud {
    # organization = "schan-test"
    organization = "MZC-ORG"

    workspaces {}
  }
}

# terraform {
#   required_version = ">= 1.0"
#   required_providers {
#     helm = {
#       source  = "hashicorp/helm"
#       version = ">= 2.5"
#     }
#   }
# }

############################################
# Provider Configuration
############################################
provider "aws" {
  region  = var.aws_region
  # profile = var.aws_profile

}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
  host                   = local.eks_endpoint_url
  token                  = local.eks_auth_token
}

provider "helm" {
	kubernetes {
		cluster_ca_certificate = base64decode(local.eks_cluster_certificate_authority_data)
		host                   = local.eks_endpoint_url
		token									 = local.eks_auth_token
	}
}

################### role_name suffix ####################################################################
resource "random_string" "x" {
  length  = 3
  special = false
  upper   = false
}

# random_string.x.result
#######################################################################################




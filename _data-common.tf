locals {
  region                    = var.aws_region
  # eks_package_bucket_name   = var.backend_s3_bucket_name
  # eks_package_bucket_key    = var.eks_s3_key
  # eks_package_bucket_region = local.region
  # eks_tfstat_path           = var.eks_tfstat_path

  eks_auth_token                         = data.aws_eks_cluster_auth.cluster.token
  eks_cluster_name                       = var.cluster_name == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_name : var.cluster_name
  eks_endpoint_url                       = var.eks_endpoint_url == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_endpoint : var.eks_endpoint_url
  eks_cluster_certificate_authority_data = var.eks_cluster_certificate_authority_data == "" ? data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data : var.eks_cluster_certificate_authority_data

  oidc_provider_arn                      = var.oidc_provider_arn == "" ? data.terraform_remote_state.eks.outputs.eks_oidc_provider_arn : var.oidc_provider_arn

  common_tags = merge(var.default_tags, {
    "region"  = var.aws_region
    "project" = var.project
    "env"     = var.env
    "managed" = "terraform"
  })
}

############################# data :  #######################################

data "terraform_remote_state" "eks" {
  # count = var.vpc_id == "" ? 1 : 0
  # tfstate outputs-list :
  # how to get : data.terraform_remote_state.eks.0.outputs.xxx
  backend = "remote"
  config = {
    organization = var.tfc_org
    workspaces = {
      name = var.tfc_wk
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = local.eks_cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.eks_cluster_name
}

############################################


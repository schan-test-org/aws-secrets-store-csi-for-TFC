locals {
  role_name  = "${var.namespace["ns-app-pod"]}-${random_string.x.result}"
  role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.role_name}"

  each_sa = { for x in var.service_accounts : format("%s_%s", x.name, x.namespace) => x }

  service_account_names = {
    # sa-pod       = "eks-deployment-sa"
    # sa-default       = "test-sa"
    # sa-system        = "kube-sys-sa"
    sa-pod       = local.each_sa["eks-deployment-sa_acp"].name
    sa-default       = local.each_sa["test-sa_default"].name
    sa-system        = local.each_sa["kube-sys-sa_kube-system"].name
  }

}



################################################################################
# IRSA Roles
################################################################################

module "secrets_manager_role_deploy" {
  count = var.create_deploy_irsa ? 1 : 0
  source  = "./modules-irsa-eks"

  role_name = local.role_name
  # role_name_prefix = coalesce(var.iam_role_name, "${var.namespace["ns-app-pod"]}-deploy-")
  role_description = "EKS Cluster ${local.eks_cluster_name} Secret Manager Deploy role"

  attach_external_secrets_policy        = true
  external_secrets_ssm_parameter_arns   = var.external_secrets_ssm_parameter_arns
  external_secrets_secrets_manager_arns = var.external_secrets_secrets_manager_arns

  oidc_providers = {
    main = {
      provider_arn               = local.oidc_provider_arn
      namespace_service_accounts = [
        # "${var.namespace["ns-app-pod"]}:${var.service_account_names["sa-pod"]}",
        # "${var.namespace["ns-default"]}:${var.service_account_names["sa-default"]}"
        "${var.namespace["ns-app-pod"]}:${local.service_account_names.sa-pod}",
        "${var.namespace["ns-default"]}:${local.service_account_names.sa-default}"
      ]

      # namespace_service_accounts = ["${var.namespace}:${local.service_account_name}"]
    }
  }
}

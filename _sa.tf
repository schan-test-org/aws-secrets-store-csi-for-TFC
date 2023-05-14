
module "service_accounts" {

  depends_on = [
    module.secrets_manager_role_deploy
  ]

  for_each = { for x in var.service_accounts : format("%s-%s", x.name, x.namespace) => x }
  source   = "./modules-sa"

  project      = var.project
  env          = var.env
  region       = var.aws_region
  account_id   = data.aws_caller_identity.current.id
  cluster_name = local.eks_cluster_name
  # cluster_name = data.aws_eks_cluster.cluster.name
  role_arn = local.role_arn

  service_account = {
    name            = each.value.name
    namespace       = each.value.namespace
    automount_token = try(each.value.automount_token, true)

    # iam_role = {
    #   is_need                = try(each.value.iam_role.is_need, false)
    #   create                 = try(each.value.iam_role.is_need, false) ? try(each.value.iam_role.create, false) : false
    #   name                   = try(each.value.iam_role.name, format("%s-%s-%s-%s-%s-sa-role", var.cluster_name, var.env, var.project, each.value.namespace, each.value.name))
    #   exist_managed_policies = try(each.value.iam_role.is_need, false) ? length(try(each.value.iam_role.exist_managed_policies, [])) > 0 ? each.value.iam_role.exist_managed_policies : [] : []
    # }

    # external_secret = {
    #   is_need     = try(each.value.external_secret.is_need, false)
    #   create      = try(each.value.external_secret.is_need, false) ? try(each.value.external_secret.create, false) : false
    #   policy_name = format("%s-%s-%s-%s-external-secrets-policy", var.cluster_name, var.env, var.project, try(each.value.external_secret.name, ""))

    #   object_name    = try(each.value.external_secret.object_name, "")
    #   object_type    = lookup(local.AWS_OBJECT_TYPE, upper(try(each.value.external_secret.object_type, "SSM")), "ssmparameter")
    #   object_alias   = try(each.value.external_secret.alias, "")
    #   object_version = try(each.value.external_secret.object_version, 1)

    #   description = try(each.value.external_secret.description, "")
    #   values_file = try(each.value.external_secret.values_file, "") == "" ? "" : "${path.root}/templates/${each.value.external_secret.values_file}"
    #   ssm         = tomap({ type = "SecureString" })
    # }

  }


}
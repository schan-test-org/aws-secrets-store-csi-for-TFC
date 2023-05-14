output "service_account" {
  value = {
    name                         = kubernetes_service_account.this.metadata[0].name
    namespace                    = kubernetes_service_account.this.metadata[0].namespace
    automountServiceAccountToken = kubernetes_service_account.this.automount_service_account_token
    labels                       = kubernetes_service_account.this.metadata[0].labels
    # aws_iam_role                 = var.service_account.iam_role.create ? aws_iam_role.this[0].arn : ""
    # attached_policy = flatten([
    #   values(aws_iam_role_policy_attachment.exist_managed_policies)[*].policy_arn,
    #   (var.service_account.external_secret.is_need ? [aws_iam_policy.external_secrets[0].arn] : [])
    # ])
    # created_resources = merge(
    #   (local.create_ssm ? { aws_ssm_parameter : aws_ssm_parameter.this[0].name } : {}),
    #   (local.create_secret ? { aws_secret_manager : "" } : {})
    # )
  }
}

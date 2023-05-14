locals {
  # AWS IAM Role annotaitions
  # - eks.amazonaws.com/role-arn
  # - eks.amazonaws.com/sts-regional-endpoints
  # annotaions = var.service_account.iam_role.create ? tomap({ "eks.amazonaws.com/role-arn" : "${aws_iam_role.this[0].arn}", "eks.amazonaws.com/sts-regional-endpoints" : true }) : {}
  annotaions = tomap({ "eks.amazonaws.com/role-arn" : var.role_arn })
}

##########
resource "kubernetes_service_account" "this" {
  metadata {
    name        = var.service_account.name
    namespace   = var.service_account.namespace
    annotations = local.annotaions
    # annotations = {}
    labels      = {}
  }

  automount_service_account_token = try(var.service_account.automount_token, true)
}

# Kubernetes v1.24.0 and above : 해당 버전 이상부터는 SA 생성시 더 이상 디폴트 시크릿이 자동생생되지 않음으로 아래와 같이 추가로 사크릿도 생성해줌
resource "kubernetes_secret" "this" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.this.metadata.0.name
    }
    namespace     = var.service_account.namespace
    name        = "${var.service_account.name}-token-secret"
    # generate_name = "${kubernetes_service_account.this.metadata.0.name}-token-"
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}


########

# resource "kubernetes_namespace" "example" {
#   metadata {
#     annotations = {
#       name = "example-annotation"
#     }

#     labels = {
#       mylabel = "label-value"
#     }

#     name = "terraform-example-namespace"
#   }
# }


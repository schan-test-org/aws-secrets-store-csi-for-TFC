###############################################################################
# Common Variables
###############################################################################
project = "acp-secret-dr"
aws_region  = "ap-northeast-2"

default_tags = {
  dept  = "Platform Service Architect Group / DevOps SWAT Team"
  email = "schan@mz.co.kr"
}

env     = "dev"

########################################
# workspace setting
########################################
tfc_org = "<tfc-org>"
tfc_wk = "<tfc-eks-workspace>"

###############################################################################
# eks about
###############################################################################
# ref-checking-oidc >
# https://repost.aws/ko/knowledge-center/eks-troubleshoot-oidc-and-irsa
# https://artifacthub.io/packages/helm/secret-store-csi-driver/secrets-store-csi-driver

cluster_name = "<eks-name>"
# oidc_provider_arn = "arn:aws:iam::524542846721:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/328B416580B7EEEFE5EC7E2162B96A58"

###############################################################################
# secret-driver
###############################################################################


chart_name = "secrets-store-csi-driver"
chart_repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
chart_version = "1.3.3"
image_tag = "v1.3.3"
image_tag_registrar = "v2.7.0"
image_tag_liveness = "v2.9.0"

###############################################################################
# ascp
###############################################################################
# ref > https://github.com/aws/eks-charts/tree/master/stable/csi-secrets-store-provider-aws
ascp_chart_name = "csi-secrets-store-provider-aws"
ascp_chart_repository = "https://aws.github.io/eks-charts"
ascp_chart_version = "0.0.4"
ascp_image_repository = "aws-secrets-manager/secrets-store-csi-driver-provider-aws"

###############################################################################
# sa-v
###############################################################################
service_accounts = [{
    name      = "eks-deployment-sa"
    namespace = "test"
  },
  {
    name      = "test-sa"
    namespace = "default"
  },
  {
    name      = "kube-sys-sa"
    namespace = "kube-system"
}]

namespace = {
    ns-app-pod       = "test"
    ns-default       = "default"
    ns-system        = "kube-system"
}


###############################################################################
# helm-v
###############################################################################
# 모든 노드의 pod 에서 secret-manager 값을 마운트 하여 사용하기 위헤 데몬셋 배포에 노드 제한을 두시 않는 것이 좋음
# 따라서 노드셀렉터 또는 노드 어피니티 지정하지 않음
# 추가적으로 특정 노드에 taint 가  존재할 경우를 대비하여 tolerations 사용함

# ascp_node_selector = {
#   role = "ops"
# }

# node_selector = {
#   role = "ops"
# }

# affinity = {
#   nodeAffinity = {
#     requiredDuringSchedulingIgnoredDuringExecution = {
#       nodeSelectorTerms = [{
#         matchExpressions = [{
#           key      = "role"
#           operator = "In"
#           values   = ["ops"]
#         }]
#       }]
#     }
#   }
# }

tolerations = [{
  key      = "role"
  operator = "Equal"
  value    = "ops"
  effect   = "NoSchedule"
},
{
  key      = "role"
  operator = "Equal"
  value    = "apps"
  effect   = "NoSchedule"
}
]

ascp_tolerations = [{
  key      = "role"
  operator = "Equal"
  value    = "ops"
  effect   = "NoSchedule"
},
{
  key      = "role"
  operator = "Equal"
  value    = "apps"
  effect   = "NoSchedule"
}
]
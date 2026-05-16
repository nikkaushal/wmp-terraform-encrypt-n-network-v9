resource "aws_iam_role" "external-dns-role" {
    name = "external-dns-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "pods.eks.amazonaws.com"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
  inline_policy {
    name = "external-dns-policy"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ChangeResourceRecordSets",
            "route53:ListResourceRecordSets",
            "route53:ListTagsForResources"
          ],
          "Resource" : [
            "arn:aws:route53:::hostedzone/*"
          ]
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "route53:ListHostedZones"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]      
    })
  }
}

resource "aws_eks_pod_identity_association" "external-dns-pod-association" {
    cluster_name = aws_eks_cluster.main.name
    role_arn    = aws_iam_role.external-dns-role.arn
    namespace   = "default"
    service_account = "external-dns"
}

resource "aws_iam_role" "aws-ssm-ps-role" {
  name = "aws-ssm-ps-role-${var.env}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "pods.eks.amazonaws.com"
        },
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })

  inline_policy {
    name = "aws-ssm-ps-role-${var.env}"

    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "ssm:DescribeParameters",
            "ssm:GetParameterHistory",
            "ssm:GetParametersByPath",
            "ssm:GetParameters",
            "ssm:GetParameter"
          ],
          "Resource" : [
            "*"
          ]
        }
      ]
    })
  }
}

resource "aws_eks_pod_identity_association" "aws-ssm-ps-role-pod-association-analytics-service" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "default"
  service_account = "analytics-service"
  role_arn        = aws_iam_role.aws-ssm-ps-role.arn
}

resource "aws_eks_pod_identity_association" "aws-ssm-ps-role-pod-association-auth-service" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "default"
  service_account = "auth-service"
  role_arn        = aws_iam_role.aws-ssm-ps-role.arn
}

resource "aws_eks_pod_identity_association" "aws-ssm-ps-role-pod-association-portfolio-service" {
  cluster_name    = aws_eks_cluster.main.name
  namespace       = "default"
  service_account = "portfolio-service"
  role_arn        = aws_iam_role.aws-ssm-ps-role.arn
}
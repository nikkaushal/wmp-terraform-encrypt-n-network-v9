# provider "aws" {
#   region = "us-east-1"
# }
# terraform {
#   backend "s3" {
#     bucket = "terraform-state-d88-nk"
#     key    = "eks/terraform.tfstate"
#     region = "us-east-1"
#   }
# }

resource "aws_eks_cluster" "main" {
  name     = var.env
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = false
    subnet_ids = var.subnet_ids
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role" "node" {
  name = "eks-node-group-${var.env}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "main-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "main-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_launch_template" "main" {
  name = "${aws_eks_cluster.main.name}-lt"
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      kms_key_id = var.kms_key_id
      encrypted = true
    }
  }

}

# resource "aws_eks_node_group" "main" {
#   cluster_name    = aws_eks_cluster.main.name
#   node_group_name = "${var.env}-ng"
#   node_role_arn   = aws_iam_role.node.arn
#   subnet_ids = var.subnet_ids
#   instance_types  = ["t3.xlarge"]
#   capacity_type   = "SPOT"
#   launch_template {
#     id      = aws_launch_template.main.id
#     version = "$Latest"
#   }

#   scaling_config {
#     desired_size = 1
#     max_size     = 2
#     min_size     = 1
#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.main-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.main-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.main-AmazonEC2ContainerRegistryReadOnly,
#     aws_launch_template.main
#   ]
# }
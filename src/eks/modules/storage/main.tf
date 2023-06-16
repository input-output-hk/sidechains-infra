locals {
  # FIXME: remove hardcoded value
  oidc_id    = "F3159717D99BCBAAA30C152B3F6CA86F"
  efs_policy = file("policy.json")
}

module "label" {
  # v0.25.0
  source = "github.com/cloudposse/terraform-null-label?ref=488ab91e34a24a86957e397d9f7262ec5925586a"

  namespace   = var.label.namespace
  environment = var.label.environment
  stage       = var.label.stage
  name        = var.label.name
  attributes  = var.label.attributes
  delimiter   = var.label.delimiter
  tags        = var.label.tags
}

resource "aws_efs_file_system" "storage" {
  creation_token = module.label.id
  tags           = module.label.tags
}


resource "aws_iam_role" "this" {
  name               = var.role_name
  tags               = module.label.tags
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "EFSKubernetesOIDC"
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${var.account}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_id}"]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "oidc.eks.${var.region}.amazonaws.com/id/${local.oidc_id}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }
  }
}

resource "aws_iam_policy" "this" {
  name   = "efs-csi-driver-policy"
  policy = local.efs_policy
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}


####################################################################################
####################################################################################
####################################################################################

# Kubernetes Configuration

provider "aws" {
  region = "eu-central-1"
}

data "aws_eks_cluster" "cluster" {
  name = "iog-sidechain-substrate-kubernetes"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "iog-sidechain-substrate-kubernetes"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
}

####################################################################################
####################################################################################
####################################################################################

# EFS Volume Configuration

resource "kubernetes_service_account_v1" "example" {
  metadata {
    labels = {
      "app.kubernetes.io/name" = "aws-efs-csi-driver"
    }
    name      = "efs-csi-controller-sa"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}

resource "kubernetes_storage_class" "efs" {
  metadata {
    name = "aws-efs-storageclass"
  }
  storage_provisioner = "efs.csi.aws.com"

  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId     = aws_efs_file_system.storage.id
    directoryPerms   = "700"
    gidRangeStart    = "1000"
    gidRangeEnd      = "2000"
    basePath         = "/dynamic_provisioning"
  }

  reclaim_policy  = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"
}

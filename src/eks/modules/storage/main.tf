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

####################################################################################
####################################################################################
####################################################################################

# NLB Configuration

data "aws_subnet" "selected" {
  id = ["subnet-0245772cf491e28da", "subnet-0dcd319e426813a6c", "subnet-034a9423a9ac17ed7"]
}

resource "aws_lb" "nlb" {
  name               = "eks-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet.selected.*.id
}

# Alice p2p port

resource "aws_lb_target_group" "alice" {
  name     = "tg-alice"
  port     = 8001
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "alice" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8001
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alice.arn
  }
}

# Bob p2p port

resource "aws_lb_target_group" "bob" {
  name     = "tg-bob"
  port     = 8002
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "bob" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8002
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bob.arn
  }
}

# Charlie p2p port

resource "aws_lb_target_group" "charlie" {
  name     = "tg-charlie"
  port     = 8003
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "charlie" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8003
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.charlie.arn
  }
}

# Dave p2p port

resource "aws_lb_target_group" "dave" {
  name     = "tg-dave"
  port     = 8004
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "dave" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8004
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dave.arn
  }
}

# Eve p2p port

resource "aws_lb_target_group" "eve" {
  name     = "tg-eve"
  port     = 8005
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "eve" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 8005
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eve.arn
  }
}

####################################################################################
####################################################################################
####################################################################################

# AWS Client VPN Endpoint

resource "aws_ec2_client_vpn_endpoint" "vpn_endpoint" {
  description            = "VPN access to services"
  server_certificate_arn = aws_acm_certificate.cert.arn
  client_cidr_block      = "172.20.0.0/16" # iog-sidechain-substrate-kubernetes cluster cidr

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.root_cert.arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.lg.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.ls.name
  }

  dns_servers = ["8.8.8.8", "8.8.4.4"]

  transport_protocol = "udp"
}

locals {
  subnet_ids = ["subnet-0245772cf491e28da", "subnet-0dcd319e426813a6c", "subnet-034a9423a9ac17ed7"]
}

resource "aws_ec2_client_vpn_network_association" "subnet" {
  for_each = toset(local.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn_endpoint.id
  subnet_id              = each.key
}

# Generate server certificate for VPN (You can use your own certificates too)
resource "aws_acm_certificate" "cert" {
  domain_name       = "vpn.sc.iog.io" # Replace with your domain
  validation_method = "DNS"
}

# Generate root certificate for VPN client authentication (You can use your own certificates too)
resource "aws_acm_certificate" "root_cert" {
  domain_name       = "vpn.sc.iog.io" # Replace with your domain
  validation_method = "DNS"
}

# Set up a CloudWatch Log Group and Log Stream for VPN connection logging
resource "aws_cloudwatch_log_group" "lg" {
  name = "VPN-Connection-Logs"
}

resource "aws_cloudwatch_log_stream" "ls" {
  name           = "VPN-Connection-Log-Stream"
  log_group_name = aws_cloudwatch_log_group.lg.name
}



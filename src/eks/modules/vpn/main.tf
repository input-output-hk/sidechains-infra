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

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn_endpoint.id
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



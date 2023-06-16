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

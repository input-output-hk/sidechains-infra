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


data "aws_subnet" "selected_1" {
  id = "subnet-0245772cf491e28da"
}

data "aws_subnet" "selected_2" {
  id = "subnet-0dcd319e426813a6c"
}

data "aws_subnet" "selected_3" {
  id = "subnet-034a9423a9ac17ed7"
}

resource "aws_lb" "nlb" {
  name               = "eks-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [data.aws_subnet.selected_1.id, data.aws_subnet.selected_2.id, data.aws_subnet.selected_3.id]
}

# Alice p2p port

resource "aws_lb_target_group" "alice" {
  name     = "tg-alice"
  port     = 30001
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "alice" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 30001
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alice.arn
  }
}

# Bob p2p port

resource "aws_lb_target_group" "bob" {
  name     = "tg-bob"
  port     = 30002
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "bob" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 30002
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bob.arn
  }
}

# Charlie p2p port

resource "aws_lb_target_group" "charlie" {
  name     = "tg-charlie"
  port     = 30003
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "charlie" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 30003
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.charlie.arn
  }
}

# Dave p2p port

resource "aws_lb_target_group" "dave" {
  name     = "tg-dave"
  port     = 30004
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "dave" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 30004
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dave.arn
  }
}

# Eve p2p port

resource "aws_lb_target_group" "eve" {
  name     = "tg-eve"
  port     = 30005
  protocol = "TCP"
  vpc_id   = data.aws_eks_cluster.cluster.vpc_config.0.vpc_id
}

resource "aws_lb_listener" "eve" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 30005
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eve.arn
  }
}

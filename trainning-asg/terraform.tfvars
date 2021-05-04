vpc_id      = "vpc-3957b844"
server_port = 80
elb_port    = 80
ingress = [
  {
    protocol       = "TCP"
    description    = "ingress rule"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 22
    to_port        = 22
  },
  {
    protocol       = "TCP"
    description    = "ingress rule"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 80
    to_port        = 80
  },
]
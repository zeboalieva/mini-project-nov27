security_groups = {
  "mini_project" = {
    description = "Security group for web servers"
    ingress_rules = [
      {
        description = "ingress rule for http"
        priority    = 200
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "my_ssh"
        priority    = 202
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "ingress rule for http"
        priority    = 204
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
    egress_rules = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}
  subnet = {
  pub_subnet1 = {
    cidr_block        = "172.16.0.0/24"
    availability_zone = "us-east-1a"
  },
  pub_subnet2 = {
    cidr_block        = "172.16.1.0/24"
    availability_zone = "us-east-1b"
  },
  pub_subnet3 = {
    cidr_block        = "172.16.2.0/24"
    availability_zone = "us-east-1c"
  },
}
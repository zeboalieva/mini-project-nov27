resource "aws_key_pair" "key" {
  key_name   = "cloud_2021"
  public_key = file("~/.ssh/id_ed25519.pub")
}
resource "aws_vpc" "vpc" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "subnet" {
  for_each          = var.subnet
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = join("-", [var.prefix, each.key])
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-rtb"
  }
}

resource "aws_route_table_association" "rta" {
  for_each       = var.subnet
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = aws_route_table.rt.id
}

resource "aws_eip" "eip" {
  for_each = var.ec2
  instance = aws_instance.server[each.key].id
  domain   = "vpc"
}
output "my_eip" {
  value = { for k, v in aws_eip.eip : k => v.public_ip }
}

resource "aws_instance" "server" {
  for_each      = var.ec2
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  subnet_id = aws_subnet.subnet[each.value.subnet_name].id
  #vpc_security_group_ids = [module.security_groups.security_group_id["cloud_2021_sg"]] 
  vpc_security_group_ids = [module.security-groups.security_group_id["mini_project"]]
  user_data              = <<-EOF
                           #!/bin/bash
                           sudo yum update -y
                           sudo yum install -y httpd
                           sudo systemctl start httpd.service
                           sudo systemctl enable httpd.service
                           sudo echo "<h1> HELLO from ${upper(each.key)}_SERVER </h1>" > /var/www/html/index.html                  
                           EOF
  tags = {
    Name = join("_", [var.prefix, each.key])
  }
}

module "security-groups" {
  source  = "app.terraform.io/tf-class-september-20/security-groups/aws"
  version = "1.0.0"
  vpc_id          = aws_vpc.vpc.id
  security_groups = var.security_groups
}
variable "subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
}
variable "prefix" {
  type    = string
  default = "mini_project"
}

variable "security_groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}

variable "ec2" {
  type = map(object({
    subnet_name = string,
    # cidr_block = string
    # availability_zone = string
  }))
  default = {
    app = {
      subnet_name = "pub_subnet1"
    }
    dev = {
      subnet_name = "pub_subnet2"
    }
    web = {
      subnet_name = "pub_subnet3"
    }
  }
}


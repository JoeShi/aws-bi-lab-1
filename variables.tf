variable "aws_region" {
	default = "us-west-2"
}

variable "vpc_id" {
  default = "vpc-0239816d3b197fe0a"
}

variable "db_subnet_id_1" {
  default = "subnet-0d9096a4d1f816ad3"
}

#have to be PUBLIC subnet
variable "db_subnet_id_2" {
  default = "subnet-0671e41af1ff9b91a"
}

variable "bastion_subnet_id" {
  default = "subnet-031f268c5856d86d2"
}

variable "ec2_key_name" {
  default = "aws-terraform"
}


# Amazon Linux AMI
variable "aws_amis" {
  default = {
    us-west-2 = "ami-061392db613a6357b"
  }
}

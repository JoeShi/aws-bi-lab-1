
variable "vpc_id" {
  default = "vpc-5c1a8425"
}

variable "db_subnet_id_1" {
  default = "subnet-0449cd5614ac88c8a"
}

variable "db_subnet_id_2" {
  default = "subnet-02c890faa2bc7e0c8"
}

variable "bastion_subnet_id" {
  default = "subnet-ebaa40a0"
}

variable "ec2_key_name" {
  default = "aws"
}

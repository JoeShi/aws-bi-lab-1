data "aws_caller_identity" "current" {}

provider "aws" {
  region = "us-west-2"
}

data "aws_vpc" "lab_vpc" {
  id = "${var.vpc_id}"
}

data "aws_subnet" "bastion_subnet" {
  id = "${var.bastion_subnet_id}"
}

data "aws_subnet" "rds_db_subnet_1" {
  id = "${var.db_subnet_id_1}"
}

data "aws_subnet" "rds_db_subnet_2" {
  id = "${var.db_subnet_id_2}"
}


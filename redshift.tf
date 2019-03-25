resource "random_string" "redshift_cluster_identifier" {
  special = false
  length = 8
  lower = true
  upper = false
  number = false
}

resource "random_string" "redshift_master_password" {
  special = false
  length = 8
  lower = true
  upper = true
  number = true
  min_numeric = 1
  min_lower = 1
  min_upper = 1
}

resource "random_string" "redshift_subnet_group_name" {
  special = false
  length = 8
  lower = true
  upper = false
  number = false
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name = "${random_string.redshift_subnet_group_name.result}"
  subnet_ids = ["${data.aws_subnet.rds_db_subnet_1.id}", "${data.aws_subnet.rds_db_subnet_2.id}"]
}

resource "aws_security_group" "redshift_security_group" {
  vpc_id = "${data.aws_vpc.lab_vpc.id}"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "RedShift SG"
  }
}

resource "aws_security_group_rule" "redshift_security_group_rule_bastion" {
  from_port = 5439
  protocol = "tcp"
  security_group_id = "${aws_security_group.redshift_security_group.id}"
  to_port = 5439
  source_security_group_id = "${aws_security_group.bastion_security_group.id}"
  type = "ingress"
}

resource "aws_security_group_rule" "redshift_security_group_rule_dms" {
  from_port = 5439
  protocol = "tcp"
  security_group_id = "${aws_security_group.redshift_security_group.id}"
  to_port = 5439
  source_security_group_id = "${aws_security_group.dms_security_group.id}"
  type = "ingress"
}

resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier = "${random_string.redshift_cluster_identifier.result}"
  node_type = "dc1.large"
  master_username = "root"
  master_password = "${random_string.redshift_master_password.result}"
  database_name = "lab"
  cluster_type = "multi-node"
  number_of_nodes = 2
  vpc_security_group_ids = ["${aws_security_group.redshift_security_group.id}"]
  cluster_subnet_group_name = "${aws_redshift_subnet_group.redshift_subnet_group.name}"
  skip_final_snapshot = true
  final_snapshot_identifier = "delete-delete-me"
}



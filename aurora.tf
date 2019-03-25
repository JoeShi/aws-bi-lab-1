resource "random_string" "rds_master_password" {
  length = 8
  special = false
  lower = true
  upper = true
  number = false
}

resource "aws_db_subnet_group" "rds_db_subnet_group" {
  subnet_ids = ["${data.aws_subnet.rds_db_subnet_1.id}", "${data.aws_subnet.rds_db_subnet_2.id}"]
}

resource "aws_security_group" "rds_db_security_group" {
  vpc_id = "${data.aws_vpc.lab_vpc.id}"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Aurora SG"
  }
}

resource "aws_security_group_rule" "rds_mysql_rule_bastion" {
  from_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.rds_db_security_group.id}"
  to_port = 3306
  source_security_group_id = "${aws_security_group.bastion_security_group.id}"
  type = "ingress"
}

resource "aws_security_group_rule" "rds_msyql_rule_dms" {
  from_port = 3306
  protocol = "tcp"
  security_group_id = "${aws_security_group.rds_db_security_group.id}"
  to_port = 3306
  source_security_group_id = "${aws_security_group.dms_security_group.id}"
  type = "ingress"
}

resource "random_string" "rds_cluster_parameter_group_name" {
  length = 8
  special = false
  lower = true
  upper = false
  number = false
}

resource "aws_rds_cluster_parameter_group" "rds_cluster_parameter_group" {
  family = "aurora5.6"
  parameter {
    apply_method = "pending-reboot"
    name = "binlog_format"
    value = "ROW"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  engine = "aurora"
  db_subnet_group_name = "${aws_db_subnet_group.rds_db_subnet_group.name}"
  vpc_security_group_ids = ["${aws_security_group.rds_db_security_group.id}"]
  database_name = "lab"
  master_username = "root"
  master_password = "${random_string.rds_master_password.result}"
  skip_final_snapshot = true
  final_snapshot_identifier = "delete-delete-me"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.rds_cluster_parameter_group.name}"
}

resource "aws_rds_cluster_instance" "aurora_instance_1" {
  count = 1
  cluster_identifier = "${aws_rds_cluster.aurora_cluster.id}"
  instance_class = "db.r4.large"
}

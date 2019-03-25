resource "random_string" "dms_replication_subnet_group_id" {
  length = 8
  special = false
  lower = true
  upper = false
  number = false
}

resource "random_string" "dms_replication_instance_id" {
  length = 8,
  special = false,
  lower = true
  upper = false
  number = false
}

resource "aws_security_group" "dms_security_group" {
  vpc_id = "${data.aws_vpc.lab_vpc.id}"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "DMS SG"
  }
}

resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_description = "DMS Subnetgroup"
  replication_subnet_group_id = "${random_string.dms_replication_subnet_group_id.result}"
  subnet_ids = ["${data.aws_subnet.rds_db_subnet_1.id}", "${data.aws_subnet.rds_db_subnet_2.id}"]
}

resource "aws_dms_replication_instance" "dms_instance" {
  replication_instance_class = "dms.t2.micro"
  replication_instance_id = "${random_string.dms_replication_instance_id.result}"
  replication_subnet_group_id = "${aws_dms_replication_subnet_group.dms_subnet_group.id}"
  vpc_security_group_ids = ["${aws_security_group.dms_security_group.id}"]
  publicly_accessible = false
  multi_az = false
  apply_immediately = true
}

resource "random_string" "aurora_endpoint_name" {
  length = 8
  special = false
  lower = true
  upper = false
  number = false
}

resource "random_string" "redshift_endpoint_name" {
  length = 8
  special = false
  lower = true
  upper = false
  number = false
}

resource "aws_dms_endpoint" "aurora_endpoint" {
  endpoint_id = "${random_string.aurora_endpoint_name.result}"
  endpoint_type = "source"
  engine_name = "aurora"
  database_name = "${aws_rds_cluster.aurora_cluster.database_name}"
  server_name = "${aws_rds_cluster.aurora_cluster.endpoint}"
  username = "${aws_rds_cluster.aurora_cluster.master_username}"
  password = "${aws_rds_cluster.aurora_cluster.master_password}"
  port = 3306
}

resource "aws_dms_endpoint" "redshift_endpoint" {
  endpoint_id = "${random_string.redshift_endpoint_name.result}"
  endpoint_type = "target"
  engine_name = "redshift"
  database_name = "${aws_redshift_cluster.redshift_cluster.database_name}"
  server_name = "${element(split(":", aws_redshift_cluster.redshift_cluster.endpoint), 0)}"
  username = "${aws_redshift_cluster.redshift_cluster.master_username}"
  password = "${aws_redshift_cluster.redshift_cluster.master_password}"
  port = 5439
}

//resource "random_string" "dms_task_id" {
//  length = 8
//  special = false
//  lower = true
//  upper = false
//  number = false
//}
//
//resource "aws_dms_replication_task" "dms_task" {
//  migration_type = "full-load-and-cdc"
//  replication_instance_arn = "${aws_dms_replication_instance.dms_instance.replication_instance_arn}"
//  replication_task_id = "${random_string.dms_task_id.result}"
//  source_endpoint_arn = "${aws_dms_endpoint.aurora_endpoint.endpoint_arn}"
//  table_mappings = ""
//  target_endpoint_arn = "${aws_dms_endpoint.redshift_endpoint.endpoint_arn}"
//
//}

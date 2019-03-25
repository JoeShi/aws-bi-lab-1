output "EC2 Bastion Endpoint" {
  value = "${aws_instance.bastion_instance.public_dns}"
}

output "Aurora endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.endpoint}"
}

output "Aurora database name" {
  value = "${aws_rds_cluster.aurora_cluster.database_name}"
}

output "Aurora master username" {
  value = "${aws_rds_cluster.aurora_cluster.master_username}"
}

output "Aurora master password" {
  value = "${aws_rds_cluster.aurora_cluster.master_password}"
}

output "RedShift Endpoint" {
  value = "${element(split(":", aws_redshift_cluster.redshift_cluster.endpoint), 0)}"
}

output "RedShift database name" {
  value = "${aws_redshift_cluster.redshift_cluster.database_name}"
}

output "Redshift master username" {
  value = "${aws_redshift_cluster.redshift_cluster.master_username}"
}

output "RedShift master password " {
  value = "${aws_redshift_cluster.redshift_cluster.master_password}"
}

output "DMS instanace name" {
  value = "${aws_dms_replication_instance.dms_instance.replication_instance_id}"
}

output "DMS Aurora Source ID" {
  value = "${aws_dms_endpoint.aurora_endpoint.endpoint_id}"
}

output "DMS RedShift Target ID" {
  value = "${aws_dms_endpoint.redshift_endpoint.endpoint_id}"
}

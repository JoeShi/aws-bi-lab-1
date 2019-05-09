resource "aws_security_group" "bastion_security_group" {
  vpc_id = "${data.aws_vpc.lab_vpc.id}"
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name = "Bastion SG"
  }
}


#0-22端口？？
resource "aws_security_group_rule" "bastion_security_group_rule" {
  from_port = 0
  protocol = "tcp"
  security_group_id = "${aws_security_group.bastion_security_group.id}"
  to_port = 22
  cidr_blocks = ["0.0.0.0/0"]
  type = "ingress"
}

data "template_file" "mysql_init" {
  template = "${file("mysql_init.tpl")}"
  vars = {
    rds_endpoint = "${aws_rds_cluster.aurora_cluster.endpoint}"
    rds_username = "${aws_rds_cluster.aurora_cluster.master_username}"
    rds_password = "${aws_rds_cluster.aurora_cluster.master_password}"
  }
}

# Launch a bastion machine
resource "aws_instance" "bastion_instance" {
  #ami = "ami-061392db613a6357b"
  ami = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "m5.large"
  vpc_security_group_ids = ["${aws_security_group.bastion_security_group.id}"]
  subnet_id = "${data.aws_subnet.bastion_subnet.id}"
  associate_public_ip_address = true
  key_name = "${var.ec2_key_name}"
  root_block_device {
    volume_type = "gp2"
    volume_size = 30
    delete_on_termination = true
  }
  user_data = "${data.template_file.mysql_init.rendered}"
  depends_on = ["aws_rds_cluster_instance.aurora_instance_1"]
}

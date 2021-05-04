output "aws_instance_bastion_server_eips" {
  value = aws_elb.trainning-elb.dns_name
}
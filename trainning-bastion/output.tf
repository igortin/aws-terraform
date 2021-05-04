 output "aws_instance_bastion_server_eips" {
  value =aws_instance.bastion_server.*.public_ip
 }
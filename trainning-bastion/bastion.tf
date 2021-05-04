
locals {
  aws_cidr_subnets_public = ["subnet-b6f629e9", "subnet-603be241", "subnet-3d67b45b"]
  ssh_key                 = "my-training"
  security_groups         = ["sg-3fe69e19"]
}


resource "aws_instance" "bastion_server" {
  count         = length(local.aws_cidr_subnets_public)
  ami           = data.aws_ami.image.id
  instance_type = "t2.nano"

  associate_public_ip_address = true
  subnet_id                   = element(local.aws_cidr_subnets_public, count.index)
  vpc_security_group_ids      = local.security_groups
  key_name                    = local.ssh_key
  user_data                   = data.template_file.user_data.rendered

  # user_data = <<-EOF
  #             #!/bin/bash
  #             yum install httpd -y
  #             curl http://169.254.169.254/latest/meta-data/public-ipv4 > /var/www/html/index.html
  #             systemctl start httpd
  #             systemctl enable httpd
  #           EOF


  tags = {
    "Name" = "bastion-${count.index}",
    "Role" = "qa-bastion-${count.index}",
    "Env"  = "qa"
  }
  
}


resource "aws_eip" "lb" {
  count = length(local.aws_cidr_subnets_public)
  vpc   = true
}


resource "aws_eip_association" "eip_assoc" {
  count         = length(local.aws_cidr_subnets_public)
  instance_id   = element(aws_instance.bastion_server, count.index).id
  allocation_id = element(tolist(aws_eip.lb), count.index).id
}

data "template_file" "user_data" {
  template = file("template/cloud-config.sh")
  vars     = {}
}


data "aws_ami" "image" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



data "aws_availability_zones" "available" {
  state = "available"
}

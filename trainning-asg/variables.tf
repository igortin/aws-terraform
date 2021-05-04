variable "vpc_id" {
  description = "vpc id"
}

variable "server_port" {
  description = "The port the web server will be listening"
  type        = number
}

variable "elb_port" {
  description = "The port the elb will be listening"
  type        = number
}

variable "ingress" {
  description = "ingress"
  type        = list
  default     = []
}
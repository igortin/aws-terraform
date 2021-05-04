terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    bucket         = "trainning-tfstate"
    key            = "qa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }
}

# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config = {
#     bucket = "trainning-tfstate"
#     key    = "qa/terraform.tfstate"
#     region = "us-east-1"
#   }
# }
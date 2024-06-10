data "aws_vpc" "vpc" {
  default = true
}

data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["973714476881"]

  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins"

  instance_type          = "t2.micro"
  vpc_security_group_ids =["sg-09f7d0ec503cc2068"]
  subnet_id              = "subnet-048abffac90b9e137"
  ami = data.aws_ami.ami.id
  user_data = file("jenkins.sh")

  tags = {
    Name="jenkins"
  }
}

module "node" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "jenkins-node"
  instance_type          = "t2.micro"
  vpc_security_group_ids =["sg-09f7d0ec503cc2068"]
  subnet_id              = "subnet-048abffac90b9e137"
  ami = data.aws_ami.ami.id
  user_data = file("jenkins-node.sh")
  tags = {
    Name="jenkins-node"
  }
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
    },

     {
      name    = "jenkins-node"
      type    = "A"
      ttl     = 1
      records = [
        module.node.private_ip
      ]
    },
  ]

}
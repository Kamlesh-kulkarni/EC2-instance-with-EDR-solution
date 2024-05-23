provider "aws" {
  region = "us-east-1"
    access_key = " "
    secret_key = " "
}

# Create a security group
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for EC2 instance"
  
  vpc_id      = "vpc-0f5db5cf115c26015"
  
  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-04ff98ccbfa41c9ad"
  instance_type = "t2.micro"
  key_name      = "Terraform_demo"

  tags = {
    Name = "example-instance"
  }
 provisioner "remote-exec" {
    inline = [
      "curl -o falcon_installer.sh https://falcon.crowdstrike.com/sensors/download?type=linux&token=YOUR_TOKEN",
      "sudo bash falcon_installer.sh -f --cid=YOUR_CID"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("<path_to_your_private_key.pem>")
      host        = self.public_ip
    }
  }
}



provider "aws" {
  region = "us-east-1" // North Virginia
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

resource "aws_instance" "tic_tac_toe_server" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t3.micro"             
  key_name      = "day-89"

  vpc_security_group_ids = [aws_security_group.jenkins_sg_21.id]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -aG docker ubuntu
              EOF

  tags = {
    Name = "Day92-Docker-Server"
  }
}

resource "aws_security_group" "jenkins_sg_21" {
  name        = "sg_jenkins_day_90"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "instance_public_ip" {
  value = aws_instance.tic_tac_toe_server.public_ip
}

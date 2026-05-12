provider "aws" {
  region = "us-east-1" // North Virginia
}

resource "aws_instance" "tic_tac_toe_server" {
  ami           = "ami-0e2c8ccd4e0269736" // Latest Ubuntu 24.04 LTS in us-east-1
  instance_type = "t3.micro"
  key_name      = "day-89" // Make sure this key exists in us-east-1 region

  tags = {
    Name = "Tic-Tac-Toe-Automated"
  }

  vpc_security_group_ids = [aws_security_group.jenkins_sg_21.id]
}

resource "aws_security_group" "jenkins_sg_21" {
  name        = "sg_jenkins_day_89"
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

output "instance_ip" {
  value = aws_instance.tic_tac_toe_server.public_ip
}

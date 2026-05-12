provider "aws" {
  region = "eu-north-1" 
}

resource "aws_instance" "tic_tac_toe_server" {
  ami           = "ami-0705383d0b3ee1b10" // Ubuntu 24.04 LTS for Stockholm
  instance_type = "t3.micro"
  key_name      = "day-88" // PEM file name without extension

  tags = {
    Name = "Tic-Tac-Toe-Automated"
  }

  // Security group allow karne ke liye (Optional but recommended)
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-automated-sg"
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

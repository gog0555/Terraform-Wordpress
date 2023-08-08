resource "aws_instance" "instance1a" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.ec2sg.id]

  user_data = file("script.sh")

  tags = {
    Name = "${var.env}-${var.name}-server1"
  }
}

resource "aws_instance" "instance1c" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[1]
  vpc_security_group_ids = [aws_security_group.ec2sg.id]

  user_data = file("script.sh")

  tags = {
    Name = "${var.env}-${var.name}-server2"
  }
}

resource "aws_security_group" "ec2sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.name}-sg"
  }
}
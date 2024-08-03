provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "mongodb" {
  count         = 3
  ami           = var.ami_id
  instance_type = var.instance_type

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "MongoDBInstance${count.index}"
  }

  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  key_name = var.key_name
}

resource "aws_security_group" "mongodb_sg" {
  name        = "mongodb_sg"
  description = "Allow SSH and MongoDB access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
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

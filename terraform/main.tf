terraform {
  backend "s3" {
    bucket         = "my-unique-banana-tfstate-bucket" # Имя вашего бакета из Шага 1
    key            = "banana/terraform/terraform.tfstate"        # Путь к файлу внутри бакета
    region         = "eu-north-1"                       # Ваш регион AWS
  }
}

# Далее идет ваш текущий код: resource "aws_security_group" "banana_sg" ...


resource "aws_security_group" "banana_sg" {

  name = "banana-sg"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["2.132.201.73/32"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "banana_ec2" {

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"

  key_name = "banana"

  vpc_security_group_ids = [
    aws_security_group.banana_sg.id
  ]

  tags = {
    Name = "banana-server"
  }
}

resource "aws_eip" "banana_ip" {

  instance = aws_instance.banana_ec2.id
}
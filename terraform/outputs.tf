output "ec2_ip" {
  value = aws_eip.banana_ip.public_ip
}
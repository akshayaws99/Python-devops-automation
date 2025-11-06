resource "aws_instance" "demo" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "demo-instance"
  }
}

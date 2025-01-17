resource "aws_instance" "web1" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.secgroup1.id]
  tags = {
    Name = "${var.Name}-${var.Env}"
  }
}

resource "aws_key_pair" "mykey" {
  key_name   = var.Name
  public_key = file("webserver.pub")
}

resource "aws_security_group" "secgroup1" {
  name_prefix = "instance_sg1"
  tags = {
    name = "${var.Name}-${var.Env}"
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
    ipv6_cidr_blocks  = ["::/0"]
    #    security_group_id = [aws_security_group.secgroup1.id]
  }

}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.secgroup1.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.secgroup1.id
}

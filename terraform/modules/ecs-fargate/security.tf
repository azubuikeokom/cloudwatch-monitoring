resource "aws_security_group" "alb-sg" {
  name        = "${var.name}-allow_tcp"
  description = "Allow TCP inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description      = "TCP from VPC"
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tcp"
  }
}
resource "aws_security_group" "ecs-tasks-sg" {
  name   = "${var.name}-sg-task-${var.environment}"
  vpc_id = data.aws_vpc.selected.id

  ingress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    security_groups      = [aws_security_group.alb-sg.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "fargat-ecs-${var.environment}"
  }
}
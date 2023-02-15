
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster"

  setting{
    name = "containerInsights"
    value = "enabled"
  }
}
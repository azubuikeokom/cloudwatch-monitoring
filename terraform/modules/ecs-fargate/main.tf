
resource "aws_ecs_cluster" "main" {
  name = "${var.name}-cluster-${var.environment}"

  setting{
    name = "containerInsights"
    value = "enabled"
  }
}
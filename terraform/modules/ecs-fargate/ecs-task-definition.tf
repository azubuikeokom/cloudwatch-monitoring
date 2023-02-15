resource "aws_ecs_task_definition" "task" {
  family                = "${var.name}"
  execution_role_arn    = aws_iam_role.yace-task-role.arn
  task_role_arn         = aws_iam_role.yace-task-role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = var.network-mode
  cpu                      = 1024
  memory                   = 2048
  container_definitions = file("../../task-definitions/container-definition.json")

}

 
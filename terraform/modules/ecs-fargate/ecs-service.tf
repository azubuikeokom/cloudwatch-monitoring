resource "aws_ecs_service" "yace-service" {
  name            = "${var.name}-service-${var.environment}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = var.service-count
  launch_type     = var.launch-type
  scheduling_strategy = var.scheduling_strategy
  

    network_configuration {
    security_groups  = [aws_security_group.ecs-tasks-sg.id]
    subnets          = [for subnet in data.aws_subnet.all-subnets: subnet.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = "yace"
    container_port   = var.container_port
  }
  depends_on = [aws_alb_target_group.main]

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
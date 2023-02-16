locals {
  environment = "prod"
}
module "ecs-fargate" {

  source              = "../../modules/ecs-fargate"
  name                = "yace"
  network-mode        = "awsvpc"
  service-count       = 1
  launch-type         = "FARGATE"
  vpc-id              = "vpc-0c3ce1fc4bfebf177"
  scheduling_strategy = "REPLICA"
  environment         = local.environment
  container_port      = 5000


}

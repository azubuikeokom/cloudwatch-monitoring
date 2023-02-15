variable name{
    type = string
    default = "yace"
}
variable "network-mode" {
    type=string
    default="awsvpc"
}
variable "service-count"{
    type = number
    default = 1
}
variable "launch-type" {
    type = string
    default = "FARGATE"
}
variable "vpc-id" {
   type = string
   default = "vpc-0c3ce1fc4bfebf177"
}
variable "scheduling_strategy" {
    type = string
    default =  "REPLICA"
}
variable "environment"{
    type=string
}
variable "container_port" {
    type=number
}


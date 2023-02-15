data "aws_vpc" "selected" {
  id = var.vpc-id
}
# data "aws_subnet" "selected" {
#   id = var.subnet-id
# }
data "aws_subnets" "subnets" {
  filter {
    name="tag:Name"
    values=["Default-subnet-1","Default-subnet-2"]
  }
}


data "aws_subnet" "all-subnets" {
  for_each = toset(data.aws_subnets.subnets.ids)
  id       = each.value
}


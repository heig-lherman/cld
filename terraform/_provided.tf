# Reference the objects that are made available but we should not manage

data "aws_vpc" "main" {
  id = "vpc-03d46c285a2af77ba"
  filter {
    name   = "Name"
    values = ["VPC-CLD"]
  }
}
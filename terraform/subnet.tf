resource "aws_subnet" "private_a" {
  vpc_id = data.aws_vpc.main.id
  cidr_block = "10.0.17.0/28"
  availability_zone_id = "euw3-az1"

  tags = {
    Name = "SUB-PRIVATE-DEVOPSTEAM17a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id = data.aws_vpc.main.id
  cidr_block = "10.0.17.128/28"
  availability_zone_id = "euw3-az2"

  tags = {
    Name = "SUB-PRIVATE-DEVOPSTEAM17b"
  }
}
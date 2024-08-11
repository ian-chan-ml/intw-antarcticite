data "aws_vpc" "this" {
  id = "vpc-0cb35e70f02cbf8a9"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  filter {
    name   = "tag:Usage"
    values = ["private"]
  }
}

data "aws_subnet" "private" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.key
}

data "aws_subnets" "db" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }

  tags = {
    Usage = "db"
  }
}

data "aws_subnet" "db" {
  for_each = toset(data.aws_subnets.db.ids)
  id       = each.key
}

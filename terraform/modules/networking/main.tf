resource "aws_vpc" "elasticsearch" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.elasticsearch_tag
  }
}

resource "aws_internet_gateway" "elasticsearch" {
  vpc_id = aws_vpc.elasticsearch.id

  tags = {
    Name = var.elasticsearch_tag
  }
}

resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.elasticsearch.id
  subnet_ids = aws_subnet.elasticsearch[*].id

  ingress {
    protocol   = "all"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "all"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = var.elasticsearch_tag
  }
}

resource "aws_route_table" "elasticsearch" {
  vpc_id = aws_vpc.elasticsearch.id

  // todo probably can be restricted to vpc endpoint for es - but won't work with only local route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.elasticsearch.id
  }

  tags = {
    Name = var.elasticsearch_tag
  }
}

resource "aws_route_table_association" "elasticsearch" {
  count          = length(var.subnet_cidrs)
  subnet_id      = aws_subnet.elasticsearch[count.index].id
  route_table_id = aws_route_table.elasticsearch.id
}

resource "aws_subnet" "elasticsearch" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.elasticsearch.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.subnet_cidrs[count.index]

  tags = {
    Name = "${var.elasticsearch_tag}-${var.availability_zones[count.index]}"
  }
}

resource "aws_internet_gateway" "darkrose-igw" {
    vpc_id = aws_vpc.darkrose-vpc.id

    tags = {
    Name        = "darkrose-${var.infra-env}-internet-gateway"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    VPC         = aws_vpc.darkrose-vpc.id
    Role        = "public"
    }
}

resource "aws_eip" "darkrose-nat-eip" {
    vpc = true

    lifecycle {
        prevent_destroy = true
    }

    tags = {
    Name        = "darkrose-${var.infra-env}-nat-eip"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    VPC         = aws_vpc.darkrose-vpc.id
    Role        = "private"
    }
}

resource "aws_nat_gateway" "darkrose-nat" {
    allocation_id = aws_eip.darkrose-nat-eip.id

    subnet_id = aws_subnet.public-subnet[element(keys(aws_subnet.public-subnet), 0)].id

    tags = {
    Name        = "darkrose-${var.infra-env}-nat-gateway"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    VPC         = aws_vpc.darkrose-vpc.id
    Role        = "private"
    }
}

resource "aws_route_table" "public-routetable" {
    vpc_id = aws_vpc.darkrose-vpc.id

    tags = {
    Name        = "darkrose-${var.infra-env}-public-routetable"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    VPC         = aws_vpc.darkrose-vpc.id
    Role        = "public"
    }
}

resource "aws_route_table" "private-routetable" {
    vpc_id = aws_vpc.darkrose-vpc.id

    tags = {
    Name        = "darkrose-${var.infra-env}-private-routetable"
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
    VPC         = aws_vpc.darkrose-vpc.id
    Role        = "private"
    }
}

resource "aws_route" "public-route" {
    route_table_id = aws_route_table.public-routetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.darkrose-igw.id
}

resource "aws_route" "private-route" {
    route_table_id = aws_route_table.private-routetable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_nat_gateway.darkrose-nat.id
}

resource "aws_route_table_association" "public-routetable-association" {
    for_each = aws_subnet.public-subnet
    subnet_id = aws_subnet.public-subnet[each.key].id
    route_table_id = aws_route_table.public-routetable.id
}

resource "aws_route_table_association" "private-routetable-association" {
    for_each = aws_subnet.private-subnet
    subnet_id = aws_subnet.private-subnet[each.key].id
    route_table_id = aws_route_table.private-routetable.id
}
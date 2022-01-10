resource "aws_security_group" "public-sg" {
    name = "darkrose-${var.infra-env}-public-sg"
    description = "Public Internet Access"
    vpc_id = module.vpc.vpc_id

    tags = {
        Name        = "darkrose-${var.infra-env}-public-sg"
        Role        = "Public-SG"
        Project     = "Darkrose.io"
        Environment = var.infra-env
        ManagedBy   = "terraform"
    }
}

resource "aws_security_group_rule" "public-sg-out-all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.public-sg.id
}

resource "aws_security_group_rule" "public-sg-in-ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.public-sg.id
}

resource "aws_security_group_rule" "public-sg-in-http" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.public-sg.id
}

resource "aws_security_group_rule" "public-sg-in-https" {
    type = "ingress"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.public-sg.id
}

resource "aws_security_group" "private-sg" {
    name = "darkrose-${var.infra-env}-private-sg"
    description = "Private Internet Access"
    vpc_id = module.vpc.vpc_id

    tags = {
        Name        = "darkrose-${var.infra-env}-private-sg"
        Role        = "Private-SG"
        Project     = "Darkrose.io"
        Environment = var.infra-env
        ManagedBy   = "terraform"
    }
}

resource "aws_security_group_rule" "private-sg-out-all" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = aws_security_group.private-sg.id
}

resource "aws_security_group_rule" "private-sg-in-from-vpc" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = [module.vpc.vpc_cidr_block]

    security_group_id = aws_security_group.private-sg.id
}
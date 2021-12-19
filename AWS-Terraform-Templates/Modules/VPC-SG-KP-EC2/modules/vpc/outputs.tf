output vpc-id-output {
    value = aws_vpc.darkrose-vpc.id
}

output vpc-cidr-output {
    value = aws_vpc.darkrose-vpc.cidr_block
}

output vpc-public-subnets-output {
    value = {
        for subnet in aws_subnet.public-subnet :
        subnet.id => subnet.cidr_block
    }
}

output vpc-private-subnets-output {
    value = {
        for subnet in aws_subnet.private-subnet :
        subnet.id => subnet.cidr_block
    }
}

output security-group-public-output {
    value = aws_security_group.public-sg.id
}

output security-group-private-output {
    value = aws_security_group.private-sg.id
}

output keypair-web-key-output {
    value = aws_key_pair.web-key.key_name
}

output keypair-worker-key-output {
    value = aws_key_pair.worker-key.key_name
}
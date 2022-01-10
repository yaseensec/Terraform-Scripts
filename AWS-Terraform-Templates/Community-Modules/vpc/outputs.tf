output vpc-id-output {
    value = module.vpc.vpc_id
}

output vpc-cidr-output {
    value = module.vpc.vpc_cidr_block
}

output vpc-public-subnets-output {
    value = module.vpc.public_subnets
}

output vpc-private-subnets-output {
    value = module.vpc.private_subnets
}

output vpc-database-subnets-output {
    value = module.vpc.database_subnets
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
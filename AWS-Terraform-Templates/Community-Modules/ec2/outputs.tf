output darkrose-eip-addr-output {
    value = aws_eip.darkrose-eip-addr.*.public_ip
}

output darkrose-instance-output {
    value = module.ec2_instance.id[0]
}
output darkrose-eip-addr-output {
    value = aws_eip.darkrose-eip-addr.*.public_ip
}

output darkrose-instance-output {
    value = aws_instance.darkrose-instance.id
}
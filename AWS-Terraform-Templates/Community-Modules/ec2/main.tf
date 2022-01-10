resource "random_shuffle" "subnets" {
  input = var.subnets
  result_count = 1
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "darkrose-${var.infra-env}"

  ami           = var.instance-ami
  instance_type = var.instance-type
  subnet_id = random_shuffle.subnets.result[0]
  vpc_security_group_ids = var.security-groups
  key_name = var.key-name

  root_block_device = [{
    volume_size = var.instance-root-device-size
    volume_type = "gp2"
  }]

  tags = merge(
    {
      Name        = "darkrose-${var.infra-env}"
      Role        = var.infra-role
      Project     = "Darkrose.io"
      Environment = var.infra-env
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

resource "aws_eip" "darkrose-eip-addr" {

  count = (var.create-eip) ? 1 : 0

  vpc = true

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "darkrose-${var.infra-env}-web"
    Role        = var.infra-role
    Project     = "Darkrose.io"
    Environment = var.infra-env
    ManagedBy   = "terraform"
  }
}

resource "aws_eip_association" "darkrose-eip-association" {
  count = (var.create-eip) ? 1 : 0

  instance_id   = module.ec2_instance.id[0]
  allocation_id = aws_eip.darkrose-eip-addr[0].id
}
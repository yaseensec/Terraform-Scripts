output "vpcid" {
    value = "${local.vpcid}"
}

output "publicsubnetid1" {
    value = "${local.publicsubnetid1}"
}

output "publicsubnetid2" {
    value = "${local.publicsubnetid2}"
}

output "privatesubnetid" {
    value = "${local.privatesubnetid}"
}

output "env_suffix" {
    value = "${local.env}"
}

locals {
    env = "${terraform.workspace}"

    vpcid_env = {
        default = "vpc-138fbc7b"
        staging = "vpc-138fbc7b"
        production = "vpc-138fbc7b"
    }

    vpcid = "${lookup(local.vpcid_env, local.env)}"

    publicsubnetid1_env = {
        default = "subnet-9ab63fd6"
        staging = "subnet-9ab63fd6"
        production = "subnet-9ab63fd6"
    }

    publicsubnetid1 = "${lookup(local.publicsubnetid1_env, local.env)}"

    publicsubnetid2_env = {
        default = "subnet-09d58d61"
        staging = "subnet-09d58d61"
        production = "subnet-09d58d61"
    }

    publicsubnetid2 = "${lookup(local.publicsubnetid2_env, local.env)}"

    privatesubnet_env = {
        default = "subnet-9cb96ae7"
        staging = "subnet-9cb96ae7"
        production = "subnet-9cb96ae7"
    }

    privatesubnetid = "${lookup(local.privatesubnet_env, local.env)}"

}
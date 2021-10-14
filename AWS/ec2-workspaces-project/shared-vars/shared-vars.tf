locals {
    env = "${terraform.workspace}"
    env-suffix-env{
        default = "stagging"
        stagging = "stagging"
        production = "production"
    }
    env-suffix = "${lookup(local.env-suffix-env, local.env)}"
}

output "env-suffix" {
    value = "${local.env-suffix}"
}

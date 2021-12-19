locals {
  env = terraform.workspace
  env_suffix_env = {
    default = "Default"
    staging = "Staging"
    production = "Production"
  } 
  env_suffix = "${lookup(local.env_suffix_env, local.env)}"
}

output "env-suffix-output" {
  value = local.env_suffix
}
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "Yaseenins"

    workspaces {
      name = "terraform-getting-started"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

locals {
  project_name = "yaseen"
}


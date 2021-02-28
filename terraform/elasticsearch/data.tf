data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

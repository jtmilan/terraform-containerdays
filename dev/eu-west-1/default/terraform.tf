terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "terraform-state-containerdays-milantech-dev"
    key    = "eu-west-3/default.tfstate"
    region = "eu-west-3"
    role_arn = data.aws_kms_secrets.drone.plaintext["trusted_account_arn"]

    // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/5018
    skip_metadata_api_check = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
  profile = "dev-eu-west-1"
}

provider "template" {
  version = "~> 2.0"
}

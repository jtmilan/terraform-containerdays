terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "terraform-state-containerdays-milantech-dev"
    key    = "eu-west-3/default.tfstate"
    region = "eu-west-3"

    // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/5018
    skip_metadata_api_check = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"

  assume_role {
    role_arn     = data.aws_kms_secrets.drone.plaintext["trusted_account_arn"]
    session_name = "DRONESESSION"
    external_id  = [data.aws_kms_secrets.drone.plaintext["external_id"]]
  }
}

provider "template" {
  version = "~> 2.0"
}

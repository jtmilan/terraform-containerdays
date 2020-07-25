terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "terraform-state-containerdays-demo"
    key    = "eu-west-3/default.tfstate"
    region = "eu-west-3"

    // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/5018
    skip_metadata_api_check = true
  }
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

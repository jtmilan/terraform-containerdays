terraform {
  backend "s3" {
    bucket = "terraform-state-containerdays-milantech-dev"
    key    = "eu-west-3/vpc1.tfstate"
    region = "eu-west-3"

    // workaround for https://github.com/terraform-providers/terraform-provider-aws/issues/5018
    skip_metadata_api_check = true
  }
}

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "eu-west-1"
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

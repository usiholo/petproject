#  Configure the AWS Provider
provider "aws" {
  region  = var.aws_region
  profile = var.project_profile
}

locals {
  name = "EU2petadoption"
}

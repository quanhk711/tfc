provider "aws" {
  region = var.region
}

data "aws_region" "current" {}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = "${terraform.workspace}"
    Project     = "${var.project}"
    Owner       = "${var.contact}"
    ManagedBy   = "Terraform"
  }
}


module "vpc" {
  source              = "git::https://github.com/devopsifyco/terraform_module_template.git//module_aws_vpc"
  common_tags         = local.common_tags
  prefix              = local.prefix
  cidr_block          = "10.1.0.0/16"
  cidr_publish_subnet = ["10.1.1.0/24", "10.1.2.0/24"]
  cidr_private_subnet = ["10.1.10.0/24", "10.1.11.0/24"]
  availability_zone   = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b"]
  nat_gateway_enabled = false
}

#terraform block for versions of providers and terraform itself
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28" #this checks the latest version of the provider in the 6.28 series, which is compatible with terraform 0.12 and above. It ensures that we are using a version of the provider that is compatible with our terraform version and has the features we need for our infrastructure.
    }
  }
}

#provider block for aws
provider "aws" {
  region = var.aws_region
  profile = "default"
}

variable "cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"   # Changed from 237.84.2.178/16
}


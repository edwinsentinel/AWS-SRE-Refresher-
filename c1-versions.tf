#terraform Block

terraform {
  required_version = ">=1.6" # which means any version equal or above this
  required_providers {
    aws ={
        source = "hashicorp/aws"
        version = ">=5.0"
    }
    null ={
        source = "hashicorp/null"
        version = ">=3.0"
    }
  }
}

#provider Block
provider "aws" {
  region = var.aws_region
}  

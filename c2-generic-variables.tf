#input variables
#AWS region
variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

#Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}

#Business Divisdion Variable
variable "business_division" {
  description = "Business Division is the large infrastructure that this infra belongs"
  type        = string
  default     = "sap"
}
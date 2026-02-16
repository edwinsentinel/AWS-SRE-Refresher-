#create vpc module

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.0" #this checks the latest version of the module in the 6.6 series, which is compatible with terraform 0.12 and above. It ensures that we are using a version of the module that is compatible with our terraform version and has the features we need for our infrastructure.

#vpc configuration
    name = "my-vpc"
    cidr = var.cidr
#subnet configuration
    azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
    private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    public_subnets  = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]

    #database subnets
    database_subnets= ["10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
    create_database_subnet_group = true
    create_database_subnet_route_table = true
    #create_database_internet_gateway_route =  true
    #create_database_nat_gateway_route = true

    #NAt gaateway for outbound internet access for private subnets
    enable_nat_gateway = true
    single_nat_gateway = true
   

   #VPC DNS parameters
    enable_dns_hostnames = true
    enable_dns_support = true


    public_subnet_tags = {
        Name = "public-subnet"
    }
    private_subnet_tags = {
        Name = "private-subnet"
    }
    database_subnet_tags = {
        Name = "database-subnet"
    }

    tags={
        Environment = "dev"
        Project     = "vpc-project"
    }

    vpc_tags = {
        Name = "vpc-dev"
    }
#block in terraform has ={} and an argument only has =value within the module block, we can use both to set values for the module variables. The block is used when we have multiple values to set for a variable, while the argument is used when we have a single value to set for a variable. In this case, we are using both to set values for the variables in the vpc module.

  
}
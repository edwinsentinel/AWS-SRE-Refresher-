# AWS EKS Cluster Basics with Terraform

This Terraform configuration sets up an AWS EKS (Elastic Kubernetes Service) cluster with associated networking, bastion host, and node groups.

## Overview

The infrastructure includes:
- VPC with public, private, and database subnets
- NAT Gateway for outbound traffic from private subnets
- EC2 Bastion Host for secure access to private resources
- EKS Cluster with IAM roles and policies
- Public Node Group for worker nodes
- Security groups and networking configuration

## Terraform Files Description

### Configuration Files

#### `c1-version.tf`
- Defines Terraform version requirements (>= 1.6.0)
- Configures AWS provider (version >= 5.31)
- Sets AWS region via variable

#### `c2-01-generic-variables.tf`
- Defines generic input variables:
  - `aws_region`: AWS region (default: us-east-1)
  - `environment`: Environment prefix (default: dev)
  - `business_divsion`: Business division (default: SAP)

#### `c2-02-local-values.tf`
- Defines local values for resource naming and tagging:
  - `owners`: Set to business division
  - `environment`: Environment value
  - `name`: Combined name format `{business_divsion}-{environment}`
  - `common_tags`: Standard tags for all resources
  - `eks_cluster_name`: Full cluster name including cluster name variable

### VPC Configuration

#### `c3-01-vpc-variables.tf`
- VPC-specific input variables:
  - `vpc_name`: VPC name (default: myvpc)
  - `vpc_cidr_block`: VPC CIDR (default: 10.0.0.0/16)
  - `vpc_public_subnets`: Public subnet CIDRs
  - `vpc_private_subnets`: Private subnet CIDRs
  - `vpc_database_subnets`: Database subnet CIDRs
  - NAT Gateway and database subnet configuration flags

#### `c3-02-vpc-module.tf`
- Uses terraform-aws-modules/vpc/aws module to create:
  - VPC with specified CIDR
  - Public and private subnets across available AZs
  - Database subnets
  - NAT Gateway for outbound traffic
  - DNS settings enabled
  - Kubernetes-specific tags for ELB integration

#### `c3-03-vpc-outputs.tf`
- Outputs VPC information:
  - VPC ID and CIDR
  - Public and private subnet IDs
  - NAT Gateway public IPs
  - Availability zones

### EC2 Bastion Host Configuration

#### `c4-01-ec2bastion-variables.tf`
- EC2 instance variables:
  - `instance_type`: Instance type (default: t3.micro)
  - `instance_keypair`: SSH key pair name (default: eks-terraform-key)

#### `c4-02-ec2bastion-outputs.tf`
- Outputs bastion host information:
  - Instance IDs
  - Public IP (Elastic IP)

#### `c4-03-ec2bastion-securitygroups.tf`
- Creates security group for bastion host:
  - Allows SSH (port 22) from anywhere (0.0.0.0/0)
  - Allows all outbound traffic

#### `c4-04-ami-datasource.tf`
- Data source to fetch latest Amazon Linux 2 AMI
- Filters for HVM, EBS, x86_64 architecture

#### `c4-05-ec2bastion-instance.tf`
- Creates EC2 instance using terraform-aws-modules/ec2-instance/aws
- Places instance in first public subnet
- Associates with bastion security group

#### `c4-06-ec2bastion-elasticip.tf`
- Allocates Elastic IP for bastion host
- Associates EIP with bastion instance

#### `c4-07-ec2bastion-provisioners.tf`
- Uses null_resource with provisioners to:
  - Copy SSH private key to bastion host
  - Set correct permissions on the key
  - Log VPC creation details locally

### EKS Cluster Configuration

#### `c5-01-eks-variables.tf`
- EKS cluster variables:
  - `cluster_name`: Cluster name (default: eksdemo)
  - `cluster_service_ipv4_cidr`: Service CIDR
  - `cluster_version`: Kubernetes version
  - Endpoint access settings (public/private)

#### `c5-02-eks-outputs.tf`
- Outputs EKS cluster information:
  - Cluster ID, ARN, endpoint
  - Certificate authority data
  - IAM role information
  - OIDC issuer URL
  - Node group IDs and ARNs

#### `c5-03-iamrole-for-eks-cluster.tf`
- Creates IAM role for EKS cluster control plane
- Attaches required policies:
  - AmazonEKSClusterPolicy
  - AmazonEKSVPCResourceController

#### `c5-04-iamrole-for-eks-nodegroup.tf`
- Creates IAM role for EKS node groups
- Attaches required policies:
  - AmazonEKSWorkerNodePolicy
  - AmazonEKS_CNI_Policy
  - AmazonEC2ContainerRegistryReadOnly

#### `c5-05-securitygroups-eks.tf`
- Placeholder file for EKS security groups (currently empty)

#### `c5-06-eks-cluster.tf`
- Creates EKS cluster resource
- Configures VPC networking (public subnets)
- Sets endpoint access (public by default)
- Enables cluster logging (API, audit, authenticator, etc.)
- Depends on IAM role policy attachments

#### `c5-07-eks-node-group-public.tf`
- Creates public EKS node group
- Uses t3.medium instances
- Configures scaling (1-2 nodes)
- Enables SSH access with specified key pair
- Places nodes in public subnets

#### `c5-08-eks-node-group-private.tf`
- Defines private node group (currently commented out)
- Similar configuration to public node group but uses private subnets

### Variable Files

#### `terraform.tfvars`
- Sets generic variables:
  - Region: us-east-1
  - Environment: stag
  - Business Division: hr

#### `vpc.auto.tfvars`
- VPC configuration values
- Subnet CIDRs for different tiers
- NAT Gateway and database settings

#### `ec2bastion.auto.tfvars`
- Bastion host instance type and key pair

#### `eks.auto.tfvars`
- EKS cluster configuration
- Cluster name, version, networking

## Usage

1. Ensure you have AWS credentials configured
2. Place your SSH private key (`eks-terraform-key.pem`) in the `private-key/` directory
3. Initialize Terraform: `terraform init`
4. Plan the deployment: `terraform plan`
5. Apply the configuration: `terraform apply`

## Outputs

After deployment, the following outputs are available:
- VPC details (ID, subnets, NAT IPs)
- Bastion host public IP
- EKS cluster information (endpoint, certificates, etc.)
- Node group details

## Security Notes

- Bastion host allows SSH from anywhere (0.0.0.0/0) - consider restricting in production
- EKS API endpoint is publicly accessible - configure appropriately for your use case
- Private node group is commented out - uncomment for production workloads

## Prerequisites

- AWS CLI configured with appropriate permissions
- SSH key pair created in AWS
- Terraform >= 1.6.0
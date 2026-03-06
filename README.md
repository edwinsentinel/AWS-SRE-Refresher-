# AWS EC2 Bastion Host Terraform Configuration

This Terraform configuration sets up an AWS VPC with public and private subnets, security groups, and EC2 instances including a Bastion Host for secure access to private instances.

## Architecture

- **VPC**: Custom VPC with public and private subnets
- **Bastion Host**: EC2 instance in public subnet for SSH access to private instances
- **Private Instances**: EC2 instances in private subnets running a web application
- **Security Groups**: Configured for secure access

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform v1.0+
- SSH key pair (eks-terraform-key.pem) exists in AWS

## Files Overview

- `c1-versions.tf`: Terraform and provider versions
- `c2-generic-variables.tf`: Generic variables (region, environment, business division)
- `c3-vpc.tf`: VPC module configuration
- `c4-*.tf`: VPC variables and modules
- `c5-*.tf`: Security group configurations
- `c6-*.tf`: AMI data source
- `c7-*.tf`: EC2 instance configurations
- `c8-elasticip.tf`: Elastic IP for Bastion Host
- `c9-nullresource-provisioners.tf`: Provisioners for file and remote execution
- `app1-install.sh`: User data script for private instances
- `*.tfvars`: Variable files (not committed to Git)
- `private-key/`: Directory containing private key (not committed to Git)

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Validate configuration**:
   ```bash
   terraform validate
   ```

3. **Plan deployment**:
   ```bash
   terraform plan
   ```

4. **Apply configuration**:
   ```bash
   terraform apply
   ```

5. **Access Bastion Host**:
   ```bash
   ssh -i private-key/eks-terraform-key.pem ec2-user@<bastion-public-ip>
   ```

6. **From Bastion Host, access private instances**:
   ```bash
   ssh -i /tmp/eks-terraform-key.pem ec2-user@<private-instance-ip>
   ```

## Variables

Key variables (defined in .tfvars files):
- `aws_region`: AWS region (default: us-east-1)
- `environment`: Environment prefix (e.g., stag)
- `business_division`: Business division (e.g., HR)
- `instance_type`: EC2 instance type (default: t3.micro)
- `instance_keypair`: SSH key pair name (default: eks-terraform-key)

## Security Notes

- Private key files are not committed to Git
- Use strong passwords and restrict SSH access
- Regularly rotate keys and update security groups

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## Modules Used

- `terraform-aws-modules/vpc/aws`: VPC creation
- `terraform-aws-modules/ec2-instance/aws`: EC2 instance creation
- `terraform-aws-modules/security-group/aws`: Security group creation
# -----------------------------------------------
# terraform.tfvars
# Supplies actual values for the variables defined
# in variables.tf. This file is intentionally
# excluded from version control (.gitignore) since
# it may contain sensitive or environment-specific
# values like key pair names.
# -----------------------------------------------

aws_region   = "us-east-1"
project_name = "tf-portfolio"
environment  = "dev"

# Networking
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# EC2 Bastion
bastion_instance_type = "t2.micro"
bastion_key_name      = "YOUR_KEY_PAIR_NAME"   # Replace with your actual AWS key pair name

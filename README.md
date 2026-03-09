# AWS Three-Tier Network Infrastructure with Terraform

A production-style AWS network infrastructure built with Terraform, demonstrating real-world VPC architecture patterns including public/private subnet separation, a NAT Gateway, and a bastion host for secure access.

---

## Architecture Overview

```
                          ┌─────────────────────────────────────────────┐
                          │                   AWS VPC                    │
                          │              (10.0.0.0/16)                   │
                          │                                              │
                          │   ┌──────────────┐   ┌──────────────┐       │
              Internet ───┼──▶│ Public Sub 1 │   │ Public Sub 2 │       │
                          │   │ 10.0.1.0/24  │   │ 10.0.2.0/24  │       │
                          │   │  (us-east-1a)│   │  (us-east-1b)│       │
                          │   │              │   │              │       │
                          │   │  [Bastion]   │   │              │       │
                          │   │  [NAT GW]    │   │              │       │
                          │   └──────┬───────┘   └──────────────┘       │
                          │          │ (NAT)                             │
                          │   ┌──────▼───────┐   ┌──────────────┐       │
                          │   │ Private Sub 1│   │ Private Sub 2│       │
                          │   │ 10.0.10.0/24 │   │ 10.0.20.0/24 │       │
                          │   │  (us-east-1a)│   │  (us-east-1b)│       │
                          │   │              │   │              │       │
                          │   │  [App/DB]    │   │  [App/DB]    │       │
                          │   └──────────────┘   └──────────────┘       │
                          │                                              │
                          └─────────────────────────────────────────────┘
```

**Traffic flow:**
- Public subnets route outbound traffic through an **Internet Gateway**
- Private subnets route outbound traffic through a **NAT Gateway** (no direct inbound access from internet)
- The **Bastion Host** in the public subnet is the only entry point for SSH access to private resources

---

## Resources Deployed

| Resource | Description |
|---|---|
| `aws_vpc` | VPC with DNS support enabled |
| `aws_subnet` (x4) | 2 public + 2 private subnets across 2 AZs |
| `aws_internet_gateway` | Allows public subnets to reach the internet |
| `aws_eip` | Elastic IP attached to the NAT Gateway |
| `aws_nat_gateway` | Allows private subnets to initiate outbound traffic |
| `aws_route_table` (x2) | Separate routing rules for public and private subnets |
| `aws_security_group` (x2) | Bastion SG (SSH open) + Private SG (SSH from bastion only) |
| `aws_instance` | Amazon Linux 2 bastion host in the public subnet |

---

## Project Structure

```
tfPortfolioProject/
├── main.tf           # All AWS resource definitions
├── variables.tf      # Input variable declarations with types and descriptions
├── outputs.tf        # Values exposed after apply (IPs, IDs, etc.)
├── terraform.tfvars  # Actual variable values (excluded from version control)
└── .gitignore        # Prevents state files and secrets from being committed
```

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.3.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with credentials (`aws configure`)
- An existing EC2 Key Pair in your target AWS region

---

## Usage

**1. Clone the repository**
```bash
git clone https://github.com/AnthonyMillerGit/terraformInterviewProject.git
cd aws-vpc-terraform
```

**2. Create your tfvars file**
```bash
cp terraform.tfvars.example terraform.tfvars
```
Edit `terraform.tfvars` and replace `YOUR_KEY_PAIR_NAME` with your actual EC2 key pair name.

**3. Initialize Terraform**
```bash
terraform init
```

**4. Preview the changes**
```bash
terraform plan
```

**5. Deploy**
```bash
terraform apply
```

After a successful apply, Terraform will print outputs including your bastion host's public IP.

**6. SSH into the bastion host**
```bash
ssh -i /path/to/your-key.pem ec2-user@<bastion_public_ip>
```

**7. Tear down when done**
```bash
terraform destroy
```

> ⚠️ The NAT Gateway incurs hourly AWS charges. Remember to `terraform destroy` when not in use.

---

## Configuration

All configurable values live in `terraform.tfvars`. Key settings:

| Variable | Default | Description |
|---|---|---|
| `aws_region` | `us-east-1` | AWS region to deploy into |
| `project_name` | `tf-portfolio` | Prefix applied to all resource names and tags |
| `environment` | `dev` | Environment tag (dev / staging / prod) |
| `vpc_cidr` | `10.0.0.0/16` | CIDR block for the VPC |
| `bastion_instance_type` | `t2.micro` | EC2 instance type for the bastion host |
| `bastion_key_name` | *(required)* | Name of your EC2 key pair for SSH access |

---

## Security Notes

- The bastion security group allows SSH (`port 22`) from `0.0.0.0/0` for demonstration purposes. In a production environment, restrict this to your specific IP or a corporate CIDR range.
- Private subnet resources are only reachable from the bastion host — not directly from the internet.
- `terraform.tfvars` is excluded from version control to prevent accidental exposure of environment-specific configuration.

---

## Built With

- [Terraform](https://www.terraform.io/) — Infrastructure as Code
- [AWS](https://aws.amazon.com/) — Cloud provider

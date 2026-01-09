# AWS VPC Terraform Module (Part 5)

![Terraform](https://img.shields.io/badge/Terraform-v1.0+-623CE4?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-VPC-FF9900?logo=amazon-aws)
![License](https://img.shields.io/badge/license-MIT-green)

A production-ready Terraform module for creating a complete AWS VPC infrastructure with public and private subnets, NAT Gateway, Internet Gateway, and security groups. This is the final part of a 5-part DevOps learning series.

## 🏗️ Architecture

This module creates a robust VPC architecture following AWS best practices:
```
┌─────────────────────────────────────────────────────┐
│                      VPC                            │
│                 (10.0.0.0/16)                       │
│                                                     │
│  ┌──────────────────┐    ┌──────────────────┐       │
│  │  Public Subnet   │    │  Public Subnet   │       │
│  │   10.0.1.0/24    │    │   10.0.2.0/24    │       │
│  │     (AZ-a)       │    │     (AZ-b)       │       │  
│  └────────┬─────────┘    └─────────┬────────┘       │
│           │                        │                │
│           └────────┬───────────────┘                │
│                    │                                │
│            ┌───────▼────────┐                       │
│            │ Internet Gateway│                      │
│            └────────────────┘                       │
│                                                     │
│  ┌──────────────────┐    ┌──────────────────┐       │
│  │ Private Subnet   │    │ Private Subnet   │       │
│  │   10.0.11.0/24   │    │   10.0.12.0/24   │       │
│  │     (AZ-a)       │    │     (AZ-b)       │       │
│  └────────┬─────────┘    └─────────┬────────┘       │
│           │                        │                │
│           └────────┬───────────────┘                │
│                    │                                │
│              ┌─────▼──────┐                         │
│              │ NAT Gateway │                        │
│              └────────────┘                         │
└─────────────────────────────────────────────────────┘
```

## 🚀 Features

- **VPC with customizable CIDR block**
- **Multi-AZ deployment** for high availability
- **Public subnets** with Internet Gateway
- **Private subnets** with NAT Gateway
- **Route tables** properly configured for public/private traffic
- **Security groups** for common use cases
- **Modular design** for reusability
- **Output values** for integration with other modules

## 📁 Project Structure
```
.
├── README.md
├── modules/
│   └── vpc/
│       ├── main.tf           # Main VPC resources
│       ├── variables.tf      # Input variables
│       └── outputs.tf        # Output values
└── examples/
    └── simple/
        └── main.tf           # Example usage
```

## 🛠️ Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- AWS Account with appropriate credentials configured
- AWS CLI (optional, for credential management)

## 📋 Usage

### Basic Example
```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name            = "my-vpc"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  tags = {
    Environment = "dev"
    Project     = "learning-terraform"
  }
}
```

### Advanced Example with All Options
```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_name             = "production-vpc"
  vpc_cidr             = "10.0.0.0/16"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  
  enable_nat_gateway = true
  single_nat_gateway = false  # NAT Gateway per AZ
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = "production"
    Project     = "my-app"
    ManagedBy   = "terraform"
  }
}
```

## 🚀 Deployment

### 1. Clone the repository
```bash
git clone https://github.com/MBaranekTech/terraform-aws-vpc-infrastructure.git
cd terraform-aws-vpc-infrastructure
```

### 2. Configure AWS credentials
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Navigate to the example directory
```bash
cd examples/simple
```

### 4. Initialize Terraform
```bash
terraform init
```

### 5. Review the plan
```bash
terraform plan
```

### 6. Apply the configuration
```bash
terraform apply
```

### 7. Cleanup (when done)
```bash
terraform destroy
```

## 📊 Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| vpc_name | Name of the VPC | `string` | - | yes |
| vpc_cidr | CIDR block for VPC | `string` | `"10.0.0.0/16"` | no |
| availability_zones | List of availability zones | `list(string)` | - | yes |
| public_subnet_cidrs | CIDR blocks for public subnets | `list(string)` | - | yes |
| private_subnet_cidrs | CIDR blocks for private subnets | `list(string)` | - | yes |
| enable_nat_gateway | Enable NAT Gateway | `bool` | `true` | no |
| single_nat_gateway | Use single NAT Gateway for all private subnets | `bool` | `true` | no |
| enable_dns_hostnames | Enable DNS hostnames in VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support in VPC | `bool` | `true` | no |
| tags | Tags to apply to all resources | `map(string)` | `{}` | no |

## 📤 Module Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr | CIDR block of the VPC |
| public_subnet_ids | IDs of public subnets |
| private_subnet_ids | IDs of private subnets |
| internet_gateway_id | ID of the Internet Gateway |
| nat_gateway_ids | IDs of NAT Gateways |
| public_route_table_id | ID of public route table |
| private_route_table_ids | IDs of private route tables |

## 🎯 Skills Demonstrated

This project showcases core DevOps networking skills:

- ✅ **VPC Architecture Design** - Understanding of AWS networking fundamentals
- ✅ **Subnet Management** - Public/private subnet separation
- ✅ **Routing** - Route tables, Internet Gateway, NAT Gateway configuration
- ✅ **High Availability** - Multi-AZ deployment pattern
- ✅ **Infrastructure as Code** - Terraform module development
- ✅ **Modular Design** - Reusable, maintainable code structure

## 🔍 What I Learned

Through this project, I gained hands-on experience with:

1. **AWS VPC fundamentals** - How to architect secure network infrastructure
2. **Terraform modules** - Building reusable infrastructure components
3. **Network segmentation** - Separating public and private resources
4. **High availability patterns** - Deploying across multiple availability zones
5. **Gateway configuration** - Internet Gateway and NAT Gateway setup
6. **Best practices** - Following AWS Well-Architected Framework principles

## 📚 Learning Series

This is **Part 5** (Final) of my Terraform/Terragrunt DevOps learning series:

- **Part 1**: aws-infra-with-terragrunt
- **Part 2**: terraform-terragrunt-aws-environments
- **Part 3**: Terraform AWS EC2 Demo
- **Part 4**: Terraform CI/CD Pipeline with GitHub Actions
- **Part 5**: AWS VPC Module *(You are here)*

## 🤝 Contributing

This is a learning project, but suggestions and improvements are welcome! Feel free to open an issue or submit a pull request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 👤 Author

Created as part of my DevOps learning journey. Connect with me:

- GitHub: [@MBaranekTech](https://github.com/MBaranekTech/)
- LinkedIn: [baranekm](https://www.linkedin.com/in/baranekm-736a7532b/)

---

⭐ If you found this project helpful, please consider giving it a star!
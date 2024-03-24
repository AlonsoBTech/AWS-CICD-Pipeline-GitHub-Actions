# AWS Terraform CICD Pipeline

## 📋 <a name="table">Table of Contents</a>

1. 🤖 [Introduction](#introduction)
2. ⚙️ [Prerequisites](#prerequisites)
3. 🔋 [What Is Being Created](#what-is-being-created)
4. 🤸 [Quick Guide](#quick-guide)
5. 🔗 [Links](#links)

## <a name="introduction">🤖 Introduction</a>

Using GitHub Actions we will create a CICD Pipeline to deploy resources to AWS using Terraform code.

## <a name="prerequisites">⚙️ Prerequisites</a>

Make sure you have the following:

- AWS Account
- AWS IAM User
- Terraform Installed
- IDE of choice to write Terraform code

## <a name="what-is-being-created">🔋 What Is Being Created</a>

What we will be creating:

- VPC
- VPC Subnet
- VPC Internet Gateway
- VPC Route Table
- VPC Route Table Association

## <a name="quick-guide">🤸 Quick Guide</a>

**First create your git repository (name it whatever you like) then clone the git repository**

```bash
git clone https://github.com/AlonsoBTech/AWS-CICD-Pipeline.git
cd AWS-CICD-Pipeline
```

**Create your Terraform providers.tf file**

</details>

<details>
<summary><code>Terraform/providers.tf</code></summary>

```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }
}

provider "aws" {
  region  = "ca-central-1"
}
```
</details>

**Create your Terraform main.tf file**

</details>

<details>
<summary><code>Terraform/main.tf</code></summary>

```bash
### Creating VPC
resource "aws_vpc" "GitHub_test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Git_VPC"
  }
}

### Creating VPC Subnet
resource "aws_subnet" "Git_Public_Subnet_1" {
  vpc_id                  = aws_vpc.GitHub_test.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ca-central-1a"

  tags = {
    Name = "Git_Public"
  }
}


### Creating VPC Internet Gateway
resource "aws_internet_gateway" "Git_IGW" {
  vpc_id = aws_vpc.GitHub_test.id

  tags = {
    Name = "Git_IGW"
  }
}

### Creating VPC Route Table
resource "aws_route_table" "Git_Public_Route" {
  vpc_id = aws_vpc.GitHub_test.id

  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Git_IGW.id
  }

  tags = {
    Name = "Git_Pub_RT"
  }
}

### Creating VPC Route Table Association
resource "aws_route_table_association" "Git_pub_asso1" {
  subnet_id      = aws_subnet.Git_Public_Subnet_1.id
  route_table_id = aws_route_table.Git_Public_Route.id
}

</details>


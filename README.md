# Infrastructure_AWS

Reusable Terraform modules for provisioning and managing AWS infrastructure.

## Overview

Infrastructure_AWS is a centralized collection of reusable Terraform modules designed to standardize, automate, and accelerate AWS infrastructure deployments.

The goal of this repository is to provide production-ready Infrastructure as Code (IaC) building blocks that can be consumed by application teams, DevOps engineers, platform engineers, and cloud administrators.

By leveraging modular Terraform architecture, infrastructure can be deployed consistently across multiple environments while reducing duplication, configuration drift, and operational risk.

---

## Objectives

* Standardize AWS resource provisioning
* Promote Infrastructure as Code best practices
* Reduce repetitive Terraform development
* Improve deployment consistency
* Support multi-environment deployments
* Enable scalable cloud infrastructure management
* Simplify onboarding for new engineers

---

## Repository Structure

```text
Infrastructure_AWS/
│
├── modules/
│   ├── vpc/
│   ├── ec2/
│   ├── s3/
│   ├── rds/
│   ├── iam/
│   ├── security-group/
│   ├── alb/
│   ├── route53/
│   ├── cloudwatch/
│   ├── ecr/
│   ├── eks/
│   └── dynamodb/
│
├── environments/
│   ├── dev/
│   ├── test/
│   ├── stage/
│   └── prod/
│
├── examples/
│   ├── simple-vpc/
│   ├── web-app/
│   └── eks-cluster/
│
├── docs/
│
└── README.md
```

---

## Module Design Standards

Each Terraform module should contain:

```text
module-name/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── README.md
└── examples/
```

### main.tf

Defines AWS resources.

### variables.tf

Defines configurable inputs.

### outputs.tf

Exposes reusable values.

### versions.tf

Specifies Terraform and provider requirements.

### README.md

Documents module usage and examples.

---

## Example Module Usage

### VPC Module

```hcl
module "vpc" {
  source = "../../modules/vpc"

  environment         = "dev"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
}
```

---

## Example EC2 Module

```hcl
module "web_server" {
  source = "../../modules/ec2"

  instance_name = "web01"
  instance_type = "t3.micro"
  ami_id        = data.aws_ami.amazon_linux.id
}
```

---

## Supported AWS Services

Current module roadmap includes:

### Networking

* VPC
* Subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* VPC Endpoints

### Compute

* EC2
* Auto Scaling Groups
* Launch Templates

### Containers

* ECR
* EKS

### Storage

* S3
* EFS

### Databases

* RDS
* DynamoDB

### Security

* IAM Roles
* IAM Policies
* Security Groups
* KMS
* Secrets Manager

### Monitoring

* CloudWatch
* SNS
* EventBridge

### DNS

* Route53

---

## Deployment Workflow

Infrastructure changes should follow a standard Git workflow:

```text
Feature Branch
      ↓
Pull Request
      ↓
Terraform Validate
      ↓
Terraform Format
      ↓
Terraform Plan
      ↓
Peer Review
      ↓
Approval
      ↓
Terraform Apply
```

---

## Terraform Best Practices

* Use remote state storage
* Enable state locking
* Avoid hardcoded values
* Use variables and outputs
* Follow least privilege IAM principles
* Tag all AWS resources
* Keep modules small and focused
* Version modules appropriately

---

## Remote State Example

```hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "dev/networking.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}
```

---

## Security Considerations

Infrastructure deployments should integrate with:

* GitHub Actions
* Terraform Validate
* Terraform Plan
* Checkov
* Trivy
* Snyk
* GitGuardian

Recommended workflow:

```text
Terraform Code
      ↓
Validate
      ↓
Security Scan
      ↓
Plan
      ↓
Approval
      ↓
Apply
```

---

## Versioning

This repository follows semantic versioning.

```text
MAJOR.MINOR.PATCH
```

Example:

```text
v1.0.0
v1.1.0
v1.1.1
```

---

## Future Enhancements

* Multi-account AWS deployments
* AWS Organizations support
* Cross-account IAM roles
* Terraform Cloud integration
* GitHub Actions automation
* Automated compliance scanning
* EKS reference architectures
* Landing Zone modules

---

## Maintainer

Corey L. Ducre

Platform Engineering | DevOps | Cloud Infrastructure

Xabiere Designs, Inc.

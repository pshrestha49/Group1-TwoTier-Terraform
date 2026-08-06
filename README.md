# Two-Tier Web Application Automation with Terraform

Welcome to the **Group 1** Two-Tier AWS Infrastructure project! This repository contains the complete Terraform code to automate the provisioning of a highly available, secure, two-tier web application architecture on AWS.

![Architecture Diagram](architecture.png)
*(Note: Replace `architecture.png` with the actual exported diagram)*

## 📖 Project Overview

This project builds a robust AWS architecture featuring:
- **Public Tier:** An Application Load Balancer (ALB), NAT Gateway, and a Bastion Host.
- **Private Tier:** Auto Scaling Group of Amazon Linux 2 Web Servers running Apache.
- **Security:** Strict Security Group rules enforcing least privilege (e.g., Web servers only accept HTTP traffic from the ALB and SSH traffic from the Bastion host).
- **Storage:** A private S3 bucket to store website images, securely accessed by EC2 instances via an IAM Instance Profile.

## 🏗️ Repository Structure

The code is strictly modularized to promote reusability across multiple environments (`dev`, `staging`, `prod`).

```
Group1-TwoTier-Terraform/
├── environments/
│   ├── dev/               # Dev variables & S3 backend config
│   ├── staging/           # Staging variables & S3 backend config
│   └── prod/              # Prod variables & S3 backend config
├── modules/
│   ├── alb/               # Application Load Balancer, Target Group, Listener
│   ├── asg/               # Auto Scaling Group & CloudWatch Policies
│   ├── launch_template/   # EC2 Launch Template & IAM Profile attachment
│   ├── networking/        # VPC, Subnets, IGW, NAT, Route Tables
│   └── security_groups/   # Security Groups for ALB, Bastion, Web
└── scripts/
    └── userdata.sh        # Bash script to install Apache and fetch S3 image
```

## ⚙️ Prerequisites

To deploy this architecture, you will need:
1. **Terraform** installed (v1.0+)
2. **AWS CLI** installed and configured (`aws configure`)
3. Proper IAM permissions in your AWS account.

## 🚀 Deployment Instructions

Because we are using S3 for remote state, the deployment process for any environment (e.g., `dev`) is as follows:

1. **Navigate to the environment directory:**
   ```bash
   cd environments/dev
   ```
2. **Initialize Terraform:**
   *(Downloads providers and configures the S3 backend)*
   ```bash
   terraform init
   ```
3. **Plan the Deployment:**
   *(Review the infrastructure changes)*
   ```bash
   terraform plan
   ```
4. **Apply the Changes:**
   *(Type `yes` when prompted to deploy)*
   ```bash
   terraform apply
   ```

To deploy to Staging or Prod, simply change the directory to `environments/staging` or `environments/prod` and repeat the steps.

## 🛡️ CI/CD & Security Scanning

This repository uses **GitHub Actions** to enforce code quality and security.
- Pushing to `staging` or opening a PR against `prod` automatically triggers **TFLint** and **Trivy** vulnerability scanners.
- The `prod` branch is protected and requires passing security scans before any code can be merged.
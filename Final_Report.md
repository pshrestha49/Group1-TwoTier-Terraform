# Final Report: Two-Tier Web Application Automation with Terraform

## 1. Division of Labor

This project was successfully executed through a strategic division of labor, leveraging the modular nature of Terraform.

### Person A (Infrastructure & Networking Lead)
Person A was responsible for the foundational infrastructure and continuous integration:
- **Networking Module**: Built the VPC, Public/Private Subnets, Internet Gateway, NAT Gateway, and Route Tables.
- **Security Groups Module**: Implemented strict security groups for the ALB, Bastion Host, and Web Servers.
- **ALB Module**: Configured the Application Load Balancer, Target Group, and Listeners.
- **Environment & CI/CD**: Scaffolded the `dev`, `staging`, and `prod` environments, and integrated GitHub Actions for automated TFLint and Trivy security scanning.

### Person B (Compute & Storage Lead)
Person B was responsible for the compute layer, IAM, and state management:
- **IAM & Storage**: Created the S3 buckets for Terraform Remote State and the private bucket for website images. Built the IAM Role and Instance Profile allowing EC2 to read from S3.
- **Launch Template**: Created the EC2 Launch Template, injecting the User Data script to install Apache and securely fetch the image from S3.
- **Auto Scaling Group**: Configured the ASG with CloudWatch alarms to scale out on high CPU and scale in on low CPU.

---

## 2. Traffic Flow Explanations

The architecture handles three distinct traffic flows, prioritizing security and high availability.

### 🟣 Purple/Red Flow — User Web Traffic
- **Lifecycle stage:** Runtime — normal application operation
- **How it's triggered:** End users type the ALB DNS URL into their web browser.
- **Explanation:** Traffic enters the AWS environment through the **Internet Gateway** and hits the **Application Load Balancer (ALB)** located in the public subnets. The ALB distributes these requests across healthy **web servers located in the private subnets** via the Target Group. The web servers themselves are never directly exposed to the internet, providing a crucial layer of security.

### ⬜ Grey Flow — Admin SSH Traffic
- **Lifecycle stage:** Maintenance / debugging
- **How it's triggered:** An administrator uses SSH to connect to the Bastion host, then hops to the web servers.
- **Explanation:** Because the web servers are in private subnets, they cannot be reached directly from the internet. Admins must first SSH into the **Bastion host** (located in a public subnet). From the Bastion host, they can SSH into the target web server. Our Web Security Group explicitly only allows SSH traffic if it originates from the Bastion Security Group.

### 🔵 Blue/Pink Flow — EC2 to S3 Image Retrieval
- **Lifecycle stage:** Instance initialization (boot time)
- **How it's triggered:** The Auto Scaling Group launches a new instance, which triggers the User Data bash script to run.
- **Explanation:** The user data script uses the instance's **IAM Instance Profile** to securely download website images from the **private S3 bucket**. Because the instance is in a private subnet, this outbound traffic flows through the **NAT Gateway** (in the public subnet) to reach the AWS S3 API. The S3 bucket remains entirely private and is never exposed to the public internet.

---

## 3. High Availability & Security Achievements

- **High Availability**: By spanning public and private subnets across three Availability Zones (`us-east-1b`, `us-east-1c`, `us-east-1d`), the application can survive the failure of an entire AWS data center. The Auto Scaling Group ensures that if an instance becomes unhealthy or CPU load spikes, new instances are automatically provisioned.
- **Security**: The Two-Tier architecture strictly enforces a boundary. Only the ALB and Bastion host touch the public internet. The Web Servers are hidden in private subnets. Furthermore, the GitHub repository strictly enforces code quality through branch protection rules and automated security scanning using Trivy.

---

## 4. Challenges & Solutions

*(Note: Replace this section with any real-world challenges your group faced during the project. Examples provided below.)*

- **Challenge**: Passing outputs between disparate modules developed by two different people.
  - **Solution**: We strictly defined our `outputs.tf` and `variables.tf` contracts before writing the main logic. This allowed Person A to output `private_subnet_ids` and Person B to seamlessly inject them into the `asg` module.
- **Challenge**: User data script failing to download the image from S3.
  - **Solution**: We realized the EC2 instances in private subnets needed a NAT Gateway to route out to the AWS API, and they needed a properly attached IAM Instance Profile with `s3:GetObject` permissions. Once both were verified, the script executed flawlessly on boot.

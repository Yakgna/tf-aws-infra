# Terraform AWS Infrastructure

This repository contains Terraform configuration files to manage and provision infrastructure on AWS using Infrastructure as Code (IaC). The setup includes networking, compute, security, and auto-scaling resources, ensuring a scalable and resilient environment.

## Infrastructure Components

### **Networking**
- **Virtual Private Cloud (VPC)**: Creates an isolated network for AWS resources.
- **Subnets**: Three public and three private subnets distributed across multiple Availability Zones for high availability.
- **Internet Gateway (IGW)**: Enables internet access for public subnets.
- **Route Tables**: Configures proper routing between public and private subnets.

### **Compute & Load Balancing**
- **EC2 Instances**: Launches instances with a predefined Amazon Machine Image (AMI), security groups, and IAM roles.
- **Auto Scaling Group (ASG)**: Automatically scales EC2 instances based on demand.
- **Application Load Balancer (ALB)**: Distributes incoming traffic to EC2 instances in the ASG.
- **Target Group**: Connects the Auto Scaling Group to the Load Balancer.

### **Security**
- **Security Groups**: Implements firewall rules for EC2 instances and ALB.
- **IAM Roles and Policies**: Grants necessary permissions to EC2 instances and other AWS resources.

## Terraform Setup

### **Prerequisites**
- Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) (v1.9.0+ recommended)
- Install and configure [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Configure AWS credentials (`~/.aws/credentials`)
- Ensure you have necessary permissions to create AWS resources

### **Deployment Steps**
1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-repo/tf-aws-infra.git
   cd tf-aws-infra/src/terraform
   ```
2. **Initialize Terraform:**
   ```bash
   terraform init
   ```
3. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```
4. **Apply the changes:**
   ```bash
   terraform apply -auto-approve
   ```
5. **Destroy resources (if needed):**
   ```bash
   terraform destroy -auto-approve
   ```

## GitHub Actions CI/CD

This repository includes a GitHub Actions workflow (`.github/workflows/terraform.yml`) to automate Terraform validation and deployment.

### **Workflow Overview**
The workflow runs automatically on pull requests (PRs) to the `main` branch. The process includes:
1. **Checking out the repository**
2. **Setting up Terraform**
3. **Initializing Terraform**
4. **Validating Terraform configuration**

#### **Trigger Events**
- When a PR is created or updated
- When changes are pushed to the `main` branch

#### **Workflow Steps**
```yaml
jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
      
      - name: Terraform Init
        run: terraform init
      
      - name: Terraform Validate
        run: terraform validate
```

## **Terraform Variables**
This project uses variables stored in `terraform.tfvars`.

### **Example `terraform.tfvars` File**
```hcl
profile    = "default"
region     = "us-east-1"
instance_type = "t3.micro"
ami_id     = "ami-12345678"
```

## **Outputs**
After Terraform applies, it provides key resource details such as:
- **Load Balancer DNS Name**: To access the ALB endpoint
- **Auto Scaling Group ID**: To monitor scaling activities
- **EC2 Instance Information**: Instance IDs and public/private IPs

```hcl
output "alb_dns" {
  value = aws_lb.main.dns_name
}
```

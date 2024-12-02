variable "profile" {
  description = "The profile to use for VPC"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "demo"], var.profile)
    error_message = "Environment must be either 'dev' or 'demo'."
  }
}

variable "project_name" {
  description = "The project name to use as a prefix for resource names"
  type        = string
  default     = "csye6225"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Value of the Name tag for the VPC"
  type        = string
  default     = "vpc"
}

variable "region" {
  description = "Value of the Name tag for the VPC"
  type        = string
  default     = "us-east-1"
}

variable "ingress_cidr_22" {
  description = "Value for Ingress CIDR Blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidr_80" {
  description = "Value for Ingress CIDR Blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidr_443" {
  description = "Value for Ingress CIDR Blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_cidr_8080" {
  description = "Value for Ingress CIDR Blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ami_id" {
  description = "Custom AMI id"
  type        = string
}

# Public subnet CIDR blocks
variable "public_cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# Private subnet CIDR blocks
variable "private_cidr_blocks" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "db_username" {
  description = "Username for postgres"
  type        = string
  default     = "csye6225"
}

variable "db_password" {
  description = "Password for postgres"
  type        = string
  default     = "Clouddb2024"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "csye6225"
}

variable "port" {
  description = "Server port"
  type        = string
  default     = "8080"
}

variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the application"
  default     = "clouddyve.me"
}

variable "zone_id" {
  type        = string
  description = "Main domain hosted zone id"
  default     = "Z02896342H5CE500OOH6V"
}

variable "aws_key_name" {
  type        = string
  description = "Domain name for the application"
  default     = "my_windows_laptop"
}

variable "app_port" {
  description = "Application port"
  default     = 8080
}

variable "send_grid_api_key" {
  description = "SendGrid API key"
}

variable "ssl_certificate" {
  description = "SSL certificate arn"
}


output "rds_address" {
  description = "RDS instance address"
  value       = aws_db_instance.csye6225_rds.address
}

output "s3_bucket_name" {
  description = "S3 Bucket Name"
  value       = aws_s3_bucket.csye6225_bucket.bucket
}

output "db_password_secret" {
  description = "DB Password Secret ID"
  value       = aws_secretsmanager_secret.db_password_secret.id
}
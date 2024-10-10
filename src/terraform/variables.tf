variable "profile" {
  description = "The profile to use for VPC"
  type        = string
  default     = "dev"
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
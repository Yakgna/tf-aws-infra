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

variable "cidr_pub_a" {
  description = "Cidr for public subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "cidr_pub_b" {
  description = "Cidr for public subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "cidr_pub_c" {
  description = "Cidr for public subnet C"
  type        = string
  default     = "10.0.3.0/24"
}

variable "cidr_priv_a" {
  description = "Cidr for private subnet A"
  type        = string
  default     = "10.0.4.0/24"
}

variable "cidr_priv_b" {
  description = "Cidr for private subnet B"
  type        = string
  default     = "10.0.5.0/24"
}

variable "cidr_priv_c" {
  description = "Cidr for private subnet C"
  type        = string
  default     = "10.0.6.0/24"
}
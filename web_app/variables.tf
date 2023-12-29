variable "aws_region" {
  type        = string
  description = "AWS regions to deploy to"
  default     = "us-east-1"

}


variable "vpc_public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Public Subnet in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}


variable "route_table_cidr_block" {
  type        = string
  description = "CIDR Block for route table"
  default     = "0.0.0.0/0"
}


variable "vpc_app_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public IP address for Subnet instances"
  default     = true

}

variable "instance_type" {
  type        = string
  description = "Type for EC2 Instnace"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "The name of the company"
  default     = "Globomantics"
}

variable "project" {
  type        = string
  description = "The name of the project"
}

variable "billing_code" {
  type        = string
  description = "Billing code for the project"

}



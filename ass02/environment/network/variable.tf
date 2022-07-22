# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Verge",
    "App"   = "Bastion and Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Deployed Env"
  description = "Name prefix"
}

#Define Availability Zones Variables for all Environment
variable "az" {
  description = "AZs to use in US East Region"
  default     = ["us-east-1b", "us-east-1c"]
  type        = list(string)
}


# Defined private subnets in custom VPC NonProd
variable "private_sn_cidrs" {
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

variable "public_sn_cidrs" {
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}

# Defined VPC CIDR range NonProd
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC to host Bastion and Static Web Site"
}


# Defined Variable to signal the current environment 
variable "env" {
  default     = "nonprod"
  type        = string
  description = "Deployment Environment"
}

# VPC CIDR range
variable "vpc_cidr1" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC to Host Server SSH only"
}

# Variable to signal the current environment 
variable "env1" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}

#Define Private Subnet passed by environment
variable "private_sn_cidrs1" {
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}
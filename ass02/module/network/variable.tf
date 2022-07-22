# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "Deployed Env"
  type        = string
  description = "Name prefix"
}

#Define Availability Zones Variables for all Environment
variable "az" {

}

# Defined public subnets in custom VPC
variable "public_sn_cidrs" {

}

#Define Private Subnet passed by environment
variable "private_sn_cidrs" {

}

# Defined VPC CIDR range NonProd
variable "vpc_cidr" {

}

# Defined Variable to signal the current environment 
variable "env" {
  default     = "nonprod"
  type        = string
  description = "Deployment Environment"
}

# Defined Variable to signal the current environment 
variable "env1" {
  default     = "prod"
  type        = string
  description = "Deployment Environment"
}
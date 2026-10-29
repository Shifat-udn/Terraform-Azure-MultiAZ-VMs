variable "DEFAULT_LOCATION" {
  description = "The default location for resources"
  type        = string
}
variable "RG" {
  description = "The name of the resource group"
  type        = string
}
variable "VNET_NAME" {
  description = "The name of the virtual network"
  default     = "tf-vnet"
  type        = string
}
variable "VNET_CIDR" {
  description = "The CIDR block for the virtual network"
  default     = "10.220.0.0/16"
  type        = string
}
variable "SUBNET_1_CIDR" {
  description = "The CIDR block for the public subnet 1"
  default     = "10.220.1.0/24"
  type        = string
}
variable "SUBNET_1_NAME" {
  description = "The name of subnet 1"
  default     = "subnet-az1"
  type        = string
}
variable "SUBNET_2_CIDR" {
  description = "The CIDR block for the public subnet 2"
  default     = "10.220.2.0/24"
  type        = string
}
variable "SUBNET_2_NAME" {
  description = "The name of subnet 2"
  default     = "subnet-az2"
  type        = string
}

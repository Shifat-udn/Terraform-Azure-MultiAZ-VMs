variable "default_location" {
  type    = string
  default = "East US"
  #canadacentral
}
# VPC and Subnet Variables
variable "vnet_name" {
  type    = string
  default = "vpc-demo"
}
variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "subnet_1_name" {
  type    = string
  default = "subnet-az1"
}
variable "subnet_2_name" {
  type    = string
  default = "subnet-az2"
}
variable "subnet_1_cidr" {
  type    = string
  default = "10.0.1.0/24"
}
variable "subnet_2_cidr" {
  type    = string
  default = "10.0.2.0/24"
}




variable "office_IP_CIDR" {
  type    = string
  default = "1.2.3.4/32"
}

# VM Variables
variable "vm_password" {
  type    = string
  default = "lCa8lzGpdHCfKL0h9zpl@"
}
variable "vm_size" {
  type    = string
  default = "Standard_D2als_v6"
}

#load balancer variables
variable "lb_name" {
  type    = string
  default = "nginx-lb"
}
variable "lb_vm_size" {
  type    = string
  default = "Standard_D2als_v6"
}

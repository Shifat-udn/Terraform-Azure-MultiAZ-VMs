variable "DEFAULT_LOCATION" {
  description = "The default location for resources"
  type        = string
}
variable "RG_NAME" {
  description = "The name of the resource group"
  type        = string
}
variable "SUBNET_ID" {
  description = "The ID of the subnet"
  type        = string
}
variable "VM_NAME" {
  description = "The name of the virtual machine"
  type        = string
  default     = "vm1"
}
variable "VM_SIZE" {
  description = "The size of the virtual machine"
  type        = string
  default     = "Standard_DS1_v2"
}
variable "VM_PASSWORD" {
  description = "The password for the virtual machine"
  type        = string
  default = "lCa8lzGpdHCfKL0h9zpl@"
}
variable "VM_ZONE" {
  description = "The availability zone for the virtual machine"
  type        = string
  default     = "1"
}
# 1. Resource Group
resource "azurerm_resource_group" "terraform-project-rg" {
  name     = "terraform-project"
  location = var.default_location
}
# 2. Virtual Network and Subnets
module "vnet" {
  source = "./modules/VNET"
  DEFAULT_LOCATION = var.default_location
  RG               = azurerm_resource_group.terraform-project-rg.name
  VNET_NAME        = var.vnet_name
  VNET_CIDR        = var.vnet_cidr
  SUBNET_1_NAME    = var.subnet_1_name
  SUBNET_2_NAME    = var.subnet_2_name
  SUBNET_1_CIDR    = var.subnet_1_cidr
  SUBNET_2_CIDR    = var.subnet_2_cidr
}

# 5. Network Security Group (NSG)
resource "azurerm_network_security_group" "nsg-tf-dr" {
  name                = "nsg-tf-dr"
  location            = var.default_location
  resource_group_name = azurerm_resource_group.terraform-project-rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.office_IP_CIDR
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.office_IP_CIDR
    destination_address_prefix = "*"
  }
}
# Associate NSG with Subnets
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_1" {
  subnet_id = module.vnet.subnet_1_id    
  network_security_group_id = azurerm_network_security_group.nsg-tf-dr.id
    depends_on = [
    azurerm_network_security_group.nsg-tf-dr
  ]
}
resource "azurerm_subnet_network_security_group_association" "nsg_assoc_2" {
  subnet_id = module.vnet.subnet_2_id
  network_security_group_id = azurerm_network_security_group.nsg-tf-dr.id
  depends_on = [
    azurerm_network_security_group.nsg-tf-dr
  ]
}

resource "random_password" "vm_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}:?" # Avoids symbols that can break Azure CLI/scripts
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

#=======================
# VM1
#=======================
module "vm1" {
  source = "./modules/VM"
  VM_NAME = "vm1-ubuntu-apache"
  VM_SIZE = var.vm_size
  VM_PASSWORD = random_password.vm_password.result
  SUBNET_ID = module.vnet.subnet_1_id
  RG_NAME = azurerm_resource_group.terraform-project-rg.name
  DEFAULT_LOCATION = var.default_location
  VM_ZONE = "1"
}


#=======================
# VM2
#=======================
module "vm2" {
  source = "./modules/VM"
  VM_NAME = "vm2-ubuntu-apache"
  VM_SIZE = var.vm_size
  VM_PASSWORD = random_password.vm_password.result
  SUBNET_ID = module.vnet.subnet_2_id
  RG_NAME = azurerm_resource_group.terraform-project-rg.name
  DEFAULT_LOCATION = var.default_location
  VM_ZONE = "2"
}


# ==========================================
# NEW: NGINX LOAD BALANCER INFRASTRUCTURE
# ==========================================
module "nginx_lb" {
  source = "./modules/NGINX-LB"
  LB_NAME = var.lb_name
  DEFAULT_LOCATION = var.default_location
  SUBNET_ID = module.vnet.subnet_1_id
  RG_NAME = azurerm_resource_group.terraform-project-rg.name
  VM_SIZE = var.lb_vm_size
  VM_PASSWORD = random_password.vm_password.result
  VM_1_PVT_IP = module.vm1.private_ip_address
  VM_2_PVT_IP = module.vm2.private_ip_address
  depends_on = [
    module.vm1,
    module.vm2
  ]
}


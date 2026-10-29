resource "azurerm_virtual_network" "vnet" {
  name                = var.VNET_NAME
  address_space       = [var.VNET_CIDR]
  location            = var.DEFAULT_LOCATION
  resource_group_name = var.RG
}
# Subnet 1 (AZ 1 implied/associated via workload)
resource "azurerm_subnet" "subnet_1" {
  name                 = "subnet-az1"
  resource_group_name  = var.RG
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.SUBNET_1_CIDR]
}

#  Subnet 2 (AZ 2)
resource "azurerm_subnet" "subnet_2" {
  name                 = "subnet-az2"
  resource_group_name  = var.RG
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.SUBNET_2_CIDR]
}


# Route Table
resource "azurerm_route_table" "main-rt" {
  name                = "${var.VNET_NAME}-rt"
  location            = var.DEFAULT_LOCATION
  resource_group_name = var.RG

  route {
    name           = "default-route"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}
# Associate Route Table with Subnet
resource "azurerm_subnet_route_table_association" "rta" {
  subnet_id      = azurerm_subnet.subnet_1.id
  route_table_id = azurerm_route_table.main-rt.id
}
resource "azurerm_subnet_route_table_association" "rta2" {
  subnet_id      = azurerm_subnet.subnet_2.id
  route_table_id = azurerm_route_table.main-rt.id
}

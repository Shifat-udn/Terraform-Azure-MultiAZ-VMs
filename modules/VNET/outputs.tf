output "subnet_1_id" {
  value = azurerm_subnet.subnet_1.id
}
output "subnet_2_id" {
  value = azurerm_subnet.subnet_2.id
}
output "subnet_1_name" {
  value = azurerm_subnet.subnet_1.name
}

output "subnet_2_name" {
  value = azurerm_subnet.subnet_2.name
}
output "subnet_1_cidr" {
  value = azurerm_subnet.subnet_1.address_prefixes[0]
}

output "subnet_2_cidr" {
  value = azurerm_subnet.subnet_2.address_prefixes[0]
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}
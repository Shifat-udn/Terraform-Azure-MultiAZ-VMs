
# 7. Network Interface Card (NIC)
resource "azurerm_network_interface" "vm1-nic" {
  name                = "${var.VM_NAME}-nic"
  location            = var.DEFAULT_LOCATION
  resource_group_name = var.RG_NAME

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.SUBNET_ID
    private_ip_address_allocation = "Dynamic"
  }
}
 
 # 8. Ubuntu Virtual Machine with password authentication and cloud-init
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.VM_NAME
  resource_group_name              = var.RG_NAME
  location                         = var.DEFAULT_LOCATION
  size                            = var.VM_SIZE
  zone                             = var.VM_ZONE
  admin_username                  = "azureuser"
  
  # Set your preset password here (Must meet Azure complexity requirements)
  admin_password                  = var.VM_PASSWORD
  
  # Crucial: Must be set to false to allow SSH password login
  disable_password_authentication = false 

  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }


  # cloud-init script inline configuration to install apache
custom_data = base64encode(<<-EOF
            #cloud-config
            package_update: true
            package_upgrade: true
            packages:
                - apache2

            write_files:
                - path: /var/www/html/index.html
                  owner: root:root
                  permissions: '0644'
                  content: |
                    ${indent(10,file("${path.module}/index.html"))}

            runcmd:
                - systemctl start apache2
                - systemctl enable apache2
                - sed -i "s|__VM_HOSTNAME__|$(hostname)|g" /var/www/html/index.html
                - sed -i "s|__VM_IP__|$(hostname -I | cut -d' ' -f1)|g" /var/www/html/index.html
            EOF
)

}
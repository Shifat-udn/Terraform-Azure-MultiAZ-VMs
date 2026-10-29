# Public IP so clients can access the Nginx Load Balancer
resource "azurerm_public_ip" "tf_nginx_public_ip" {
  name                = var.LB_NAME
  location            = var.DEFAULT_LOCATION
  resource_group_name = var.RG_NAME
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Network Interface for Nginx Load Balancer
resource "azurerm_network_interface" "nic_nginx" {
  name                = "${var.LB_NAME}-nic"
  location            = var.DEFAULT_LOCATION
  resource_group_name = var.RG_NAME

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.SUBNET_ID
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf_nginx_public_ip.id
  }
}

# New Nginx VM (Using matching Gen2 D2als_v6 hardware)
resource "azurerm_linux_virtual_machine" "vm_nginx" {
  name                  = var.LB_NAME
  resource_group_name   = var.RG_NAME
  location              = var.DEFAULT_LOCATION
  size                  = var.VM_SIZE
  admin_username        = "azureuser"
  admin_password  = var.VM_PASSWORD 
    # Crucial: Must be set to false to allow SSH password login
  disable_password_authentication = false 
  network_interface_ids = [azurerm_network_interface.nic_nginx.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  # Automate Nginx installation and configure reverse proxy routing to Apache
  user_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx

              # Create a reverse proxy configuration targeting the Apache private IP
              cat <<'INNER_EOF' > /etc/nginx/sites-available/default
              upstream backend_apache {
                  server ${var.VM_1_PVT_IP}:80;
                  server ${var.VM_2_PVT_IP}:80;

              }

              server {
                  listen 80 default_server;
                  listen [::]:80 default_server;

                  location / {
                      proxy_pass http://backend_apache;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }
              INNER_EOF

              systemctl restart nginx
              EOF
  )
}
output "nginx_ip" {
  value = azurerm_public_ip.tf_nginx_public_ip.ip_address
}

output "nginx_http_link" {
  value       = "http://${azurerm_public_ip.tf_nginx_public_ip.ip_address}"
  description = "The HTTP link to the Nginx server."
}
output "resource-group" {
  value = azurerm_resource_group.terraform-project-rg.name
}
output "vm_password" {
  value = random_password.vm_password.result
  sensitive = true
}

output "nginx_http_link" {
  value       = module.nginx_lb.nginx_http_link
  description = "The HTTP link to the Nginx server."
}

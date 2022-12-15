#output "webapp_url" {
#  value = "http://${aws_eip.acme.public_dns}"
#}

output "webapp_ip" {
  value = "http://${azurerm_linux_virtual_machine.webdeploy.public_ip_address}"
}

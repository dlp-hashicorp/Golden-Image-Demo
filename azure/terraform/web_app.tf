#
# Azure Web Application
#
data "hcp_packer_iteration" "web" {
  bucket_name = "acme-webapp"
  channel     = "production"
}

data "hcp_packer_image" "webapp_image" {
  bucket_name    = "acme-webapp"
  cloud_provider = "azure"
  iteration_id   = data.hcp_packer_iteration.web.ulid
  region         = var.region
}

resource "azurerm_linux_virtual_machine" "webdeploy" {
  name                            = "web-test"
  location                        = var.region
  resource_group_name             = var.resource_group
  network_interface_ids           = [azurerm_network_interface.acme-interface.id]
  size                            = var.instance_size
  admin_username                  = "adminuser"
  admin_password                  = "f1r3cr@ck3r"
  disable_password_authentication = false
  source_image_id                 = data.hcp_packer_image.webapp_image.cloud_image_id

  os_disk {
    caching                       = "ReadWrite"
    storage_account_type          = "Standard_LRS"
  }
  
}
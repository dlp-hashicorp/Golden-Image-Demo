#---------------------------------------------------------------------------------------
# Packer Plugins
#---------------------------------------------------------------------------------------
packer {
  required_plugins {
    azure = {
      version = ">=1.3.1"
      source = "github.com/hashicorp/azure"
    }
  }
}

#---------------------------------------------------------------------------------------
# Common Image Metadata
#---------------------------------------------------------------------------------------
variable "hcp_base_bucket" {
  default                           = "acme-base"
}

variable "image_name" {
  default                           = "acme-base"
}

variable "version" {
  default                           = "1.0.0"
}

#--------------------------------------------------
# Azure Image Config and Definition
#--------------------------------------------------

variable "azure_region" {
  default                           = "East US"
}

variable "azure_rg" {
  default                           = "acme_builds"
}

variable "instance_size" {           
  default                           = "Standard_DS2_v2"
}

source "azure-arm" "acme-base" {
  azure_tags = {
    dept                            = "Engineering"
    owner                           = "dlp"
  }
  client_id                         = var.clientId
  client_secret                     = var.clientSecret
  subscription_id                   = var.subscriptionId
  tenant_id                         = var.tenantId
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "Canonical"
  image_sku                         = "22_04-lts"
  location                          = var.azure_region
  managed_image_name                = var.image_name
  managed_image_resource_group_name = var.azure_rg
  os_type                           = "Linux"
  vm_size                           = var.instance_size
}

#---------------------------------------------------------------------------------------
# Common Build Definition
#---------------------------------------------------------------------------------------
build {

  hcp_packer_registry {
    bucket_name = var.hcp_base_bucket
    description = <<EOT
This is the base Ubuntu image + Our "Platform" (Apache2)
    EOT
    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu"
      "ubuntu-version" = "20.04-LTS"
      "image-name"     = var.image_name
    }

    build_labels = {
      "build-time"        = timestamp()
      "build-source"      = basename(path.cwd)
      "acme-base-version" = var.version
    }
  }

  sources = [
    "sources.azure-arm.acme-base"
  ]
  
 
#--------------------------------------------------c
# Apache Install
#--------------------------------------------------

provisioner "shell" {
  execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
  inline = [
    "sudo apt-get -y update",
    "sleep 15",
    "sudo apt-get -y update",
    "sudo apt-get -y install apache2",
    "sudo systemctl start apache2",
    "sudo chown 777 /var/www/html",
  ]
  }
}
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
variable "image_name" {
  default = "acme-webapp"
}

variable "version" {
  default = "2.0.0"
}

variable "base_image_name" {
  default = "acme-base"
}

variable "hcp_base_bucket" {
  default = "acme-base"
}

variable "hcp_base_channel" {
  default = "development"
}

variable "hcp_webapp_bucket" {
  default = "acme-webapp"
}

variable "hcp_webapp_channel" {
  default = "development"
}



#--------------------------------------------------
# Azure Image Config and Definition  
#--------------------------------------------------
variable "azure_region" {
  default = "East US"
}

variable "azure_rg" {
  default = "acme_builds"
}

variable "instance_size" {           
  default = "Standard_DS2_v2"
}

data "hcp-packer-image" "azure" {
  cloud_provider = "azure"
  region         = var.azure_region
  bucket_name    = var.hcp_base_bucket
  channel        = var.hcp_base_channel
}

source "azure-arm" "acme-webapp" {
  azure_tags = {
    dept                                    = "Application Team"
    owner                                   = "dlp"
  }
  client_id                                 = var.clientId
  client_secret                             = var.clientSecret
  subscription_id                           = var.subscriptionId
  tenant_id                                 = var.tenantId
  location                                  = var.azure_region
  custom_managed_image_name                 = var.base_image_name
  custom_managed_image_resource_group_name  = var.azure_rg
  managed_image_name                        = var.image_name
  managed_image_resource_group_name         = var.azure_rg
  os_type                                   = "Linux"
  vm_size                                   = var.instance_size
}


#---------------------------------------------------------------------------------------
# Common Build Definition
#---------------------------------------------------------------------------------------
build {
  hcp_packer_registry {
    bucket_name = var.hcp_webapp_bucket
    description = <<EOT
This is the Acme Base + Our "Application" (html)
    EOT
    bucket_labels = {
      "owner"          = "application-team"
      "os"             = "Ubuntu"
      "ubuntu-version" = "16.04LTS"
      "image-name"     = var.image_name
    }

    build_labels = {
      "build-time"        = timestamp()
      "build-source"      = basename(path.cwd)
      "acme-base-version" = data.hcp-packer-image.azure.labels.acme-base-version
      "acme-app-version"  = var.version
    }
  }

    sources = ["sources.azure-arm.acme-webapp"]

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "packer-4-webapp-update/files/deploy-app.sh"
  }

}
variable "prefix" {
  description = "This prefix will be included in the name of most resources."
  default     = "acme-demo"
}

variable "region" {
  description = "The region where the resources are created."
  default     = "East US"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  default     = "10.0.2.0/24"
}

variable "instance_size" {
  description = "Specifies the instance type."
  default     = "Standard_DS2_v2"
}

variable "resource_group" {
  description = "Azure resource group"
  default     = "acme_builds" 
}

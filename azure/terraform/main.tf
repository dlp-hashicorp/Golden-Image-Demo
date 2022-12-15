#
# Required Providers
#
provider "hcp" {}

provider "azurerm" {
  features {}
}

#
# Core Azure Network Configuration
#
resource "azurerm_network_security_group" "acme-sg" {
  name                = "acme-sg"
  location            = var.region
  resource_group_name = var.resource_group
  
  security_rule {
    name                        = "HTTP"
    priority                    = 100
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }

  security_rule {
    name                        = "SSH"
    priority                    = 101
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
  }
}

resource "azurerm_virtual_network" "acme-vnet" {
  name                 = "acme-vnet"
  resource_group_name  = var.resource_group
  location             = var.region
  address_space        = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "acme-subnet" {
  name                 = "internal-subnet1"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.acme-vnet.name
  address_prefixes     = ["10.0.9.0/24"]
  }

resource "azurerm_subnet_network_security_group_association" "subnet_assoc" {
  subnet_id                 = azurerm_subnet.acme-subnet.id
  network_security_group_id = azurerm_network_security_group.acme-sg.id
}

resource "azurerm_public_ip" "acme-pip" {
  name                 = "acme-pip"
  location             = var.region
  resource_group_name  = var.resource_group
  allocation_method    = "Dynamic"
}

resource "azurerm_network_interface" "acme-interface" {
  name                            = "acme-nic"
  location                        = var.region
  resource_group_name             = var.resource_group

  ip_configuration {
    name                          = "acme-internal"
    subnet_id                     = azurerm_subnet.acme-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.acme-pip.id
  }
}

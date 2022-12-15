### BLOCK: variable ###

variable "subscriptionId" {
    type            = string
    description     = "Azure subscription ID"
    sensitive       = true
}

variable "tenantId" {
    type            = string
    description     = "Azure tenant ID"
    sensitive       = true
}

variable "clientId" {
    type            = string
    description     = "Azure service principal client ID"
    sensitive       = true
}

variable "clientSecret" {
    type            = string
    description     = "Azure service principal secret"
    sensitive       = true
}
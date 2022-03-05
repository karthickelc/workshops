# Variables for Azure infrastructure module

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id under which resources will be provisioned"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id used to create resources"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client id used to create resources"
}

variable "azure_client_secret" {
  type        = string
  description = "Client secret used to authenticate with Azure apis"
}

variable "azure_location" {
  type        = string
  description = "Azure location used for all resources"
  default     = "Central India"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "lab"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "rancher-server-ha"
}


variable "tag_resource_owner" {
  type        = string
  description = "Owner for the resource (as tag)"
  default     = "you@email.com"
}

variable "tag_group" {
  type        = string
  description = "Group (as tag)"
  default     = "My Group"
}

variable "tag_department" {
  type        = string
  description = "Department (as tag)"
  default     = "My Department"
}

variable "tag_stakeholder" {
  type        = string
  description = "Stakeholder (as tag)"
  default     = "Manager Name"
}

variable "tag_environment" {
  type        = string
  description = "Stakeholder (as tag)"
  default     = "Test"
}

variable "tag_project" {
  type        = string
  description = "Project (as tag)"
  default     = "Demo"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.5.3"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "v2.6.3"
}

# spec: https://docs.microsoft.com/en-us/azure/virtual-machines/dav4-dasv4-series
# https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
# pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
# $0.1233/hour Central India (4 vCPU AMD, 16GB RAM, 32GB SSD) - Standard_D4as_v4
# $0.179/hour Central India (4 vCPU AMD, 16GB RAM, 32GB SSD) - Standard_B4ms
variable "rke2_node_vm_size" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "Standard_B4ms"
}

# Local variables used to reduce repetition
locals {
  node_username = "azureuser"
}

variable "rke2-cluster-size" {
  type        = number
  description = "Specify number of All In One RKE2 clusters"
  default     = 3
}
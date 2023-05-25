resource "azurerm_resource_group" "RG" {
  name     = var.aks_info.rg_name
  location = var.aks_info.rg_location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_info.aks_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  dns_prefix          = var.aks_info.aks_name

  default_node_pool {
    name                = var.aks_info.node_pool_name
    node_count          = var.aks_info.node_count
    vm_size             = var.aks_info.node_pool_vm_size
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
  }
  identity {
    type = var.aks_info.identity-type
  }
}
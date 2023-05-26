aks_info = {
  rg_name           = "AKS-RG"
  rg_location       = "ukwest"
  aks_name          = "aks-cluster"
  node_pool_name    = "node1"
  node_count        = 2
  node_pool_vm_size = "Standard_D2_v2"
  identity-type     = "SystemAssigned"
}


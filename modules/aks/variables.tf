variable "aks_info" {
  type = object({
    rg_name           = string,
    rg_location       = string,
    aks_name          = string,
    node_pool_name    = string,
    node_count        = number,
    node_pool_vm_size = string,
    identity-type     = string
  })
  default = {
    rg_name           = "AKS-RG"
    rg_location       = "eastus"
    aks_name          = "aks-cluster"
    node_pool_name    = "node1"
    node_count        = 1
    node_pool_vm_size = "Standard_D2_v2"
    identity-type     = "SystemAssigned"
  }
}

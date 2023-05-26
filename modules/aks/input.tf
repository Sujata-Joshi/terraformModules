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
}

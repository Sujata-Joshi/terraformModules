resource "azurerm_public_ip" "public_ip" {
  count               = length(var.vnet_info.vm_name)
  name                = "VM_public_ip-${var.vnet_info.vm_name[count.index]}"
  resource_group_name = azurerm_resource_group.ntierRG.name
  location            = azurerm_resource_group.ntierRG.location
  allocation_method   = "Static"
  sku                 = "Standard"
  sku_tier            = "Regional"
}

resource "azurerm_network_interface" "ntireNIC" {
  count               = length(var.vnet_info.vm_name)
  name                = "ntireNic-${var.vnet_info.vm_name[count.index]}"
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  ip_configuration {
    name                          = var.vnet_info.ip_configuration
    subnet_id                     = azurerm_subnet.subnets[0].id
    private_ip_address_allocation = var.vnet_info.address_allocation
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }
  depends_on = [
    azurerm_subnet.subnets
  ]
}
resource "azurerm_network_security_group" "nsg" {
  name                = "ssh_nsg"
  location            = azurerm_resource_group.ntierRG.location
  resource_group_name = azurerm_resource_group.ntierRG.name

  security_rule {
    name                       = "allow_ssh_sg"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


}
resource "azurerm_network_interface_security_group_association" "association" {
  count                     = length(var.vnet_info.vm_name)
  network_interface_id      = azurerm_network_interface.ntireNIC[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_association" {
  subnet_id                 = azurerm_subnet.subnets[0].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


resource "azurerm_linux_virtual_machine" "main" {
  count                 = length(var.vnet_info.vm_name)
  name                  = var.vnet_info.vm_name[count.index]
  location              = azurerm_resource_group.ntierRG.location
  resource_group_name   = azurerm_resource_group.ntierRG.name
  network_interface_ids = [element(azurerm_network_interface.ntireNIC.*.id, count.index)]
  size                  = var.vnet_info.vm_size
  admin_username        = var.vnet_info.admin_username

  admin_ssh_key {
    username   = var.vnet_info.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }
  os_disk {
    name                 = "myOSdisk-${var.vnet_info.vm_name[count.index]}"
    caching              = var.vnet_info.caching
    storage_account_type = var.vnet_info.storage_account_type
  }
  depends_on = [
    azurerm_network_interface.ntireNIC
  ]

  tags = {
    Env       = "Dev"
    createdBy = "Terraform"
  }
}
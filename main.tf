resource "azurerm_resource_group" "Nessuslab" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "Nessusvm-vnet" {
  name                = "Nessusvm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Nessuslab.location
  resource_group_name = azurerm_resource_group.Nessuslab.name
  lifecycle {
    prevent_destroy = false
  }
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Nessuslab.name
  virtual_network_name = azurerm_virtual_network.Nessusvm-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "Nessuslab-public-ip" {
  name                = "Nessuslab-public-ip"
  location            = azurerm_resource_group.Nessuslab.location
  resource_group_name = azurerm_resource_group.Nessuslab.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "Nessus-nic" {
  name                = "Nessus-nic"
  location            = azurerm_resource_group.Nessuslab.location
  resource_group_name = azurerm_resource_group.Nessuslab.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Nessuslab-public-ip.id
  }
}

resource "azurerm_windows_virtual_machine" "Nessusvm" {
  name                = "Nessusvm"
  resource_group_name = azurerm_resource_group.Nessuslab.name
  location            = azurerm_resource_group.Nessuslab.location
  size                = "Standard_DS1_v2"
  admin_username      = "*******"
  admin_password      = "*******"
  network_interface_ids = [
    azurerm_network_interface.Nessus-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-azure-edition"
  version   = "latest"
  }
}

# 🚀 OpenShift Sandbox on Azure Terraform Module

Welcome to the OpenShift Sandbox on Azure Terraform module! This module helps you to deploy a basic OpenShift environment on Azure using Terraform.

## 🌐 Prerequisites

Before you start, ensure you have the following:

- An Azure subscription
- Terraform installed on your local machine
- SSH key pair (public and private) for SSH access to the VM
- Azure credentials (subscription ID, client ID, client secret, tenant ID)

## 📄 Usage

To use this module, include it in your Terraform configuration:

```hcl
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Create the Resource Group if it doesn't exist
resource "azurerm_resource_group" "openshift" {
  name     = "OpenShiftSandboxAzure"
  location = var.location
}

# Reference the existing Resource Group
data "azurerm_resource_group" "openshift" {
  name = "OpenShiftSandboxAzure"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "openshiftnetwork" {
  name                = "openshift-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.openshift.location
  resource_group_name = data.azurerm_resource_group.openshift.name
}

# Create a Subnet
resource "azurerm_subnet" "openshiftnetwork" {
  name                 = "openshift-subnet"
  resource_group_name  = data.azurerm_resource_group.openshift.name
  virtual_network_name = azurerm_virtual_network.openshiftnetwork.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a Network Interface
resource "azurerm_network_interface" "openshiftnetwork" {
  name                = "openshift-nic"
  location            = data.azurerm_resource_group.openshift.location
  resource_group_name = data.azurerm_resource_group.openshift.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.openshiftnetwork.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a Virtual Machine
resource "azurerm_linux_virtual_machine" "openshift" {
  name                = "OpenShiftSandbox"
  location            = data.azurerm_resource_group.openshift.location
  resource_group_name = data.azurerm_resource_group.openshift.name
  network_interface_ids = [azurerm_network_interface.openshiftnetwork.id]
  size                = "Standard_DS1_v2"
  
  # Admin username and SSH key
  admin_username      = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # Set up the OS disk
  os_disk {
    name              = "openshift-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Use the latest Ubuntu 24.04 LTS image
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "24_04-lts-gen2"
    version   = "latest"
  }

  disable_password_authentication = false
  admin_password                  = var.admin_password
}

# Output the private IP address of the VM (optional)
output "private_ip" {
  value = azurerm_network_interface.openshiftnetwork.private_ip_address
}
```

## 🛠️ Variables

Here are the variables you need to set:

- `subscription_id`: Your Azure subscription ID
- `client_id`: Azure Service Principal client ID
- `client_secret`: Azure Service Principal client secret
- `tenant_id`: Azure tenant ID
- `location`: Azure region (e.g., `East US`)
- `admin_username`: Admin username for the VM
- `ssh_public_key`: Your SSH public key
- `admin_password`: Admin password for the VM (only if password authentication is enabled)

## 📤 Outputs

- `private_ip`: The private IP address of the VM

## 🚀 Deployment

To deploy the OpenShift Sandbox on Azure:

1. Clone this repository to your local machine.
2. Configure the required variables.
3. Run the following commands:

```bash
terraform init
terraform apply
```

4. Confirm the plan and Terraform will deploy the resources.

## ⚠️ Important Notes

- Make sure your Azure credentials are correct and have the necessary permissions.
- Always check the cost associated with the resources created by this module.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Happy Terraforming! 🌍🚀
resource "azurerm_resource_group" "rg" {
  name     = "dev-env"
  location = "westeurope"
}

resource "azurerm_container_group" "aci" {
  name                = "pfshell"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  os_type = "Linux"

  container {
    name   = "pfshell"
    image  = "pirafrank/workspace:bundle"

    cpu    = 1.0
    memory = 2.0

    ports {
      port     = 2222
      protocol = "TCP"
    }

    environment_variables = {
      SSH_SERVER     = "true"
      SSH_PUBKEYS    = var.ssh_keys
      GITUSERNAME    = var.git_user_name
      GITUSEREMAIL   = var.git_user_email
    }
  }

  dns_name_label = "pfshell"
}

output "container_ipv4_address" {
  value = azurerm_container_group.aci.ip_address
}


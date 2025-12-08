resource "azurerm_container_registry" "ps-acr" {
  name = "petstoreacr2025"
  resource_group_name = azurerm_resource_group.petstore-rg.name
  location = azurerm_resource_group.petstore-rg.location
  sku = "Basic"
  admin_enabled = true
}
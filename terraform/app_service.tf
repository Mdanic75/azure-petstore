resource "azurerm_service_plan" "petstore-app-service-plan" {
  name                = "petstore-app-service-plan"
  location            = azurerm_resource_group.petstore-rg.location
  resource_group_name = azurerm_resource_group.petstore-rg.name
  sku_name            = "B1"
  os_type = "Linux"
}

resource "azurerm_linux_web_app" "ps-app" {
  name = "petstore-web-app"
  location = azurerm_resource_group.petstore-rg.location
  resource_group_name = azurerm_resource_group.petstore-rg.name
  service_plan_id = azurerm_service_plan.petstore-app-service-plan.id

  site_config {
  }
}
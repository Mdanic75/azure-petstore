resource "azuread_application" "github-cicd" {
  display_name = "github-cicd-test"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_federated_identity_credential" "github_main" {
  application_id = azuread_application.github-cicd.id
  display_name   = "github-main-branch"
  description    = "Github Actions for main branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_repo}:ref:refs/heads/main"
}

resource "azuread_service_principal" "github-cicd" {
  client_id                    = azuread_application.github-cicd.client_id
  app_role_assignment_required = false
  use_existing                 = true
  owners                       = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
    gallery    = true
  }

  timeouts {
    read   = "300s"
    create = "600s"
  }
}

resource "azurerm_role_assignment" "acr-push" {
  scope                = azurerm_container_registry.ps-acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.github-cicd.object_id
  principal_type = "ServicePrincipal"
}

locals {
  repo_vars = {
    AZURE_CLIENT_ID       = azuread_application.github-cicd.client_id
    AZURE_TENANT_ID       = data.azurerm_client_config.current.tenant_id
    AZURE_SUBSCRIPTION_ID = data.azurerm_client_config.current.subscription_id
    ACR_LOGIN_SERVER      = azurerm_container_registry.ps-acr.login_server
    
  }
}

resource "github_actions_variable" "azure_vars" {
  for_each     = local.repo_vars
  repository   = data.github_repository.petstore-repo.name
  variable_name = each.key
  value        = each.value
}

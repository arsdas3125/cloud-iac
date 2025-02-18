
resource "azuread_application" "keyv_usr" {
  display_name = var.azure_service_principal_display_name
}

resource "azuread_service_principal" "keyv_usr" {
  application_id = azuread_application.keyv_usr.application_id
}

resource "time_rotating" "month" {
  rotation_days = 30
}

resource "azuread_service_principal_password" "keyv_usr" {
  service_principal_id = azuread_service_principal.keyv_usr.object_id
  rotate_when_changed  = { rotation = time_rotating.month.id }
}

output "azure_client_id" {
  description = "The Azure AD service principal's application (client) ID."
  value       = azuread_application.keyv_usr.application_id
}

output "azure_client_secret" {
  description = "The Azure AD service principal's client secret value."
  value       = azuread_service_principal_password.keyv_usr.value
  sensitive   = true
}
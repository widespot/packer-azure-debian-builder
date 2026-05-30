output "resource_group_name" {
  value       = azurerm_resource_group.images.name
  description = "Resource group name for Packer output and gallery."
}

output "location" {
  value       = azurerm_resource_group.images.location
  description = "Azure location."
}

output "managed_image_name" {
  value       = var.managed_image_name
  description = "Managed image name expected from Packer."
}

output "gallery_name" {
  value       = azurerm_shared_image_gallery.public.name
  description = "Azure Compute Gallery name."
}

output "gallery_image_name" {
  value       = azurerm_shared_image.runner.name
  description = "Gallery image definition name."
}

output "gallery_image_definition_id" {
  value       = azurerm_shared_image.runner.id
  description = "Gallery image definition resource ID."
}

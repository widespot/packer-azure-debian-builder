variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group used for managed image and gallery."
}

variable "location" {
  type        = string
  description = "Azure region."
  default     = "westeurope"
}

variable "managed_image_name" {
  type        = string
  description = "Managed image name created by Packer."
  default     = "azdo-debian-runner"
}

variable "gallery_name" {
  type        = string
  description = "Azure Compute Gallery name."
  default     = "azdodebianpublicgallery"
}

variable "gallery_image_name" {
  type        = string
  description = "Gallery image definition name."
  default     = "azdo-debian-runner"
}

variable "community_gallery_public_name_prefix" {
  type        = string
  description = "Prefix for the generated Community Gallery public name."
}

variable "community_gallery_publisher_email" {
  type        = string
  description = "Publisher email required by Community Gallery."
}

variable "community_gallery_publisher_uri" {
  type        = string
  description = "Publisher URI required by Community Gallery."
}

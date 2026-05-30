resource "azurerm_resource_group" "images" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_shared_image_gallery" "public" {
  name                = var.gallery_name
  location            = azurerm_resource_group.images.location
  resource_group_name = azurerm_resource_group.images.name
  description         = "Public gallery for Debian runner images."

  sharing {
    permission = "Community"

    community_gallery {
      eula            = "Use at your own risk."
      prefix          = var.community_gallery_public_name_prefix
      publisher_email = var.community_gallery_publisher_email
      publisher_uri   = var.community_gallery_publisher_uri
    }
  }
}

resource "azurerm_shared_image" "runner" {
  name                = var.gallery_image_name
  gallery_name        = azurerm_shared_image_gallery.public.name
  resource_group_name = azurerm_resource_group.images.name
  location            = azurerm_resource_group.images.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"
  architecture        = "x64"

  identifier {
    publisher = "widespot"
    offer     = "azdo-debian-runner"
    sku       = "debian12"
  }
}

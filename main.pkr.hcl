source "azure-arm" "debian" {
  subscription_id    = var.subscription_id
  use_azure_cli_auth = true

  managed_image_name                = var.vm_image_name
  managed_image_resource_group_name = var.resource_group_name
  location                          = var.resource_group_location

  os_type         = "Linux"
  image_publisher = "Debian"
  image_offer     = "debian-12"
  image_sku       = "12-gen2"

  vm_size = var.vm_size

  azure_tags = {
    workload   = "azdo-runner"
    managed_by = "packer"
  }
}

build {
  name = "azdo-debian-runner"
  sources = ["source.azure-arm.debian"]

  provisioner "shell" {
    environment_vars = [
      "PACKAGES=${join(" ", var.packages)}",
      "DEBIAN_FRONTEND=noninteractive",
    ]
    script = "${path.root}/scripts/install-packages.sh"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
    ]
    scripts = [
      "${path.root}/scripts/install-docker.sh",
      "${path.root}/scripts/install-packer.sh",
      "${path.root}/scripts/install-qemu.sh",
      "${path.root}/scripts/install-azcli.sh",
      "${path.root}/scripts/install-virtualbox.sh",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}

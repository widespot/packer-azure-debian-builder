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

locals {
  azcli_packages = [
    "apt-transport-https",
    "ca-certificates",
    "curl",
    "gnupg",
    "lsb-release",
#    "azure-cli",
  ]

  docker_packages = [
    "ca-certificates",
    "curl",
    "gnupg",
#    "docker-ce",
#    "docker-ce-cli",
#    "containerd.io",
#    "docker-buildx-plugin",
#    "docker-compose-plugin",
  ]

  packer_packages = []

  pyenv_packages = [
    "build-essential",
    "curl",
    "ca-certificates",
    "libssl-dev",
    "zlib1g-dev",
    "libbz2-dev",
    "libreadline-dev",
    "libsqlite3-dev",
    "libffi-dev",
    "liblzma-dev",
    "xz-utils",
  ]

  qemu_packages = [
    "ovmf",
    "qemu-kvm",
    "qemu-utils",
  ]

  virtualbox_packages = [
    "fasttrack-archive-keyring",
    "linux-headers-cloud-amd64",
#    "virtualbox-dkms",
#    "virtualbox",
  ]

  enabled_feature_packages = distinct(concat(
    var.enable_azcli ? local.azcli_packages : [],
    var.enable_docker ? local.docker_packages : [],
    var.enable_packer ? local.packer_packages : [],
    var.enable_pyenv ? local.pyenv_packages : [],
    var.enable_qemu ? local.qemu_packages : [],
    var.enable_virtualbox ? local.virtualbox_packages : [],
  ))

  install_packages = distinct(concat(var.packages, local.enabled_feature_packages))

  features = [
    {
      enabled   = true
      script    = "${path.root}/scripts/utils-fix-locale.sh"
      template  = null
    },
    {
      enabled   = true
      script    = "${path.root}/scripts/utils-azdo-sudo.sh"
      template  = null
    },
    {
      enabled   = var.enable_azcli
      script    = "${path.root}/scripts/install-azcli.sh"
      template  = null
    },
    {
      enabled   = var.enable_docker
      script    = "${path.root}/scripts/install-docker.sh"
      template  = null
    },
    {
      enabled   = var.enable_packer
      script    = "${path.root}/scripts/install-packer.sh"
      template  = null
    },
    {
      enabled   = var.enable_pyenv
      script    = "${path.root}/scripts/install-pyenv.sh"
      template  = {
        python_version = var.pyenv_python_version
      }
    },
    {
      enabled   = var.enable_qemu
      script    = "${path.root}/scripts/install-qemu.sh"
      template  = null
    },
    {
      enabled   = var.enable_virtualbox
      script    = "${path.root}/scripts/install-virtualbox.sh"
      template  = null
    },
  ]
}

build {
  name = "azdo-debian-runner"
  sources = ["source.azure-arm.debian"]

  provisioner "shell" {
    environment_vars = [
      "PACKAGES=${join(" ", local.install_packages)}",
      "DEBIAN_FRONTEND=noninteractive",
    ]
    script = "${path.root}/scripts/install-packages.sh"
  }

  dynamic "provisioner" {
    for_each = {for feature in local.features:
      feature.script => feature.template == null ?
        file(feature.script) : templatefile(feature.script, feature.template)
      if feature.enabled
    }

    labels = ["file"]

    content {
      content = provisioner.value
      destination = "/tmp/${basename(provisioner.key)}"
    }
  }

  dynamic "provisioner" {
    for_each = local.features

    labels = ["shell"]

    content {
      inline = [
        "chmod +x /tmp/${basename(provisioner.value.script)}",
        "/tmp/${basename(provisioner.value.script)}",
      ]
    }
  }

  provisioner "shell" {
    inline = [
      "sudo waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]
  }
}

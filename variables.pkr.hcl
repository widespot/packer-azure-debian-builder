variable "subscription_id" {
  type        = string
  description = "Azure subscription ID used by Packer."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the resulting managed image is created."
}

variable "resource_group_location" {
  type        = string
  description = "Azure region."
  default     = "westeurope"
}

variable "vm_image_name" {
  type        = string
  description = "Managed image name."
  default     = "azdo-debian-runner"
}

variable "vm_size" {
  type        = string
  description = "Temporary VM size used during image build."
  default     = "Standard_D8s_v5"
}

variable "packages" {
  type        = list(string)
  description = "APT packages to install in the custom runner image."
  default = [
    "build-essential",
    "ca-certificates",
    "curl",
    "git",
    "jq",
    "make",
    "gcc",
    "python3",
    "python3-pip",
    "python3-cryptography",
    "unzip",
    "zip",
    # Build .iso files
    "xorriso",
    # Qemu
    "qemu-kvm",
    "qemu-utils",
    # Virtualization helpers
    "libvirt-daemon-system",
    "libvirt-clients",
  ]
}

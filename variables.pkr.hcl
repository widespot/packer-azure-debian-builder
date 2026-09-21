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
    # Virtualization helpers
    "libvirt-daemon-system",
    "libvirt-clients",
  ]
}

variable "enable_pyenv" {
  type        = bool
  description = "Enable pyenv installation."
  default     = true
}

variable "pyenv_python_version" {
  type        = string
  default     = "3.12.4"
  description = "Version of Python to install and enable globally when PyEnv is enabled"
}

variable "enable_docker" {
  type        = bool
  description = "Enable Docker installation."
  default     = true
}

variable "enable_packer" {
  type        = bool
  description = "Enable Packer installation."
  default     = true
}

variable "enable_qemu" {
  type        = bool
  description = "Enable QEMU installation."
  default     = true
}

variable "enable_azcli" {
  type        = bool
  description = "Enable Azure CLI installation."
  default     = true
}

variable "enable_virtualbox" {
  type        = bool
  description = "Enable VirtualBox installation."
  default     = true
}

variable "enable_nvm" {
  type        = bool
  description = "Enable NVM installation."
  default     = true
}

variable "nvm_version" {
  type        = string
  default     = "v0.40.8"
  description = "See https://github.com/nvm-sh/nvm/tags"
}

variable "nvm_node_version" {
  type        = string
  default     = "26"
  description = ""
}

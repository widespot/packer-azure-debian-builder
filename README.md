# Packer Debian Builder with nested virtualization (Docker, Qemu + VirtualBox)
> Build VM image in ... an Azure Virtual Machine!

This Packer template builds a Debian 12 Azure Virtual Machine designed to build other VM images
* Packer pre installed
* **Docker**, **VirtualBox** and **QEMU** nested virtualization configured
* Common build tools installed (**git**, **xorriso**, **curl**, etc)

> Ideal for imaging Elastic Azure DevOps CI/CD agents designed to build VM images

----

## Quickstart
Packer doesn't come with a modular way to import libraries.
For using this project in yours, we advise to clone this repo a submodule or nested git
```shell
# As submodule
git submodule add https://github.com/widespot/packer-azure-debian-builder.git
# As nested git
#git clone https://github.com/widespot/packer-azure-debian-builder.git
echo "azure_subscription_id = \"<your-subscription-id>\"" >> variables.pkrvars.hcl
packer build --var-file ./variables.pkrvars.hcl ./packer-azure-debian-builder
```

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_packages"></a> [packages](#input\_packages) | APT packages to install in the custom runner image. | `list(string)` | <pre>[<br/>  "build-essential",<br/>  "ca-certificates",<br/>  "curl",<br/>  "git",<br/>  "jq",<br/>  "make",<br/>  "gcc",<br/>  "python3",<br/>  "python3-pip",<br/>  "python3-cryptography",<br/>  "unzip",<br/>  "zip",<br/>  "xorriso",<br/>  "qemu-kvm",<br/>  "qemu-utils",<br/>  "libvirt-daemon-system",<br/>  "libvirt-clients"<br/>]</pre> | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Azure region. | `string` | `"westeurope"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group where the resulting managed image is created. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID used by Packer. | `string` | n/a | yes |
| <a name="input_vm_image_name"></a> [vm\_image\_name](#input\_vm\_image\_name) | Managed image name. | `string` | `"azdo-debian-runner"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | Temporary VM size used during image build. | `string` | `"Standard_D8s_v5"` | no |
<!-- END_TF_DOCS -->

### Generate this doc
```bash
terraform-docs --show inputs markdown table --output-file README.md --indent 2 .
```

## Dev
```shell
cp variables.pkrvars.hcl.example variables.pkrvars.hcl
packer init .
packer validate .
packer build .
```

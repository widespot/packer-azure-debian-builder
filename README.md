# Packer Debian Builder with nested virtualization
> Build VM image in ... an Azure Virtual Machine!

This Packer template builds a Debian 12 Azure Virtual Machine designed to build other VM images
* Packer pre installed
* **Docker**, **VirtualBox** and **QEMU** nested virtualization configured
* Common build tools installed (**git**, **xorriso**, **curl**, etc)

> Ideal for imaging Elastic Azure DevOps CI/CD agents designed to build VM images

----

## Quickstart
```shell
git clone https://github.com/widespot/packer-azure-debian-builder.git
echo "azure_subscription_id = \"<your-subscription-id>\"" >> variables.pkrvars.hcl
packer build --var-file ./variables.pkrvars.hcl ./packer-azure-debian-builder
```

## Dev
```shell
cp variables.pkrvars.hcl.example variables.pkrvars.hcl
packer init .
packer validate .
packer build .
```

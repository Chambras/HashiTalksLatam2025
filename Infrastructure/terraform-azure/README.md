# Como hacer tu primera contribución al proveedor AzureRM

Crea los siguientes recursos de Azure para el desarrollo de AzureRM:
* Resource Group
* Virtual Network
* Subnet
* Public IP
* Network Security Group
* Network Interface
* Virtual Machine

## Estructura del Proyecto

Este proyecto tiene las siguientes carpetas que facilitan su reutilización, adición o eliminación.

```ssh
.
├── LICENSE.txt
├── README.md
├── compute.tf
├── main.tf
├── mainDevVMVariables.tf
├── networking.tf
├── outputs.tf
├── security.tf
└── variables.tf
```
Los parametros más comunes se exponen como variables en los archivos _`*variables.tf`_.

## Requisitos

Se asume que tienes azure cli y terraform instalados y configurados.
Mas información al respecto [aquí](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure). Recomiendo usar un `Service Principal` con un certificado.

### Versiones

Esta script de terraform ha sido probado usando las siguientes versiones:

* Terraform >= 1.10.4
* Azure provider = 4.14.0
* Azure CLI 2.64.0

## VM Authentication

Usas SSH to connect to the VM y asume que ya tienes una llave. Puedes configurar la ruta usando la variable _`sshKeyPath`_ en _`variables.tf`_ Puedes crear una usando este comando:

```ssh
ssh-keygen -t rsa -b 4096 -m PEM -C vm@mydomain.com -f ~/.ssh/vm_ssh
```

## Como usar

Solo ejecuta los siguientes comandos para inicializar terraform, obtener un plan y aprobarlo para aplicarlo.

```ssh
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```
Tambien se recomienda usar un estado remoto en lugar de uno local. Puedes cambiar esta configuración en _`main.tf`_
Puedes crear una cuenta gratuita de Terraform Cloud [aquí](https://app.terraform.io).

## Limpiar los recursos creados

Este comando destruirá todo lo que se creó.

```ssh
terraform destroy --force
```

## Cuidado

Tenga en cuenta que al ejecutar este demo es posible que se facture a su subscripción de Azure.

## Autor

* Marcelo Zambrana

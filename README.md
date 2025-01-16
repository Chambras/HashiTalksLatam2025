[![Terraform](https://github.com/Chambras/HashiTalksLatam2025/actions/workflows/terraform.yml/badge.svg)](https://github.com/Chambras/HashiTalksLatam2025/actions/workflows/terraform.yml)

# Como hacer tu primera contribución al proveedor AzureRM

En esta sesión, exploraremos el mundo del código abierto mediante contribuciones al proveedor de AzureRM en GitHub. Ya sea que seas nuevo en el código abierto o un desarrollador experimentado, esta charla te guiará en la configuración de una máquina virtual para desarrolladores optimizada para el desarrollo de AzureRM. Cubriremos herramientas esenciales, prácticas recomendadas para configurar tu entorno y cómo crear tu propio `fork`, clonar y enviar `Pull Requests` al repositorio del proveedor AzureRM in GitHub.

Al final de esta sesión, tendrás el conocimiento y la confianza para hacer tu primera contribución al proveedor de AzureRM y participar activamente con la comunidad de código abierto.

## Estructura del Proyecto

Este proyecto tiene las siguientes carpetas que facilitan su reutilización, adición o eliminación.

```ssh
.
├── Ansible
├── Infrastructure
├── LICENSE
├── README.md
```

## Como usar

El objetivo de este proyecto es crear una máquina virtual para desarrolladores optimizada para el desarrollo del proveeder de AzureRM. La configuracion se basa en la documentación oficial del proveedor [aquí](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/DEVELOPER.md).

Usa ansible para hacer la configuración de la VM.

Una vez que te conectes a la VM puedes correr los siguientes comandos para descargar el código fuente del proveedor AzureRM y compilarlo.

```bash
mkdir -p $GOPATH/src/github.com/hashicorp
cd $GOPATH/src/github.com/hashicorp
git clone https://github.com/ACCOUNT/terraform-provider-azurerm.git
cd terraform-provider-azurerm/
make build
```

Una compilación exitosa se verá como la siguiente:

```bash
==> Checking that code complies with gofmt requirements...
==> Checking that Custom Timeouts are used...
==> Checking that acceptance test packages are used...
go generate ./internal/services/...
go generate ./internal/provider/
go install
```

Una vez terminada la compilación el binario estará en la siguiente ruta:

```bash
$GOPATH/bin/
```

Para habilitar los logs de depuración puedes correr el siguiente comando:

```bash
export TF_LOG=DEBUG
```

Antes de correr los tests de aceptación es necesario declarar las siguientes variables de entorno:

```bash
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `ARM_ENVIRONMENT`
- `ARM_METADATA_HOSTNAME`
- `ARM_TEST_LOCATION`
- `ARM_TEST_LOCATION_ALT`
- `ARM_TEST_LOCATION_ALT2`
```

Para correr todos los tests de aceptación:

```bash
make testacc
```

Para correr un test específico:

```bash
make acctests SERVICE='<service>' TESTARGS='-run=<nameOfTheTest>' TESTTIMEOUT='60m'
```

Mas información sobre como ejecutar las pruebas [aquí](https://github.com/hashicorp/terraform-provider-azurerm/blob/main/contributing/topics/running-the-tests.md).

> **Nota:** Estas pruebas crean recursos en Azure y pueden incurrir en costos. 

Para asegurar que las dependencias estén actualizadas y limpiar el proyecto puedes correr:

```bash
go mod tidy && go mod vendor
```
## Cuidado

Tenga en cuenta que al ejecutar este demo es posible que se facture a su subscripción de Azure.

## Autor

* Marcelo Zambrana

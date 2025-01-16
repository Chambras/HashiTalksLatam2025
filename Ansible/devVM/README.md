# Entorno de Desarrollo Personal

Configuración de un entorno de desarrollo personal usando Ansible.

## Project Structure

```ssh
.
├── LICENSE
├── README.md
├── ansible.cfg
├── hosts
├── mainDev.yml
└── roles
    ├── install
    │   ├── defaults
    │   │   └── main.yml
    │   ├── files
    │   │   ├── maven.sh
    │   │   ├── setWSLCloud.sh
    │   │   └── updateTools.sh
    │   ├── tasks
    │   │   └── main.yml
    │   └── templates
    └── secrets
        ├── defaults
        │   └── main.yml
        ├── files
        │   ├── config
        │   ├── config.json
        │   ├── config.yml
        │   ├── credentials
        │   ├── git
        │   ├── git.pub
        │   ├── hosts.yml
        │   ├── prsnlmarcelocli.pem
        │   ├── prsnlmarcelocli.pfx
        │   ├── vm_ssh
        │   └── vm_ssh.pub
        └── tasks
            └── main.yml
```

## Requirements

### Platform Support

- Ubuntu 24.04 LTS

### Versions

- ansible 2.17.7

### Autenticación SSH

Usa llaves SSH para autenticación y asume que ya tienes una llave y puedes configurar la ruta usando la variable _ansible_ssh_private_key_file_ en el archivo _`hosts`_.
Puedes crear una llave usando este comando:

```ssh
ssh-keygen -t rsa -b 4096 -m PEM -C vm@mydomain.com -f ~/.ssh/vm_ssh
```

## Variables de Role 

Estas variables y sus valores por defecto se encuentran en `roles/secrets/defaults/main.yml`

```ssh
BNT_VRSN: 24.04
BNT_VRSN_NM: noble

dev_user: marcelo
dev_group: marcelo

TRRFRM_VRSN: 1.10.4
TFLINT_VRSN: 0.53.0
TFLINT_AZURERM: 0.27.0

GH_VRSN: 2.65.0

G_VRSN: 1.22.7

BDWLF_VRSN: 1.6.0
```

## Uso

```ssh
ansible-playbook --syntax-check mainDev.yml
ansible-playbook --check mainDev.yml
ansible-playbook mainDev.yml
```

## HOSTS file

El archivo `hosts` es el inventario donde debes proporcionar las IP de los servidores que necesitan ser configurados. También puedes configurar la clave SSH a utilizar, el nombre de usuario y el puerto SSH.

## Autor

Marcelo Zambrana

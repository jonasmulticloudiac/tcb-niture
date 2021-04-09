# Oracle Cloud - OCI :  tcb-niture -
## Terraform Cloud - explorando possibilidades - @TheCloudBootcamp
__Objetivo:__
>  Criar Virtuais Machine e escalar de acordo com a necessidade - { Alterar a variavel qtdevm no arquivo variables }
>  
>  Criar LoadBalancer e associa-lo as vms criadas 
>  
>  Criar Escopo de Rede { gateway | redes | sub-nets | routers |  firewall }
>  
>  Provisionar a aplicação e realizar os ajustes necessários no momento do deploy
>  
> Criação da Zona de Dns e associação ao dominio publico. 

## Variáveis de ambiente devem ser criadas no Terraform Cloud e atribuídas com os seus respectivos valores
- variable "compartment_ocid" {}
- variable "region" {}
- variable "tenancy_ocid" {}
- variable "user_ocid" {}
- variable "fingerprint" {}
- variable "private_key" {}
- variable "ssh_public_key" {}
- variable "ssh_private_key" {}



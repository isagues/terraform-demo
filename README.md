# terraform-demo

## Autores

- [Brandy Tobias](https://github.com/tobiasbrandy)
- [Pannunzio Faustino](https://github.com/Fpannunzio)
- [Sagues Ignacio](https://github.com/isagues)

## Instructivo para deployar aplicación terraform

### 1. Terraform

Instalar [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) siguiendo la documentación oficial.

### 2. Amazon Web Services

1. Crear un nuevo usuario para que utilice terraform. Idealmente con permisos `AdministratorAccess` para simplificar manejo de permisos.
2. Crear y guardar access keys de usuario en `$HOME/.aws/credentials`.
3. Crear una `HostedZone` en `Route53` del dominio para usar por la aplicación. En caso de ser un subdominio, crear en el padre el record NS que apunte a este.

### 3. Google Cloud Platform

1. Crearse una cuenta en GCP y crear un nuevo proyecto.
2. Asegurarse de que su usuario por default posee el rol `Propretario`.
3. Habilitar los siguientes servicios de Google:
    - Cloud DNS API
    - Compute Engine API
4. Instalar la [gcloud CLI](https://cloud.google.com/sdk/docs/install) siguiendo la documentación oficial.
5. Ejecutar `gcloud auth application-default login` y loguearse con su cuenta.

### 4. Clonar el proyecto

Clonar el proyecto del [repositorio git](https://github.com/isagues/terraform-demo.git) y moverse a la carpeta del mismo. 

### 5. Deployar Backend

El backend es el sistema que tenemos para allmacenar el state de terraform generado. En este caso utilizaremos un S3 encriptado con una llave en KMS. Es por esto que antes de deployar nuestro proyecto tendremos que crear estos recursos.

1. En el archivo `backend/config.tfvars` deberemos configurar los siguientes parametros:
    - `authorized_IAM_arn`: Lista con el arn de los usuarios IAM de AWS con los queremos poder ejecutar terraform. Por ejemplo, el que creamos previamente.
    - `root_IAM_arn`: El arn de nuestro usuario root IAM en AWS.
    - `aws_region`: La region AWS donde queremos almacenar el state.

    Se incluye un archivo de ejemplo para modificar.

2. Ejecutar `init_backend.sh`. Se deberia crear el archivo de configuracion de backend `backend_config.tfvars`.

### 6. Deployar Aplicacion

1. En el archivo `config.tfvars` deberemos configurar los siguientes parametros:
    - `ssh_key_path`: Ubicacion de una clave pública neecsaria para acceder a las instancias EC2 en AWS mediante SSH.
    - `my_ips`: IPs públicas desde donde es posible acceder a las instancias EC2 de AWS por SSH.
    - `aws_region`: Region de AWS en donde deployar.
    - `base_domain`: Dominio o subdominio de la aplicacion para la cual creamos la `HostedZone` en `Route53`.
    - `gcp_project`: ID (no nombre!) del proyecto GCP a utilizar.
    - `gcp_region`: Region de GCP en donde deployar.
    - `gcp_user`: Usuario IAM de GCP utilizado para ejecutar terraform.

  Se incluye un archivo de ejemplo para modificar.

2. Ejecutar `terraform init -backend-config=backend_config.tfvars` para inicializar terraform.
3. Ejecutar `terraform apply -var-file=config.tfvars -auto-approve` para empezar a deployar.

Tener en cuenta que el proceso puede durar varios minutos, y que una vez finalizado puede tomar unos minutos hasta que el sitio se pueda acceder.

Una vez deployado, deberiamos obtener respuesta de los subdominios:
  - `aws`: La aplicacion deployada en AWS
  - `gcp`: La aplicacion deployada en GCP
  - `demo`: El subdominio principal. En caso de que ambos deploys esten corriendo, redirige al deploy en AWS. Si el mismo esta caido, redirige al de GCP.

## Servicios

Cada uno de los subdominios ofrecen los sigueintes 3 servicios:
  - `\`: Una web estatica de helados
  - `\api\time`: Fecha y hora actual
  - `\api\instance`: IP interna de la instancia que esta respondiendo el pedido.

## Configuracion Adicional

En el archivo `locals.tf` se encuentran parametros adicionales del deploy, que decidimos exponer para modificar su comportamiento facilmente, si bien no son necesarios para levantar la aplicacion. Los mismos son:
  - `app_name`: Nombre del subdominio de la aplicacion. Por defecto `demo`.
  - `pri_app_deploy`: Nombre del subdominio de la aplicacion en aws. Por defecto `aws`.
  - `sec_app_deploy`: Nombre del subdominio de la aplicacion en gcp. Por defecto `gcp`.
  - `static_resources`: Ubicacion de los recursos estaticos para el frontend. Por defecto `frontend`, donde se encuentra una pagina de helados.
  - `ssh_key_name`: El nombre utilizado para referirse a la clave SSH para acceder a las instancias EC2. Por defecto `redes_key`.
  - `aws_vpc_network`: El CIDR asignado a la VPC de AWS. Por defecto `10.0.0.0/16`.
  - `aws_az_count`: La cantidad de Availability Zones creadas. Por defecto `2`.
  - `aws_ec2_ami`: Imagen base utilizada para crear las instancias EC2. Por defecto `ami-0022f774911c1d690` correspondiente a un `amazon-linux`.
  - `aws_ec2_type`: Tipo de instancia EC2 utilizada. Por defecto `t2.micro`.
  - `aws_ec2_web_user_data`: Ubicacion de la user data provista a las EC2 web server. El mismo es un script que se ejecuta cuando la instancia es creada. Por defecto `scripts/web_server_user_data.sh`. El mismo descarga y configura los nginx de los web servers.


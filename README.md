# practica-01-02

Todo esto se hace para automatizar los pasos con los scripts creados de "**install_lamp.sh**" y "**install_tools.sh**". Para instalar lo necesario solo ejecutando el script. Todo esto se ha hecho en **AWS** en una instancia de **Red Hat**, y todos los pasos con **VisualStudioCode** conectado a través de **SSH** con clave privada.

## Actualizamos todo con

    sudo dnf up

  

## Descargamos GitHub
Primero buscamos el paquete

    sudo dnf search git

Luego de buscar el paquete lo instalamos
  
    sudo dnf install git

  

y ponemos nuestro repositorio de **GitHub**

    git clone https://github.com/sanchezguille7/practica-01-02.git

  

# Creamos un archivo llamado "install_lamp.sh" para instalar Apache, MySQL server y PHP.
 

Configuramos el script para que se muestren los comandos que se ejecuten

    set  -x

Actualizamos los paquetes

    dnf  update  -y

  

# --------------------------------------------------

  

## Instalamos el servidor web Apache

    dnf  install  httpd  -y

  

Iniciamos el servicio

    systemctl  start  httpd

  

Configuramos para que el servicio se inicie automáticamente

    systemctl  enable  httpd

  

# ---------------------------------------------------

  

# Instalamos MySQL server
Instalamos el paquete

    dnf  install  mysql-server  -y

  

Iniciamos el servicio de **MySQL**

    systemctl  start  mysqld

  

Configuramos el servicio para que se inicie automáticamente en cada reinicio

    systemctl  enable  mysqld

  

#  ------------------------------------------------

  

# Instalamos PHP

    dnf  install  php  -y

  

Instalamos la extensión de **PHP** para **MySQL**

    dnf  install  php-mysqlnd  -y

  

Reiniciamos el servicio de **Apache** para que se apliquen los cambios.

    systemctl  restart  httpd

  

Copiamos el archivo info.php en **/var/www/html**

    cp  ../php/info.php  /var/www/html

  

Cambiamos el propietario y el grupo del directorio **/var/www/html**

    chown  -R  apache:apache  /var/www/html


# -------------------------------------------

# Creamos otro archivo para instalar otros programas, lo llamaremos "install_tools.sh"  

Configuramos el script para que se muestren los comandos que se ejecuten

    set  -x

 

Importamos el script de variables de entorno

    

    source .env

  

Actualizamos los paquetes

    dnf  update  -y

  

# ---------------------------------------------------

  

# Instalamos los módulos de PHP necesarios para PHPMyAdmin

    sudo  dnf  install  php-mbstring  php-zip  php-json  php-gd  php-fpm  php-xml  -y

  

Reiniciamos el servicio de apache para que se entere de que hay módulos nuevos

    systemctl  restart  httpd

  

## Instalamos la utilidad "wget"

    dnf  install  wget  -y

  

Eliminamos descargas previas de **PHPMyAdmin**

    rm  -rf  /tmp/phpMyAdmin-5.2.1-all-languages.zip

  

Eliminamos instalaciones previas de **PHPMyAdmin**

    rm  -rf  /var/www/html/phpmyadmin

  

Descargamos el código fuente de **PHPMyAdmin**

    wget  https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip  -P  /tmp

  # ---------------------------------------------------

## Instalamos la utilidad "unzip"

    dnf  install  unzip  -y

  

Descomprimimos el código fuente de **PHPMyAdmin** en **/var/www/html**

    unzip  -u  /tmp/phpMyAdmin-5.2.1-all-languages.zip  -d  /var/www/html

  

Renombramos el directorio de **PHPMyAdmin**

    mv  /var/www/html/phpMyAdmin-5.2.1-all-languages  /var/www/html/phpmyadmin

  

## Creamos el archivo de configuración a partir del archivo de ejemplo

    cp  /var/www/html/phpmyadmin/config.sample.inc.php  /var/www/html/phpmyadmin/config.inc.php

# ---------------------------------------------------

# Configuramos el Blowfish_secret

Generamos un valor aleatorio de 32 caracteres para la variable **blowfish_secret**

    RANDOM_VALUE=`openssl rand -hex  16`

  

Modificamos la variable **blowfish_secret** en el archivo de configuración

    sed  -i  "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/"  /var/www/html/phpmyadmin/config.inc.php

  

Creamos un directorio temporal para **PHPMyAdmin**

    mkdir  -p  /var/www/html/phpmyadmin/tmp/

  

Actualizamos los permisos del directorio **/var/www/html**

    chown  -R  apache:apache  /var/www/html

  

Eliminamos si existe alguna base de datos previa de **PHPMyAdmin**

    mysql  -u  root  <<<  "DROP DATABASE IF EXISTS phpmyadmin"

# ---------------------------------------------------  

## Importamos el script de creacion de base de datos de Phpmyadmin

    mysql  -u  root  <  /var/www/html/phpmyadmin/sql/create_tables.sql

  
  

Creamos el usuario para la base de datos y le asignamos privilegios:

 1. `mysql  -u  root  <<<  "DROP USER IF EXISTS $PMA_USER@'%'"`
 2. 

    mysql  -u  root  <<<  "CREATE USER $PMA_USER@'%' IDENTIFIED BY
        '$PMA_PASS'"

 3. 

    mysql  -u  root  <<<  "GRANT ALL PRIVILEGES ON $PMA_DB.* TO
        $PMA_USER@'%'"

# ---------------------------------------------------
# Tenemos que tener en otro archivo llamado ".env" los credenciales de las variables que hemos metido en los comandos anteriores
Aquí tendremos guardadas los valores de las variables

    PMA_USER=guille
    PMA_PASS=1234
    PMA_DB=phpmyadmin
# ---------------------------------------------------
# Y también tendremos otro archivo PHP llamado "info.php"
En este archivo mostraremos solo la pagina de información principal de **PHP**

    <?php
    
    phpinfo();
    
    ?>




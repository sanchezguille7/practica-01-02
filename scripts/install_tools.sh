#!/bin/bash

#Consifugramos el script para qu se muestren los comandos que se ejcuten
set -x

# Importamos el script de variables de entorno
source .env

# Actualizamos los paquetes
dnf update -y

#----------------------------------------------------------------------------------------

#instalamos los modulos de php necesarios para phpmyadmin
sudo dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y

# Reiniciamos el servicio de apache para que se enterere de que hay modulos nuevos
systemctl restart httpd

# instalamos la utilidad wget
dnf install wget -y

# elminiamos descargas previas de phpmyadmin
rm -rf /tmp/phpMyAdmin-5.2.1-all-languages.zip

#eliminamos instalaciones previas de phpmyadmin
rm -rf /var/www/html/phpmyadmin

#descargamos el codigo fuente de phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip -P /tmp

# instalamos la utilidad unzip
dnf install unzip -y

# descomprimimos el codigo fuente de phpmyadmin en /var/www/html
unzip -u /tmp/phpMyAdmin-5.2.1-all-languages.zip -d /var/www/html

#renombramos el directorio de phpmyadmin
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

# creamos el archivo de configuracion a partir del archivo de ejemplo
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

#Configuramos el  Blowfish_secret
# Generamos un valor aleatorio de 32 caracteres para la variable blowfish_secret
RANDOM_VALUE=`openssl rand -hex 16`

# Modificamos la variable blowfish_secret en el archivo de configuración
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php

#creamos un directorio temporal para phpmyadmin
mkdir -p /var/www/html/phpmyadmin/tmp/

#actualizamos los permisos del directorio /var/www/html
chown -R apache:apache /var/www/html 

# eliminamos si existe alguna base de datos previa de phpmyadmin
mysql -u root <<< "DROP DATABASE IF EXISTS phpmyadmin"

# Importamos el script de  creacion de base de datos de Phpmyadmin
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql


#Creamos el usuario para la base de datos y le asignamos privilegios
mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"
mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"

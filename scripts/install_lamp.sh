#!/bin/bash

#Consifugramos el script para qu se muestren los comandos que se ejcuten
set -x

# Actualizamos los paquetes
dnf update -y

#----------------------------------------------------------------------------------------

# Instalamos el servidor web Apache
dnf install httpd -y

#iniciamos el servicio
systemctl start httpd

#configuramos para que el servicio se inicie automaticamente
systemctl enable httpd

#----------------------------------------------------------------------------------------

#instalamos MySQL server
dnf install mysql-server -y

# Iniciamos el servicio de mysql
systemctl start mysqld

#COnfiguramos el servicio para que se inicie automaticamente en cad reinicio
systemctl enable mysqld

#----------------------------------------------------------------------------------------

#Instalamos PHP 
dnf install php -y

#instalamos la extension de PHP para MySQL
dnf install php-mysqlnd -y

# reiniciamos el servicio de Apache para que se apliquen los cambios.
systemctl restart httpd

# copiamos el archivo info.php en /var/www/html
cp ../php/info.php /var/www/html

#Cambiamos el propietario y el grupo del directorio /var/www/html
chown -R apache:apache /var/www/html
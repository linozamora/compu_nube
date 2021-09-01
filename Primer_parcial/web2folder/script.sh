#!/bin/bash
echo "INSTALANDO PAQUETES NECESARIOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO GRUPO LXD"
newgrp lxd

echo "INICIALIZANDO EL LXD "
lxd init --auto

echo "CREANDO CONTENEDOR"
lxc launch ubuntu:20.04 web2

echo "ACTUALIZANDO"
lxc exec web2 -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE"
lxc exec web2 -- apt install -y apache2
lxc exec web2 -- systemctl enable apache2

echo "GENERANDO INDEX.HTML"
lxc file push /vagrant/web2folder/index.html web2/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web2 -- systemctl restart apache2

echo "CONFIGURANDO PUERTOS"
lxc config device add web2 myport80 proxy listen=tcp:192.168.50.4:80 connect=tcp:127.0.0.1:80

echo "CREANDO CONTENEDOR BACKUP"
lxc launch ubuntu:20.04 web2b

echo "ACTUALIZANDO"
lxc exec web2b -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE"
lxc exec web2b -- apt install -y apache2
lxc exec web2b -- systemctl enable apache2

echo "GENERANDO INDEX.HTML"
lxc file push /vagrant/web2folder/index.html web2b/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web2b -- systemctl restart apache2

echo "CONFIGURANDO PUERTOS"
lxc config device add web2b myport80 proxy listen=tcp:192.168.50.4:1080 connect=tcp:127.0.0.1:80

echo "SERVICIO LISTO PARA USARSE"



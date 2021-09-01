#!/bin/bash
echo "INSTALANDO PAQUETES NECESARIOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO GRUPO LXD"
newgrp lxd

echo "INICIALIZANDO EL LXD "
lxd init --auto

echo "CREANDO CONTENEDOR"
lxc launch ubuntu:20.04 web1

echo "ACTUALIZANDO"
lxc exec web1 -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE"
lxc exec web1 -- apt install -y apache2
lxc exec web1 -- systemctl enable apache2

echo "GENERANDO INDEX.HTML"
lxc file push /vagrant/web1folder/index.html web1/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web1 -- systemctl restart apache2

echo "CONFIGURANDO PUERTOS"
lxc config device add web1 myport80 proxy listen=tcp:192.168.50.3:80 connect=tcp:127.0.0.1:80

echo "CREANDO CONTENEDOR BACKUP"
lxc launch ubuntu:20.04 web1b

echo "ACTUALIZANDO"
lxc exec web1b -- sudo apt update && apt upgrade -y

echo "INSTALANDO APACHE"
lxc exec web1b -- apt install -y apache2
lxc exec web1b -- systemctl enable apache2

echo "GENERANDO INDEX.HTML"
lxc file push /vagrant/web1folder/index.html web1b/var/www/html/index.html

echo "CONFIGURANDO SERVICIO"
lxc exec web1b -- systemctl restart apache2

echo "CONFIGURANDO PUERTOS"
lxc config device add web1b myport80 proxy listen=tcp:192.168.50.3:1080 connect=tcp:127.0.0.1:80

echo "SERVICIO LISTO PARA USARSE"



#!/bin/bash
echo "creacion y ejecucion de contenedor serverShell"
sudo lxc launch ubuntu:20.04 serverShell < /dev/null

echo "Instalacion de apache2 en contenedor"
sudo lxc exec serverShell -- sudo apt install apache2 -y

echo "Creacion de index.html y envio a contenedor"
sudo touch index.html
sudo cat << TEST > /home/vagrant/index.html
<html>
	<head>
		<title>WEB APROVISIONADA</title>
	</head>
	<body>
	POWERED BY SHELL PROVISION
</html>
TEST
sudo lxc file push index.html serverShell/var/www/html/index.html
sudo lxc exec serverShell -- sudo service apache2 restart

echo "Agregar direccionamiento del puerto 5055 de la maquina al 80 del contenedor"
sudo lxc config device add serverShell myport80serverShell proxy listen=tcp:192.168.100.3:5055 connect=tcp:127.0.0.1:80
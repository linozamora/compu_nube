#!/bin/bash
echo "CONFIGURANDO EL HAPROXY LOAD BALANCER"

echo "INSTALANDO RECURSOS NECESARIOS"
sudo apt install -y vim net-tools lxd

echo "CREANDO NUEVO GRUPO"
sudo newgrp lxd

echo "INICIALIZANDO LXD"
sudo lxd init --auto

echo "LANZANDO CONTENEDOR HAPROXY"
sudo lxc launch ubuntu:20.04 haproxy

echo "ACTUALIZANDO CONTENEDOR"
sudo lxc exec haproxy -- sudo apt-get update && apt-get upgrade -y

echo "INSTALANDO HAPROXY"
sudo lxc exec haproxy -- sudo apt install -y haproxy

echo "ACTIVANDO HAPROXY"
sudo lxc exec haproxy -- sudo systemctl enable haproxy

sudo lxc exec haproxy -- sudo systemctl status haproxy

echo "AJUSTANDO EL ARCHIVO DE CONFIGURACIÓN"
sudo lxc file push /vagrant/haproxyfolder/haproxy.cfg haproxy/etc/haproxy/

echo "RESTABLECIENDO EL SERVICIO"
sudo lxc exec haproxy -- sudo systemctl restart haproxy

echo "CONFIGURANDO REDIRECCIONAMIENTO DE PUERTOS"
sudo lxc config device add haproxy m80 proxy listen=tcp:192.168.50.2:80 connect=tcp:127.0.0.1:80

echo "CONFIGURANDO PAGINA DE DISCULPAS"
sudo sudo lxc file push /vagrant/haproxyfolder/503.http haproxy/etc/haproxy/errors/

echo "SERVICIO LISTO PARA EL USO"
sudo lxc exec haproxy -- sudo systemctl restart haproxy



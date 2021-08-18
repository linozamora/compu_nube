#!/bin/bash

echo "configurando el resolv.conf con cat"
cat << TEST > /etc/resolv.conf
nameserver 8.8.8.8
TEST

echo "instalando un servidor vsftpd"
sudo apt-get install vsftpd -y

echo "Modificando vsftpd.conf con sed"
sed -i 's/#write_enable=YES/write_enable=YES/g' /etc/vsftpd.conf

echo "configurando ip forwarding con echo"
sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

echo "ENCENDIENDO EL SERVICIO FTP"
sudo service vsftpd start

echo "CREANDO USUARIO LINO"
sudo adduser --disabled-password --gecos "" lino
sudo echo "lino:santiago" | sudo chpasswd

echo "CREANDO USUARIO SANTIAGO"
sudo adduser --disabled-password --gecos "" santiago
sudo echo "santiago:lino" | sudo chpasswd

echo "CAMBIANDO MENSAJE DE BIENVENIDA"
sudo sed -i 's/#ftpd_banner=Welcome to blah FTP service./ftpd_banner=WELCOME TO LINO VSFTPF. THE BEST OF THE WORLD./g' /etc/vsftpd.conf

echo "HABILITANDO USUARIOS ANONIMOS"
sudo sed -i 's/anonymous_enable=NO/anonymous_enable=YES/g' /etc/vsftpd.conf

echo "RESTRINGIENDO ACCESO A USUARIOS ANONIMOS"
sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd.conf

echo "ACTUALIZANDO CAMBIOS"
sudo service vsftpd restart
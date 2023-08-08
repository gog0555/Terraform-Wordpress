#!/bin/bash

sudo dnf update -y
sudo dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
sudo dnf -y localinstall  https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
sudo dnf -y install mysql mysql-community-client
sudo yum -y install mysql mysql-devel

wget http://ja.wordpress.org/latest-ja.tar.gz -P /root/
sudo tar zxvf /root/latest-ja.tar.gz -C /root/
sudo rm /root/latest-ja.tar.gz

sudo cp -r /root/wordpress/* /var/www/html/
sudo chown apache:apache -R /var/www/html/

sudo systemctl start httpd.service
sudo systemctl status httpd.service

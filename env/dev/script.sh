#!/bin/bash

dnf update -y
dnf install -y httpd wget php-fpm php-mysqli php-json php php-devel
dnf -y localinstall  https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
dnf -y install mysql mysql-community-client
yum -y install mysql mysql-devel

wget http://ja.wordpress.org/latest-ja.tar.gz -P /tmp/
tar zxvf /tmp/latest-ja.tar.gz -C /tmp
cp -r /tmp/wordpress/* /var/www/html/
chown apache:apache -R /var/www/html

systemctl enable httpd.service
systemctl start httpd.service

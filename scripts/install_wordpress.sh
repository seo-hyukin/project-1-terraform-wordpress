#!/bin/bash
dnf update -y
dnf install -y httpd php php-mysqlnd wget

systemctl start httpd
systemctl enable httpd

cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .
rm -rf wordpress latest.tar.gz

chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html

cp wp-config-sample.php wp-config.php


sed -i "s/database_name_here/wordpress/g" wp-config.php
sed -i "s/username_here/admin/g" wp-config.php
sed -i "s/password_here/1dlsmnJP!/g" wp-config.php
sed -i "s/localhost/terraform-20251205123325290800000005.chk0c2gk6edb.ap-northeast-2.rds.amazonaws.com/g" wp-config.php
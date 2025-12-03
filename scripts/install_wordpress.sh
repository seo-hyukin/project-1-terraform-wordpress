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
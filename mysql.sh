#!/usr/bin/env bash

sudo apt-get update

sudo apt-get install -y make debconf-utils pwgen

MYSQL_DB=${1:-app};
MYSQL_USERNAME=${2:-mysqluser};
MYSQL_ROOT_PASS=$(pwgen -s 12 1);
MYSQL_USER_PASS=$(pwgen -s 8 1);

sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${MYSQL_ROOT_PASS}"
sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${MYSQL_ROOT_PASS}"
sudo apt-get install -y mysql-server-5.5

if [ ! -f /var/log/dbinstalled ];
then   
 	echo "root:${MYSQL_ROOT_PASS}" > /vagrant/mysql_passwords
	echo "${MYSQL_USERNAME}:${MYSQL_USER_PASS}" >> /vagrant/mysql_passwords
    echo "CREATE USER '${MYSQL_DB}'@'localhost' IDENTIFIED BY '${MYSQL_USER_PASS}';" | mysql -uroot -p${MYSQL_ROOT_PASS}
    echo "CREATE DATABASE ${MYSQL_DB};" | mysql -uroot -p${MYSQL_ROOT_PASS}
    echo "GRANT ALL ON ${MYSQL_DB}.* TO '${MYSQL_USERNAME}'@'localhost';" | mysql -uroot -p${MYSQL_ROOT_PASS}
    echo "flush privileges;" | mysql -uroot -p${MYSQL_ROOT_PASS}
    touch /var/log/dbinstalled
    if [ -f /vagrant/init.sql ];
    then
        mysql -uroot -p${MYSQL_ROOT_PASS} ${MYSQL_DB} < /vagrant/init.sql
    fi
fi
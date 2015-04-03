#!/usr/bin/env bash

sudo apt-get update

sudo apt-get -y install wget
sudo apt-get -y install apache2 libapache2-mod-php5 
sudo apt-get -y install php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick php5-ldap
sudo apt-get -y install smbclient
wget --quiet https://download.owncloud.org/community/owncloud-8.0.2.tar.bz2
md5sum  owncloud-8.0.2.tar.bz2
sha256sum owncloud-8.0.2.tar.bz2
wget --quiet https://download.owncloud.org/community/owncloud-8.0.2.tar.bz2.asc
wget --quiet https://www.owncloud.org/owncloud.asc
gpg --import --quiet owncloud.asc
gpg --verify --quiet owncloud-8.0.2.tar.bz2.asc owncloud-8.0.2.tar.bz2
tar -xjf owncloud-8.0.2.tar.bz2
sudo cp -r owncloud /var/www/
sudo cp /vagrant/owncloud.conf /etc/apache2/conf-available/
sudo ln -s /etc/apache2/conf-available/owncloud.conf /etc/apache2/conf-enabled/owncloud.conf
sudo a2enmod rewrite
sudo service apache2 restart
ocpath='/var/www/owncloud'
htuser='www-data'
find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750
mkdir -p ${ocpath}/data
touch ${ocpath}/data/.htaccess
chown -R root:${htuser} ${ocpath}/
chown -R ${htuser}:${htuser} ${ocpath}/apps/
chown -R ${htuser}:${htuser} ${ocpath}/config/
chown -R ${htuser}:${htuser} ${ocpath}/data/
chown root:${htuser} ${ocpath}/.htaccess
chown root:${htuser} ${ocpath}/data/.htaccess
chmod 0644 ${ocpath}/.htaccess
chmod 0644 ${ocpath}/data/.htaccess

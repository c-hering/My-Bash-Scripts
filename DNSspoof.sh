#!/bin/bash

PACMAN_OS=(Arch Manjaro Chakra DeLi Frugalware Parabola)


PACMAN_CONT{
	#pacman -Syu
	pacman -S apache
	pacman -S a2ensite

	mkdir /srv/http/$1
	echo "
	<html>
		<head>
			<title>Welcome to $1</title>
		</head>
		<body>
			<h1> Sucesssss </h1>
		</body>
	</html>
	" >> /srv/http/$1/index.html
	awk 'Include conf/extra/httpd-vhosts.conf { print; print "Include conf/extra/httpd-vhosts.conf"; }' /etc/httpd/conf/httpd.conf
	awk '<VirtualHost *:80> { print; print "ServerName $1"; print "ServerAlias www.$1"; print "DocumentRoot "/srv/http/$1""; }' /etc/httpd/conf/extra/httpd-vhosts.conf 
	echo "127.0.0.1		$1" >> /etc/hosts
	rc.d restart httpd
}

APTGET_CONT{
	apt-get upgrade
	apt-get install apache2
	apt-get install a2ensite

	mkdir -p /var/www/$1/public_html
	chown -R $USER:$USER  /var/www/$1/public_html
	chmod -R 755 /var/www
	echo "
	<html>
		<head>
			<title>Welcome to $1</title>
		</head>
		<body>
			<h1> Sucesssss </h1>
		</body>
	</html>
	" >> /var/www/$1/public_html/index.html
	cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$1.conf
	awk '<VirtualHost *:80> { print; print "ServerName $1"; print "ServerAlias www.$1"; print "DocumentRoot /var/www/$1/public_html"; }' /etc/apache2/sites-available/$1.conf 
	a2ensite $1.conf
	a2dissite 000-default.conf
	systemctl restart apache2
}


if [ $UID -ne 0 ]
then
	echo i am not groot
	echo please run as root
	exit 1
else
	echo i am groot
	for i in "${PACMAN_OS[@]}" 
	do 
		if [ name -o | grep -q PACMAN_OS[$i] ]
		then
			echo PACMAN ENABLED
			PACMAN_CONT	
		else
			echo APT GET ENABLED
			APTGET_CONT
		fi
	done	
fi	
# WSL2 Ubuntu 20.04

https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-20-04-de

# General

> - `sudo apt update`
> - `sudo apt upgrade`
> - `sudo apt autoremove`
> - `sudo apt install members`
> - `sudo apt install supervisor`
> - `sudo apt install composer`

# Apache

> - `sudo apt install apache2`

---

> - `cd /var/www/html`
> - `sudo rm index.html`
> - `cd /var`
> - `sudo chown -R USER:USERGROUP www`
> - `sudo chmod -R 775 www`
> - `sudo usermod -a -G USERGROUP www-data`
> - `sudo a2enmod rewrite`
> - `sudo service apache2 restart`

# PHP

https://linuxize.com/post/how-to-install-php-8-on-ubuntu-20-04/

> - `sudo apt install software-properties-common`
> - `sudo add-apt-repository ppa:ondrej/php`
> - `sudo apt install php7.4 libapache2-mod-php7.4`
> - `sudo apt install php7.4-mysql php7.4-curl php7.4-mbstring`
> - `sudo apt install php7.4-gd php7.4-imagick php7.4-zip php7.4-xml php7.4-xdebug`
> - `sudo service apache2 restart`
>   > ## PHP-FPM (FastCGI)
>   >
>   > - `sudo apt update`
>   > - `sudo apt install php7.4-fpm libapache2-mod-fcgid`
>   > - `sudo a2enmod proxy_fcgi setenvif actions fcgid alias`
>   > - `sudo a2enconf php7.4-fpm`
>   > - `sudo service apache2 restart`

---

> - `sudo apt update`
> - `sudo apt upgrade`

# MySQL

https://www.digitalocean.com/community/tutorials/how-to-install-mysql-on-ubuntu-20-04

> - `sudo apt install mysql-server`
> - `sudo service mysql start`

## Fix mysql-password

> - `sudo mysql`
> - `ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password by 'mynewpassword';`
> - `sudo mysql_secure_installation`

## MySQL Secure Installation

> - `set mysql-password for user 'root'`
> - `reenter mysql-password for user 'root'`
> - `delete anonymous user: y`
> - `dissallow root-login from network: y`
> - `remove test-database: y`
> - `reload privileges table: y`
> - `sudo mysql -uroot -p`

This should open mysql-cli

## Fix mysql home directory

If `sudo service mysql start` shows error 'Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock'' do:

> - `sudo service mysql stop`
> - `sudo usermod -d /var/lib/mysql/ mysql`
> - `sudo service mysql start`

The error should now be gone.

# PhpMyAdmin

- `sudo apt install phpmyadmin`
  > ## Upgrade PhpMyAdamin from lower version without default repository
  >
  > https://devanswers.co/manually-upgrade-phpmyadmin/  
  > Research for latest PhpMyAdmin version here: https://www.phpmyadmin.net/downloads/  
  > For version `5.2.0` there is a `config.sample.inc.php` located at `/usr/share/phpmyadmin`
  > use this file to copy and insert the 32-char blowfish_secret.

## PhpMyAdmin Blowfish Secret

https://www.hostnet.de/faq/was-bedeutet-ab-sofort-muss-ein-geheimes-passwort-zur-verschluesselung-in-der-konfigurationsdatei-gesetzt-werden-blowfish_secret.html

- `cd /usr/share/phpmyadmin`
- `sudo cp config.sample.inc.php config.inc.php`
- `sudo vim config.inc.php`
  > <pre>
  > $cfg['blowfish_secret'] = 'RANDOMPASSWORD';
  > </pre>

## Will kept in the documentation in case it is needed some time

- `sudo vi /etc/apache/conf-available/phpmyadmin.conf`
  > <pre>
  > Alias /phpmyadmin /usr/share/phpmyadmin
  > Alias /phpMyAdmin /usr/share/phpmyadmin
  > 
  > &lt;Directory /usr/share/phpmyadmin/>
  >   AddDefaultCharset UTF-8
  >   &lt;IfModule mod_authz_core.c>
  >      &lt;RequireAny>
  >      Require all granted
  >     &lt;/RequireAny>
  >   &lt;/IfModule>
  > &lt;/Directory>
  > 
  > &lt;Directory /usr/share/phpmyadmin/setup/>
  >   &lt;IfModule mod_authz_core.c>
  >     &lt;RequireAny>
  >       Require all granted
  >     &lt;/RequireAny>
  >   &lt;/IfModule>
  > &lt;/Directory>
  > </pre>
- `sudo a2enconf phpmyadmin`
- `sudo service apache2 restart`

## PHP FCGI

https://tecadmin.net/setup-apache-php-fpm-ubuntu-20-04/

- `sudo vim /etc/apache2/sites-available/000-default.conf`
  > <pre>
  > &lt;Directory /var/www/html>
  > 	Options -Indexes +FollowSymLinks +MultiViews
  >    	AllowOverride All
  >    	Require all granted
  > &lt;/Directory>
  > 
  > &lt;FilesMatch \.php$>
  > 	# 2.4.10+ can proxy to unix socket
  >    	SetHandler "proxy:unix:/var/run/php/php8.0-fpm.sock|fcgi://localhost"
  > &lt;/FilesMatch>
  > ``</pre>
- `cd /var/www/html`
- `vim info.php`
  > <pre>
  > &lt;?php
  > phpinfo();
  > </pre>

Each virtual host has to use this `<FileMatch>`-directive to ensure processing of php-files.

Request http://localhost/phpmyadmin to open login-page.

## PhpMyAdmin Blowfish Secret

https://www.hostnet.de/faq/was-bedeutet-ab-sofort-muss-ein-geheimes-passwort-zur-verschluesselung-in-der-konfigurationsdatei-gesetzt-werden-blowfish_secret.html

- `cd /usr/share/phpmyadmin`
- `sudo cp config.sample.inc.php config.inc.php`
- `sudo vim config.inc.php`
  > <pre>
  > $cfg['blowfish_secret'] = 'RANDOMPASSWORD';
  > </pre>

# VIM

- `cd ~`
- `vim .vimrc`
  > <pre>set number</pre>

# VSCode Remote-Server

- `cd ~/.vscode-server/server-env-setup`
  > <pre>umask 002</pre>

# WSL-Autostart

https://github.com/troytse/wsl-autostart
This only starts services for the wsl instance set as default

- `wsl --set-default Ubuntu-20.04`
- `sudo visudo`
  > <pre>
  > %sudo ALL=NOPASSWD: /etc/init.d/cron
  > %sudo ALL=NOPASSWD: /etc/init.d/mysql
  > %sudo ALL=NOPASSWD: /etc/init.d/apache2
  > %sudo ALL=NOPASSWD: /etc/init.d/php8.0-fpm
  > %sudo ALL=NOPASSWD: /etc/init.d/supervisor
  > </pre>

# WSL-Autostart Alternative

- `cd /usr/local/bin`
- `vim startup`
  > <pre>
  > /etc/init.d/cron start
  > /etc/init.d/mysql start
  > /etc/init.d/apache2 start
  > /etc/init.d/supervisor start
  > /etc/init.d/php8.0-fpm start
  > </pre>
- `chmod 700 startup`

# Tmux

- `sudo apt install tmux`
- `vim ~/.tmux.conf`
  > <pre>
  > set -g default-terminal "screen-256color"
  > </pre>

# Apache2 port-config for parallel WSL2 instances

https://ostechnix.com/how-to-change-apache-ftp-and-ssh-default-port-to-a-custom-port-part-1/

- `sudo vi /etc/apache2/ports.conf`
  > <pre>
  > Listen 8080
  > </pre>
- `sudo vi /etc/apache2/sites-available/000-default.conf`
  > <pre>
  > &lt;VirtualHost *:8080>
  > </pre>

# MySQL port-config for parallel WSL2 instances

https://github.com/microsoft/WSL/issues/2113#issuecomment-704856068

- `sudo vi /etc/mysql/mysql.conf.d/mysqld.cnf`
  > <pre>
  > port= 8090
  > </pre>

# Windows Host-file

> `127.0.0.1 local.vhost.tld` >`::1 local.vhost.tld`

# vhost-Script

Source https://github.com/RoverWire/virtualhost  
There are a few modifications compared to the source in the script below  
Make sure to create the file without the trailing ".sh"

- `cd /usr/local/bin`
- `sudo vim vhost`
  > <pre>
  > #!/bin/bash
  > ### Set Language
  > TEXTDOMAIN=virtualhost
  > 
  > ### Set default parameters
  > action=$1
  > domain=$2
  > relativeRootDir=${3:-''}
  > owner=
  > apacheUser=$(ps -ef | egrep '(httpd|apache2|apache)' | grep -v root | head -n1 | awk '{print $1}')
  > email=
  > sitesEnabled='/etc/apache2/sites-enabled/'
  > sitesAvailable='/etc/apache2/sites-available/'
  > webDir='/var/www/'
  > 
  > ### don't modify from here unless you know what you are doing ####
  > 
  > if [ "$(whoami)" != 'root' ]; then
  > 	echo $"You have no permission to run $0 as non-root user. Use sudo"
  > 		exit 1;
  > fi
  > 
  > if [ "$action" != 'create' ] && [ "$action" != 'delete' ]
  > 	then
  > 		echo $"You need to prompt for action (create or delete) -- Lower-case only"
  > 		exit 1;
  > fi
  > 
  > while [ "$domain" == "" ]
  > do
  > 	echo -e $"Please provide domain. e.g. dev.project.local"
  > 	read domain
  > done
  > 
  > if [ "$action" == 'create' ] && [ "$relativeRootDir" == '' ]; then
  > 	echo -e $"Is there a different root directory than $webDir$domain?\nPlease provide >the directory name. e.g. public"
  > 	read relativeRootDir
  > fi
  > 
  > appDir=$webDir$domain
  > webRoot=$appDir/$relativeRootDir
  > sitesAvailabledomain=$sitesAvailable$domain.conf
  > 
  > if [ "$action" == 'create' ]
  > 	then
  > 		### check if domain already exists
  > 		if [ -e $sitesAvailabledomain ]; then
  > 			echo -e $"This domain already exists.\nPlease Try Another one"
  > 			exit;
  > 		fi
  > 
  > 		### check if directory exists or not
  > 		if ! [ -d $appDir ]; then
  > 			### create the directory
  > 			mkdir $appDir
  >            		chown $owner:$owner $appDir
  > 			### give permission to root dir
  > 			chmod 775 $appDir
  > 
  > 			### create lower root directory if necessary
  >            		if ! ["$relativeRootDir" == ""]; then
  >                		mkdir $webRoot
  >                		chown $owner:$owner $webRoot
  >                		chmod 775 $webRoot
  >            		fi
  > 
  > 			### write test file in the new domain dir
  > 			if ! echo "<?php echo phpinfo(); ?>" > $webRoot/phpinfo.php
  > 			then
  > 				echo $"ERROR: Not able to write in file $webRoot/phpinfo.php. Please >check permissions"
  > 				exit;
  > 			else
  > 				echo $"Added content to $webRoot/phpinfo.php"
  > 			fi
  > 		fi
  > 
  > 		### create virtual host rules file
  > 		if ! echo "
  > </pre>
  > <pre>&lt;VirtualHost *:80></pre>
  > <pre>
  > 			ServerAdmin $email
  > 			ServerName $domain
  > 			ServerAlias $domain
  > 			DocumentRoot $webRoot
  > 			&lt;Directory />
  > 				AllowOverride All
  > 			&lt;/Directory>
  > 			&lt;Directory $webRoot>
  > 				Options +Indexes +FollowSymLinks +MultiViews
  > 				AllowOverride all
  > 				Require all granted
  > 			&lt;/Directory>
  > 			ErrorLog /var/log/apache2/$domain-error.log
  > 			LogLevel error
  > 			CustomLog /var/log/apache2/$domain-access.log combined
  > 		&lt;/VirtualHost>" > $sitesAvailabledomain
  > 		then
  > 			echo -e $"There is an ERROR creating $domain file"
  > 			exit;
  > 		else
  > 			echo -e $"\nNew Virtual Host Created\n"
  > 		fi
  > 
  > 		### Add domain in /etc/hosts
  > 		if ! echo "127.0.0.1	$domain" >> /etc/hosts
  > 		then
  > 			echo $"ERROR: Not able to write in /etc/hosts"
  > 			exit;
  > 		else
  > 			echo -e $"Host added to /etc/hosts file \n"
  > 		fi
  > 
  > 		### Add domain in /mnt/c/Windows/System32/drivers/etc/hosts (Windows Subsytem for Linux)
  > 		if [ -e /mnt/c/Windows/System32/drivers/etc/hosts ]
  > 		then
  > 			if ! sudo echo -e "\r127.0.0.1       $domain" >> /mnt/c/Windows/System32/drivers/etc/hosts
  > 			then
  > 				echo $"ERROR: Not able to write in /mnt/c/Windows/System32/drivers/etc/hosts (Hint: Try running Bash as administrator)"
  > 			else
  > 				echo -e $"Host added to /mnt/c/Windows/System32/drivers/etc/hosts file \n"
  > 			fi
  > 		fi
  > 
  > 		if [ "$owner" == "" ]; then
  > 			iam=$(whoami)
  > 			if [ "$iam" == "root" ]; then
  > 				chown -R $apacheUser:$apacheUser $appDir
  > 			else
  > 				chown -R $iam:$iam $appDir
  > 			fi
  > 		else
  > 			chown -R $owner:$owner $appDir
  > 		fi
  > 
  > 		### enable website
  > 		a2ensite $domain
  > 
  > 		### restart Apache
  > 		/etc/init.d/apache2 reload
  > 
  > 		### show the finished message
  > 		echo -e $"Complete! \nYou now have a new Virtual Host \nYour new host is: http://$domain \nAnd its located at $appDir"
  > 		exit;
  > 	else
  > 		### check whether domain already exists
  > 		if ! [ -e $sitesAvailabledomain ]; then
  > 			echo -e $"This domain does not exist.\nPlease try another one"
  > 			exit;
  > 		else
  > 			### Delete domain in /etc/hosts
  > 			newhost=${domain//./\\.}
  > 			sed -i "/$newhost/d" /etc/hosts
  > 
  > 			### Delete domain in /mnt/c/Windows/System32/drivers/etc/hosts (Windows Subsytem for Linux)
  > 			if [ -e /mnt/c/Windows/System32/drivers/etc/hosts ]
  > 			then
  > 				newhost=${domain//./\\.}
  > 				sed -i "/$newhost/d" /mnt/c/Windows/System32/drivers/etc/hosts
  > 			fi
  > 
  > 			### disable website
  > 			a2dissite $domain
  > 
  > 			### restart Apache
  > 			/etc/init.d/apache2 reload
  > 
  > 			### Delete virtual host rules files
  > 			rm $sitesAvailabledomain
  > 
  > 			### Delete virtual host log files
  > 			rm /var/log/apache2/$domain-error.log
  > 			rm /var/log/apache2/$domain-access.log
  > 		fi
  > 
  > 		### check if directory exists or not
  > 		if [ -d $appDir ]; then
  > 			echo -e $"Delete host root directory ? (y/n)"
  > 			read deldir
  > 
  > 			if [ "$deldir" == 'y' -o "$deldir" == 'Y' ]; then
  > 				### Delete the directory
  > 				rm -rf $appDir
  > 				
  > 				echo -e $"Directory deleted"
  > 			else
  > 				echo -e $"Host directory conserved"
  > 			fi
  > 		else
  > 			echo -e $"Host directory not found. Ignored"
  > 		fi
  > 
  > 		### show the finished message
  > 		echo -e $"Complete!\nYou just removed Virtual Host $domain"
  > 		exit 0;
  > fi
  > </pre>

## Add SSH-identity

https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-20-04-de

- `ssh-keygen`

### Add ssh-key permanently to avoid input passphrase everytime

https://askubuntu.com/questions/362280/enter-ssh-passphrase-once

- `ssh-agent bash`
- `ssh-add ~/.ssh/id_rsa`

# Directory permissions

## Create all new object as 664/ 775

- `sudo vim /etc/profile`

  > <pre>umask 002</pre>

- `vim ~/.profile`

  > <pre>umask 002</pre>

- `vim ~/.bashrc`

  > <pre>umask 002</pre>

- `setSource`

# PHP CS-Fixer

Install csfixer for PHP  
composer require friendsofphp/php-cs-fixer  
https://redberry.international/linting-a-laravel-project-using-cs-fixer/  
https://github.com/RedberryProducts/configs/blob/php-cs-fixer/.php-cs-fixer.php

# Aliases

- `vim ~/.bash_aliases`
  > <pre>
  > alias html='cd /var/www/html'
  > alias www='cd /var/www/'
  > alias ..='cd ../'
  > alias ...='cd ../../'
  > alias ....='cd ../../../'
  > 
  > ### PROGRAMS
  > alias explore='explorer.exe .'
  > 
  > ### GENERAL
  > alias setSource='source ~danaq/.bashrc'
  > alias apti='apt install -y'
  > 
  > ### GIT
  > alias gs='git status'
  > alias gc='git commit -m'
  > 
  > ### LARVEL
  > alias pa='php artisan'
  > alias pf='clear && ./vendor/bin/phpunit --filter'
  > alias punit='clear && ./vendor/bin/phpunit'
  > alias pest='clear && ./vendor/bin/pest'
  > 
  > ### SSH
  > alias ssh[XYZ]='ssh [SSH-USER]@[SERVER_DOMAIN]'
  </pre>

# Composer

https://www.digitalocean.com/community/tutorials/how-to-install-and-use-composer-on-ubuntu-20-04-de
